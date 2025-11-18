// Firestore user profile repository
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirestoreUserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get user profile from Firestore
  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      debugPrint('[FirestoreUserRepository] Error getting user profile: $e');
      rethrow;
    }
  }

  // Create user profile in Firestore
  Future<void> createUserProfile({
    required String uid,
    String? accountNumber,
    String? email,
    String? displayName,
    String? photoUrl,
    String? phoneNumber,
    String? authProvider,
  }) async {
    try {
      final accountNum = accountNumber ?? _generateAccountNumber(uid);

      await _firestore.collection('users').doc(uid).set({
        'accountNumber': accountNum,
        'email': email,
        'displayName': displayName,
        'photoUrl': photoUrl,
        'phoneNumber': phoneNumber,
        'authProvider': authProvider ?? 'email',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('[FirestoreUserRepository] Error creating user profile: $e');
      rethrow;
    }
  }

  // Update user profile
  Future<void> updateUserProfile(
    String uid,
    Map<String, dynamic> updates,
  ) async {
    try {
      updates['updatedAt'] = FieldValue.serverTimestamp();
      await _firestore.collection('users').doc(uid).update(updates);
    } catch (e) {
      debugPrint('[FirestoreUserRepository] Error updating user profile: $e');
      rethrow;
    }
  }

  // Get account number for user
  Future<String?> getAccountNumber(String uid) async {
    try {
      final profile = await getUserProfile(uid);
      return profile?['accountNumber'] as String?;
    } catch (e) {
      debugPrint('[FirestoreUserRepository] Error getting account number: $e');
      return null;
    }
  }

  // Generate account number from UID (fallback)
  String _generateAccountNumber(String uid) {
    // Use last 8 characters of UID, or generate from timestamp
    if (uid.length >= 8) {
      return '${uid.substring(uid.length - 8)}(C)';
    }
    // Fallback: use timestamp-based number
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '${timestamp.toString().substring(timestamp.toString().length - 8)}(C)';
  }
}
