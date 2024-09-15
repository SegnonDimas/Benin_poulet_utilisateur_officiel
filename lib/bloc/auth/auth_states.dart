part of 'auth_bloc.dart';

sealed class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String userId;

  AuthAuthenticated(this.userId);
}

/// connexion avec numéro de téléphone
class PhoneLoginRequestSuccess extends AuthState {
  final String? successMessage;
  final String uid;

  PhoneLoginRequestSuccess({this.successMessage, required this.uid});
}

class PhoneLoginRequestFailure extends AuthState {
  final String erroMessage;

  PhoneLoginRequestFailure({required this.erroMessage});
}

/// connexion avec email
class EmailLoginRequestSuccess extends AuthState {
  final String? successMessage;
  final String uid;

  EmailLoginRequestSuccess({this.successMessage, required this.uid});
}

class EmailLoginRequestFailure extends AuthState {
  final String erroMessage;

  EmailLoginRequestFailure({required this.erroMessage});
}

class AuthSignedUp extends AuthState {
  final String userId;

  AuthSignedUp(this.userId);
}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}
