part of 'auth_bloc.dart';

sealed class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthFailure extends AuthState {
  final String errorMessage;

  AuthFailure({required this.errorMessage});
}

class AuthAuthenticated extends AuthState {
  final String userId;

  AuthAuthenticated({required this.userId});
}

/// connexion avec numéro de téléphone
class PhoneLoginRequestSuccess extends AuthAuthenticated {
  final String? successMessage;

  PhoneLoginRequestSuccess({
    required super.userId,
    this.successMessage,
  });
}

class PhoneLoginRequestFailure extends AuthFailure {
  PhoneLoginRequestFailure({required super.errorMessage});
}

/// connexion avec email
class EmailLoginRequestSuccess extends AuthAuthenticated {
  final String? successMessage;

  EmailLoginRequestSuccess({this.successMessage, required super.userId});
}

class EmailLoginRequestFailure extends AuthFailure {
  EmailLoginRequestFailure({required super.errorMessage});
}

/// connexion avec Google
class GoogleLoginRequestSuccess extends AuthAuthenticated {
  GoogleLoginRequestSuccess({required super.userId});
}

class GoogleLoginRequestFailure extends AuthFailure {
  GoogleLoginRequestFailure({required super.errorMessage});
}

/// connexion avec iCloud
class ICloudLoginRequestSuccess extends AuthAuthenticated {
  ICloudLoginRequestSuccess({required super.userId});
}

class ICloudLoginRequestFailure extends AuthFailure {
  ICloudLoginRequestFailure({required super.errorMessage});
}

class PhoneSignUpRequestSuccess extends AuthAuthenticated {
  final String? successMessage;

  PhoneSignUpRequestSuccess({
    required super.userId,
    this.successMessage,
  });
}

/*class PhoneSignUpRequestFailure extends AuthFailure {
  PhoneSignUpRequestFailure({required super.errorMessage});
}*/

class AuthSignedUp extends AuthState {
  final String userId;

  AuthSignedUp(this.userId);
}
