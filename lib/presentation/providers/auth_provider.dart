// Authentication state provider
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/user.dart';
import '../../data/repositories/mock_data_repository.dart';
import '../../data/services/storage_service.dart';

final storageServiceProvider = Provider<StorageService>((ref) {
  throw UnimplementedError('StorageService must be initialized in main.dart');
});

class AuthNotifier extends StateNotifier<AsyncValue<User?>> {
  final StorageService _storageService;

  AuthNotifier(this._storageService) : super(const AsyncValue.loading()) {
    _loadUser();
  }

  Future<void> _loadUser() async {
    state = const AsyncValue.loading();
    try {
      final user = await _storageService.getUser();
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> login({bool rememberMe = false}) async {
    state = const AsyncValue.loading();
    try {
      // Mock login - always succeeds
      await Future.delayed(const Duration(seconds: 1));

      final user = MockDataRepository.getMockUser().copyWith(
        isLoggedIn: true,
        rememberMe: rememberMe,
      );

      if (rememberMe) {
        await _storageService.saveUser(user);
      }

      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    try {
      await _storageService.clearUser();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  bool get isLoggedIn {
    return state.value?.isLoggedIn ?? false;
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<User?>>((
  ref,
) {
  final storageService = ref.watch(storageServiceProvider);
  return AuthNotifier(storageService);
});
