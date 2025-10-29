// User model for authentication and session data
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String userId;
  final String accountNumber;
  final bool isLoggedIn;
  final bool rememberMe;

  const User({
    required this.userId,
    required this.accountNumber,
    this.isLoggedIn = false,
    this.rememberMe = false,
  });

  User copyWith({
    String? userId,
    String? accountNumber,
    bool? isLoggedIn,
    bool? rememberMe,
  }) {
    return User(
      userId: userId ?? this.userId,
      accountNumber: accountNumber ?? this.accountNumber,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      rememberMe: rememberMe ?? this.rememberMe,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'accountNumber': accountNumber,
      'isLoggedIn': isLoggedIn,
      'rememberMe': rememberMe,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'] as String,
      accountNumber: json['accountNumber'] as String,
      isLoggedIn: json['isLoggedIn'] as bool? ?? false,
      rememberMe: json['rememberMe'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [userId, accountNumber, isLoggedIn, rememberMe];
}
