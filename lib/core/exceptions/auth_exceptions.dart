// Custom authentication exceptions
class AuthException implements Exception {
  final String message;
  const AuthException(this.message);
  @override
  String toString() => message;
}

class InvalidCredentialsException extends AuthException {
  const InvalidCredentialsException([String? message])
    : super(message ?? 'Invalid email or password');
}

class UserNotFoundException extends AuthException {
  const UserNotFoundException([String? message])
    : super(message ?? 'User not found');
}

class EmailAlreadyInUseException extends AuthException {
  const EmailAlreadyInUseException([String? message])
    : super(message ?? 'Email is already registered');
}

class WeakPasswordException extends AuthException {
  const WeakPasswordException([String? message])
    : super(message ?? 'Password is too weak');
}

class NetworkException extends AuthException {
  const NetworkException([String? message])
    : super(message ?? 'Network error. Please check your connection');
}

class PhoneAuthException extends AuthException {
  const PhoneAuthException([String? message])
    : super(message ?? 'Phone authentication failed');
}

class TooManyRequestsException extends AuthException {
  const TooManyRequestsException([String? message])
    : super(message ?? 'Too many requests. Please try again later');
}
