part of 'auth_bloc.dart';

sealed class AuthEvent {}

/// Événements de connexion

// connexion avec compte Google
class GoogleLoginRequested extends AuthEvent {}

// connexion avec compte iCloud
class ICloudLoginRequested extends AuthEvent {}

// connexion avec Adresse Email
class EmailLoginRequested extends AuthEvent {
  final String email;
  final String password;

  EmailLoginRequested({required this.email, required this.password});
}

// connexion avec numéro de téléphone
class PhoneLoginRequested extends AuthEvent {
  final PhoneNumber phoneNumber;
  final String password;

  PhoneLoginRequested({required this.phoneNumber, required this.password});
}

/// Événements d'inscription

// inscription avec compte Google
class GoogleSignUpRequested extends AuthEvent {
  final String? userRole;

  GoogleSignUpRequested({this.userRole = UserRoles.BUYER});
}

// inscription avec compte iCloud
class ICloudSignUpRequested extends AuthEvent {
  final String? userRole;

  ICloudSignUpRequested({this.userRole = UserRoles.BUYER});
}

// inscription avec compte Email
class EmailSignUpRequested extends AuthEvent {
  final String? userRole;
  final String email;
  final String password;
  final String confirmPassword;

  EmailSignUpRequested({
    this.userRole = UserRoles.BUYER,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });
}

// inscription avec numéro de téléphone
class PhoneSignUpRequested extends AuthEvent {
  final String? userRole;
  final String firstName;
  final String lastName;
  final PhoneNumber phoneNumber;
  final String password;
  final String confirmPassword;

  PhoneSignUpRequested({
    this.userRole = UserRoles.BUYER,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.password,
    required this.confirmPassword,
  });
}
