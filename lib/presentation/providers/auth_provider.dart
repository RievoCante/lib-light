// Authentication state provider
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/user.dart';
import '../../data/repositories/firebase_auth_repository.dart';
import '../../data/repositories/firestore_user_repository.dart';
import '../../data/services/storage_service.dart';

final firebaseAuthRepositoryProvider = Provider<FirebaseAuthRepository>((ref) {
  return FirebaseAuthRepository();
});

final firestoreUserRepositoryProvider = Provider<FirestoreUserRepository>((
  ref,
) {
  return FirestoreUserRepository();
});

final storageServiceProvider = Provider<StorageService>((ref) {
  throw UnimplementedError('StorageService must be initialized in main.dart');
});

class AuthNotifier extends StateNotifier<AsyncValue<User?>> {
  final FirebaseAuthRepository _authRepository;
  final FirestoreUserRepository _userRepository;
  final StorageService _storageService;
  StreamSubscription<firebase_auth.User?>? _authStateSubscription;

  AuthNotifier(this._authRepository, this._userRepository, this._storageService)
    : super(const AsyncValue.loading()) {
    _listenToAuthState();
  }

  void _listenToAuthState() {
    _authStateSubscription?.cancel();
    _authStateSubscription = _authRepository.authStateChanges.listen(
      (firebaseUser) async {
        if (firebaseUser == null) {
          state = const AsyncValue.data(null);
          return;
        }

        await _loadUserFromFirebase(firebaseUser);
      },
      onError: (error, stackTrace) {
        debugPrint('[AuthNotifier] Auth state error: $error');
        state = AsyncValue.error(error, stackTrace);
      },
    );
  }

  Future<void> _loadUserFromFirebase(firebase_auth.User firebaseUser) async {
    state = const AsyncValue.loading();
    try {
      // Get user profile from Firestore
      final profile = await _userRepository.getUserProfile(firebaseUser.uid);

      // Get rememberMe preference
      final rememberMe = await _getRememberMePreference();

      // Determine auth provider
      String authProvider = 'email';
      if (firebaseUser.providerData.any((p) => p.providerId == 'google.com')) {
        authProvider = 'google';
      } else if (firebaseUser.providerData.any(
        (p) => p.providerId == 'phone',
      )) {
        authProvider = 'phone';
      }

      // Map Firebase User to app User model
      final user = User(
        uid: firebaseUser.uid,
        email: firebaseUser.email,
        displayName: firebaseUser.displayName,
        photoUrl: firebaseUser.photoURL,
        phoneNumber: firebaseUser.phoneNumber,
        accountNumber: profile?['accountNumber'] as String?,
        authProvider: authProvider,
        rememberMe: rememberMe,
      );

      state = AsyncValue.data(user);
    } catch (e, st) {
      debugPrint('[AuthNotifier] Error loading user: $e');
      state = AsyncValue.error(e, st);
    }
  }

  // Email/Password Login
  Future<void> loginWithEmail({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    try {
      await _saveRememberMePreference(rememberMe);
      await _authRepository.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Auth state listener will update the state automatically
    } catch (e) {
      debugPrint('[AuthNotifier] Email login error: $e');
      rethrow;
    }
  }

  // Email/Password Sign Up
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
    bool rememberMe = false,
  }) async {
    try {
      await _saveRememberMePreference(rememberMe);
      final credential = await _authRepository.signUpWithEmailAndPassword(
        email: email,
        password: password,
        displayName: displayName,
      );

      // Create user profile in Firestore
      if (credential.user != null) {
        await _userRepository.createUserProfile(
          uid: credential.user!.uid,
          email: email,
          displayName: displayName,
          authProvider: 'email',
        );
      }
      // Auth state listener will update the state automatically
    } catch (e) {
      debugPrint('[AuthNotifier] Email signup error: $e');
      rethrow;
    }
  }

  // Google Sign In
  Future<void> loginWithGoogle({bool rememberMe = false}) async {
    try {
      await _saveRememberMePreference(rememberMe);
      final credential = await _authRepository.signInWithGoogle();

      // Create or update user profile in Firestore
      if (credential.user != null) {
        final existingProfile = await _userRepository.getUserProfile(
          credential.user!.uid,
        );
        if (existingProfile == null) {
          await _userRepository.createUserProfile(
            uid: credential.user!.uid,
            email: credential.user!.email,
            displayName: credential.user!.displayName,
            photoUrl: credential.user!.photoURL,
            authProvider: 'google',
          );
        }
      }
      // Auth state listener will update the state automatically
    } catch (e) {
      debugPrint('[AuthNotifier] Google login error: $e');
      rethrow;
    }
  }

  // Phone Authentication - Send verification code
  Future<void> loginWithPhoneNumber({
    required String phoneNumber,
    required Function(String verificationId) codeSent,
    required Function(String error) verificationFailed,
    bool rememberMe = false,
  }) async {
    try {
      await _saveRememberMePreference(rememberMe);
      await _authRepository.signInWithPhoneNumber(
        phoneNumber: phoneNumber,
        codeSent: (verificationId) {
          codeSent(verificationId);
        },
        verificationFailed: (error) {
          verificationFailed(error);
        },
        verificationCompleted: (credential) async {
          // Auto-verification completed
          final user = credential.user;
          if (user != null) {
            final existingProfile = await _userRepository.getUserProfile(
              user.uid,
            );
            if (existingProfile == null) {
              await _userRepository.createUserProfile(
                uid: user.uid,
                phoneNumber: user.phoneNumber,
                authProvider: 'phone',
              );
            }
          }
        },
        codeAutoRetrievalTimeout: (error) {
          debugPrint('[AuthNotifier] Code auto-retrieval timeout: $error');
        },
      );
    } catch (e) {
      debugPrint('[AuthNotifier] Phone login error: $e');
      rethrow;
    }
  }

  // Verify phone number with SMS code
  Future<void> verifyPhoneNumber({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      final credential = await _authRepository.verifyPhoneNumber(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      // Create user profile if new user
      if (credential.user != null) {
        final existingProfile = await _userRepository.getUserProfile(
          credential.user!.uid,
        );
        if (existingProfile == null) {
          await _userRepository.createUserProfile(
            uid: credential.user!.uid,
            phoneNumber: credential.user!.phoneNumber,
            authProvider: 'phone',
          );
        }
      }
      // Auth state listener will update the state automatically
    } catch (e) {
      debugPrint('[AuthNotifier] Phone verification error: $e');
      rethrow;
    }
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _authRepository.sendPasswordResetEmail(email);
    } catch (e) {
      debugPrint('[AuthNotifier] Password reset error: $e');
      rethrow;
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await _authRepository.signOut();
      await _saveRememberMePreference(false);
      // Auth state listener will update the state automatically
    } catch (e) {
      debugPrint('[AuthNotifier] Logout error: $e');
      rethrow;
    }
  }

  // Remember Me preference helpers
  Future<bool> _getRememberMePreference() async {
    try {
      // Store in SharedPreferences for simplicity
      final prefs = await _storageService.getSharedPreferences();
      return prefs.getBool('remember_me') ?? false;
    } catch (e) {
      return false;
    }
  }

  Future<void> _saveRememberMePreference(bool value) async {
    try {
      final prefs = await _storageService.getSharedPreferences();
      await prefs.setBool('remember_me', value);
    } catch (e) {
      debugPrint('[AuthNotifier] Error saving rememberMe: $e');
    }
  }

  @override
  void dispose() {
    _authStateSubscription?.cancel();
    super.dispose();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<User?>>((
  ref,
) {
  final authRepo = ref.watch(firebaseAuthRepositoryProvider);
  final userRepo = ref.watch(firestoreUserRepositoryProvider);
  final storageService = ref.watch(storageServiceProvider);
  return AuthNotifier(authRepo, userRepo, storageService);
});
