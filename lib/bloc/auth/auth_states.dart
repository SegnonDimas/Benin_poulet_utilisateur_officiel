part of 'auth_bloc.dart';

sealed class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthFailure extends AuthState {
  final String errorMessage;

  AuthFailure({required this.errorMessage});
}

class AuthAuthenticated extends AuthState {
  final String? successMessage;

  AuthAuthenticated({this.successMessage});
}

/// connexion avec numéro de téléphone
class PhoneLoginRequestSuccess extends AuthAuthenticated {
  //final String? successMessage;

  PhoneLoginRequestSuccess({
    //required super.userId,
    super.successMessage,
  });
}

class PhoneLoginRequestFailure extends AuthFailure {
  PhoneLoginRequestFailure({required super.errorMessage});
}

/// connexion avec email
class EmailLoginRequestSuccess extends AuthAuthenticated {
  //final String? successMessage;

  EmailLoginRequestSuccess({super.successMessage});
}

class EmailLoginRequestFailure extends AuthFailure {
  EmailLoginRequestFailure({required super.errorMessage});
}

/// connexion avec Google
class GoogleLoginRequestSuccess extends AuthAuthenticated {
  GoogleLoginRequestSuccess({super.successMessage});
}

class GoogleLoginRequestFailure extends AuthFailure {
  GoogleLoginRequestFailure({required super.errorMessage});
}

/// connexion avec iCloud
class ICloudLoginRequestSuccess extends AuthAuthenticated {
  ICloudLoginRequestSuccess({super.successMessage});
}

class ICloudLoginRequestFailure extends AuthFailure {
  ICloudLoginRequestFailure({required super.errorMessage});
}

class PhoneSignUpRequestSuccess extends AuthAuthenticated {
  //final String? successMessage;

  PhoneSignUpRequestSuccess({
    //required super.userId,
    super.successMessage,
  });
}

/*class PhoneSignUpRequestFailure extends AuthFailure {
  PhoneSignUpRequestFailure({required super.errorMessage});
}*/

class AuthSignedUp extends AuthState {
  final String userId;

  AuthSignedUp(this.userId);
}
