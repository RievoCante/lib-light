// User model for authentication and session data
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String uid; // Firebase Auth UID (replaces userId)
  final String? email;
  final String? displayName;
  final String? photoUrl;
  final String? phoneNumber;
  final String? accountNumber; // From Firestore user profile
  final String authProvider; // 'email', 'google', 'phone'
  final bool rememberMe;

  const User({
    required this.uid,
    this.email,
    this.displayName,
    this.photoUrl,
    this.phoneNumber,
    this.accountNumber,
    required this.authProvider,
    this.rememberMe = false,
  });

  // Backward compatibility: userId maps to uid
  String get userId => uid;

  User copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoUrl,
    String? phoneNumber,
    String? accountNumber,
    String? authProvider,
    bool? rememberMe,
  }) {
    return User(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      accountNumber: accountNumber ?? this.accountNumber,
      authProvider: authProvider ?? this.authProvider,
      rememberMe: rememberMe ?? this.rememberMe,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'phoneNumber': phoneNumber,
      'accountNumber': accountNumber,
      'authProvider': authProvider,
      'rememberMe': rememberMe,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'] as String? ?? json['userId'] as String? ?? '',
      email: json['email'] as String?,
      displayName: json['displayName'] as String?,
      photoUrl: json['photoUrl'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      accountNumber: json['accountNumber'] as String?,
      authProvider: json['authProvider'] as String? ?? 'email',
      rememberMe: json['rememberMe'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [
    uid,
    email,
    displayName,
    photoUrl,
    phoneNumber,
    accountNumber,
    authProvider,
    rememberMe,
  ];
}
