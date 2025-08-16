import 'package:intl_phone_number_input/intl_phone_number_input.dart';

/// Service de validation pour les formulaires d'authentification
class ValidationService {
  /// Valide un numéro de téléphone béninois
  static String? validateBeninPhoneNumber(PhoneNumber? phoneNumber) {
    if (phoneNumber == null || phoneNumber.phoneNumber == null) {
      return 'Veuillez saisir votre numéro de téléphone';
    }

    final fullNumber = phoneNumber.phoneNumber!.trim();
    final dialCode = phoneNumber.dialCode ?? '+229';

    // Vérification spécifique au Bénin
    if (dialCode == '+229') {
      final nationalNumber = fullNumber.replaceFirst(dialCode, '').trim();

      if (nationalNumber.isEmpty) {
        return 'Veuillez saisir votre numéro de téléphone';
      }

      if (nationalNumber.length != 10) {
        return 'Le numéro de téléphone doit comporter 10 chiffres';
      }

      if (!nationalNumber.startsWith('01')) {
        return 'Le numéro de téléphone doit commencer par 01 pour le Bénin';
      }

      // Vérifier que ce sont bien des chiffres
      if (!RegExp(r'^[0-9]+$').hasMatch(nationalNumber)) {
        return 'Le numéro de téléphone ne doit contenir que des chiffres';
      }
    }

    return null; // Valide
  }

  /// Valide une adresse email
  static String? validateEmail(String? email) {
    if (email == null || email.trim().isEmpty) {
      return 'Veuillez saisir votre adresse email';
    }

    final trimmedEmail = email.trim();

    // Expression régulière pour valider l'email
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );

    if (!emailRegex.hasMatch(trimmedEmail)) {
      return 'Veuillez saisir une adresse email valide';
    }

    // Vérifications supplémentaires
    if (trimmedEmail.length > 254) {
      return 'L\'adresse email est trop longue';
    }

    if (trimmedEmail.split('@')[0].length > 64) {
      return 'La partie locale de l\'email est trop longue';
    }

    return null; // Valide
  }

  /// Valide un mot de passe
  static String? validatePassword(String? password, {int minLength = 6}) {
    if (password == null || password.isEmpty) {
      return 'Veuillez saisir votre mot de passe';
    }

    if (password.length < minLength) {
      return 'Le mot de passe doit contenir au moins $minLength caractères';
    }

    // Vérifications de sécurité optionnelles
    if (password.length > 128) {
      return 'Le mot de passe est trop long';
    }

    return null; // Valide
  }

  /// Valide la confirmation d'un mot de passe
  static String? validatePasswordConfirmation(
      String? password, String? confirmation) {
    if (confirmation == null || confirmation.isEmpty) {
      return 'Veuillez confirmer votre mot de passe';
    }

    if (password != confirmation) {
      return 'Les mots de passe ne correspondent pas';
    }

    return null; // Valide
  }

  /// Valide un nom (prénom ou nom de famille)
  static String? validateName(String? name, String fieldName) {
    if (name == null || name.trim().isEmpty) {
      return 'Veuillez saisir votre $fieldName';
    }

    final trimmedName = name.trim();

    if (trimmedName.length < 2) {
      return 'Le $fieldName doit contenir au moins 2 caractères';
    }

    if (trimmedName.length > 50) {
      return 'Le $fieldName est trop long';
    }

    // Vérifier que le nom ne contient que des lettres, espaces et tirets
    if (!RegExp(r'^[a-zA-ZÀ-ÿ\s\-]+$').hasMatch(trimmedName)) {
      return 'Le $fieldName ne doit contenir que des lettres';
    }

    return null; // Valide
  }

  /// Valide un formulaire de connexion par téléphone
  static Map<String, String?> validatePhoneLoginForm({
    PhoneNumber? phoneNumber,
    String? password,
  }) {
    return {
      'phoneNumber': validateBeninPhoneNumber(phoneNumber),
      'password': validatePassword(password),
    };
  }

  /// Valide un formulaire de connexion par email
  static Map<String, String?> validateEmailLoginForm({
    String? email,
    String? password,
  }) {
    return {
      'email': validateEmail(email),
      'password': validatePassword(password),
    };
  }

  /// Valide un formulaire d'inscription
  static Map<String, String?> validateSignupForm({
    String? firstName,
    String? lastName,
    PhoneNumber? phoneNumber,
    String? email,
    String? password,
    String? confirmPassword,
  }) {
    return {
      'firstName': validateName(firstName, 'prénom'),
      'lastName': validateName(lastName, 'nom de famille'),
      'phoneNumber': validateBeninPhoneNumber(phoneNumber),
      'email': validateEmail(email),
      'password': validatePassword(password),
      'confirmPassword':
          validatePasswordConfirmation(password, confirmPassword),
    };
  }

  /// Vérifie si un formulaire est valide
  static bool isFormValid(Map<String, String?> validations) {
    return validations.values.every((error) => error == null);
  }

  /// Retourne le premier message d'erreur d'un formulaire
  static String? getFirstError(Map<String, String?> validations) {
    for (final error in validations.values) {
      if (error != null) {
        return error;
      }
    }
    return null;
  }

  /// Retourne tous les messages d'erreur d'un formulaire
  static List<String> getAllErrors(Map<String, String?> validations) {
    return validations.values
        .where((error) => error != null)
        .cast<String>()
        .toList();
  }
}
