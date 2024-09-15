part of 'auth_bloc.dart';

sealed class AuthEvent {}

/// Événements de connexion

// connexion avec compte Google
class GoogleLoginRequested extends AuthEvent {}

// connexion avec compte iCloud
class AppleLoginRequested extends AuthEvent {}

// connexion avec Adresse Email
class EmailLoginRequested extends AuthEvent {
  final String email;
  final String password;

  EmailLoginRequested({required this.email, required this.password});
}

// connexion avec numéro de téléphone
class PhoneLoginRequested extends AuthEvent {
  final String phoneNumber;
  final String password;

  PhoneLoginRequested({required this.phoneNumber, required this.password});
}

/// Événements d'inscription

// inscription avec compte Google
class GoogleSignUpRequested extends AuthEvent {}

// inscription avec compte iCloud
class AppleSignUpRequested extends AuthEvent {}

// inscription avec compte Email
class EmailSignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String confirmPassword;

  EmailSignUpRequested({
    required this.email,
    required this.password,
    required this.confirmPassword,
  });
}

// inscription avec numéro de téléphone
class PhoneSignUpRequested extends AuthEvent {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String password;
  final String confirmPassword;

  PhoneSignUpRequested({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.password,
    required this.confirmPassword,
  });
}
