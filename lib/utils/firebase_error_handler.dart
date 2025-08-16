import 'package:firebase_auth/firebase_auth.dart';

/// Classe utilitaire pour gérer les erreurs Firebase de manière claire
class FirebaseErrorHandler {
  /// Traite les erreurs d'authentification Firebase et retourne un message clair
  static String handleAuthError(dynamic error) {
    if (error is FirebaseAuthException) {
      return _getAuthErrorMessage(error.code);
    } else if (error is String) {
      return _getStringErrorMessage(error);
    } else {
      return _getGenericErrorMessage(error);
    }
  }

  /// Traite les erreurs spécifiques à Firebase Auth
  static String _getAuthErrorMessage(String errorCode) {
    switch (errorCode) {
      // Erreurs de connexion par email/mot de passe
      case 'user-not-found':
        return 'Aucun compte trouvé avec ces identifiants. Vérifiez votre email ou numéro de téléphone.';

      case 'wrong-password':
        return 'Mot de passe incorrect. Veuillez vérifier votre mot de passe.';

      case 'invalid-email':
        return 'Format d\'adresse email invalide. Veuillez saisir une adresse email valide.';

      case 'user-disabled':
        return 'Ce compte a été désactivé. Contactez le support pour plus d\'informations.';

      case 'too-many-requests':
        return 'Trop de tentatives de connexion. Veuillez attendre quelques minutes avant de réessayer.';

      case 'operation-not-allowed':
        return 'Cette méthode de connexion n\'est pas autorisée. Contactez le support.';

      case 'weak-password':
        return 'Le mot de passe est trop faible. Il doit contenir au moins 6 caractères.';

      case 'email-already-in-use':
        return 'Cette adresse email est déjà utilisée par un autre compte.';

      case 'invalid-credential':
        return 'Identifiants invalides. Vérifiez votre email/numéro et mot de passe.';

      case 'account-exists-with-different-credential':
        return 'Un compte existe déjà avec cette adresse email mais avec une méthode de connexion différente.';

      case 'requires-recent-login':
        return 'Cette opération nécessite une connexion récente. Veuillez vous reconnecter.';

      case 'network-request-failed':
        return 'Erreur de réseau. Vérifiez votre connexion internet et réessayez.';

      case 'user-token-expired':
        return 'Votre session a expiré. Veuillez vous reconnecter.';

      case 'invalid-user-token':
        return 'Session invalide. Veuillez vous reconnecter.';

      case 'user-mismatch':
        return 'Erreur de correspondance utilisateur. Veuillez vous reconnecter.';

      case 'credential-already-in-use':
        return 'Ces identifiants sont déjà utilisés par un autre compte.';

      case 'invalid-verification-code':
        return 'Code de vérification invalide. Veuillez réessayer.';

      case 'invalid-verification-id':
        return 'ID de vérification invalide. Veuillez réessayer.';

      case 'quota-exceeded':
        return 'Limite de requêtes dépassée. Veuillez réessayer plus tard.';

      case 'app-not-authorized':
        return 'Application non autorisée. Contactez le support.';

      case 'keychain-error':
        return 'Erreur de stockage sécurisé. Veuillez réessayer.';

      case 'internal-error':
        return 'Erreur interne. Veuillez réessayer dans quelques instants.';

      case 'invalid-app-credential':
        return 'Identifiants d\'application invalides. Contactez le support.';

      case 'captcha-check-failed':
        return 'Vérification de sécurité échouée. Veuillez réessayer.';

      case 'missing-app-credential':
        return 'Identifiants d\'application manquants. Contactez le support.';

      case 'session-expired':
        return 'Session expirée. Veuillez vous reconnecter.';

      case 'invalid-phone-number':
        return 'Format de numéro de téléphone invalide. Veuillez vérifier le format.';

      case 'invalid-verification-id':
        return 'ID de vérification invalide. Veuillez réessayer.';

      case 'missing-verification-id':
        return 'ID de vérification manquant. Veuillez réessayer.';

      case 'missing-verification-code':
        return 'Code de vérification manquant. Veuillez saisir le code reçu.';

      case 'invalid-recipient-email':
        return 'Adresse email de destinataire invalide.';

      case 'invalid-sender':
        return 'Expéditeur invalide. Contactez le support.';

      case 'invalid-message-payload':
        return 'Contenu du message invalide. Contactez le support.';

      case 'invalid-recipient':
        return 'Destinataire invalide. Contactez le support.';

      case 'missing-iframe-start':
        return 'Erreur de configuration. Contactez le support.';

      case 'auth-domain-config-required':
        return 'Configuration de domaine requise. Contactez le support.';

      case 'missing-app-token':
        return 'Token d\'application manquant. Contactez le support.';

      case 'missing-continue-uri':
        return 'URI de continuation manquante. Contactez le support.';

      case 'missing-ios-bundle-id':
        return 'ID de bundle iOS manquant. Contactez le support.';

      case 'missing-android-pkg-name':
        return 'Nom du package Android manquant. Contactez le support.';

      case 'unauthorized-continue-uri':
        return 'URI de continuation non autorisée. Contactez le support.';

      case 'dynamic-link-not-activated':
        return 'Lien dynamique non activé. Contactez le support.';

      case 'invalid-dynamic-link-domain':
        return 'Domaine de lien dynamique invalide. Contactez le support.';

      case 'rejected-credential':
        return 'Identifiants rejetés. Veuillez vérifier vos informations.';

      case 'phone-number-already-exists':
        return 'Ce numéro de téléphone est déjà utilisé par un autre compte.';

      case 'project-not-found':
        return 'Projet non trouvé. Contactez le support.';

      case 'insufficient-permission':
        return 'Permissions insuffisantes. Contactez le support.';

      case 'invalid-api-key':
        return 'Clé API invalide. Contactez le support.';

      case 'app-deleted':
        return 'Application supprimée. Contactez le support.';

      case 'app-not-authorized':
        return 'Application non autorisée. Contactez le support.';

      case 'argument-error':
        return 'Erreur d\'argument. Veuillez vérifier vos informations.';

      case 'invalid-tenant-id':
        return 'ID de locataire invalide. Contactez le support.';

      case 'tenant-id-mismatch':
        return 'Incompatibilité d\'ID de locataire. Contactez le support.';

      case 'unsupported-tenant-operation':
        return 'Opération de locataire non prise en charge. Contactez le support.';

      case 'invalid-login-credentials':
        return 'Identifiants de connexion invalides. Vérifiez votre email/numéro et mot de passe.';

      case 'invalid-oauth-client-id':
        return 'ID client OAuth invalide. Contactez le support.';

      case 'invalid-oauth-provider':
        return 'Fournisseur OAuth invalide. Contactez le support.';

      case 'invalid-oauth-provider-id':
        return 'ID de fournisseur OAuth invalide. Contactez le support.';

      case 'invalid-oauth-provider-credential':
        return 'Identifiants de fournisseur OAuth invalides. Contactez le support.';

      case 'invalid-oauth-provider-credential-id':
        return 'ID d\'identifiants de fournisseur OAuth invalide. Contactez le support.';

      case 'invalid-oauth-provider-credential-secret':
        return 'Secret d\'identifiants de fournisseur OAuth invalide. Contactez le support.';

      case 'invalid-oauth-provider-credential-token':
        return 'Token d\'identifiants de fournisseur OAuth invalide. Contactez le support.';

      case 'invalid-oauth-provider-credential-token-secret':
        return 'Secret de token d\'identifiants de fournisseur OAuth invalide. Contactez le support.';

      case 'invalid-oauth-provider-credential-token-type':
        return 'Type de token d\'identifiants de fournisseur OAuth invalide. Contactez le support.';

      case 'invalid-oauth-provider-credential-token-scope':
        return 'Portée de token d\'identifiants de fournisseur OAuth invalide. Contactez le support.';

      case 'invalid-oauth-provider-credential-token-expires-in':
        return 'Expiration de token d\'identifiants de fournisseur OAuth invalide. Contactez le support.';

      case 'invalid-oauth-provider-credential-token-expires-at':
        return 'Date d\'expiration de token d\'identifiants de fournisseur OAuth invalide. Contactez le support.';

      case 'invalid-oauth-provider-credential-token-issued-at':
        return 'Date d\'émission de token d\'identifiants de fournisseur OAuth invalide. Contactez le support.';

      case 'invalid-oauth-provider-credential-token-not-before':
        return 'Date de début de validité de token d\'identifiants de fournisseur OAuth invalide. Contactez le support.';

      case 'invalid-oauth-provider-credential-token-jti':
        return 'JTI de token d\'identifiants de fournisseur OAuth invalide. Contactez le support.';

      case 'invalid-oauth-provider-credential-token-aud':
        return 'Audience de token d\'identifiants de fournisseur OAuth invalide. Contactez le support.';

      case 'invalid-oauth-provider-credential-token-iss':
        return 'Émetteur de token d\'identifiants de fournisseur OAuth invalide. Contactez le support.';

      case 'invalid-oauth-provider-credential-token-sub':
        return 'Sujet de token d\'identifiants de fournisseur OAuth invalide. Contactez le support.';

      case 'invalid-oauth-provider-credential-token-iat':
        return 'IAT de token d\'identifiants de fournisseur OAuth invalide. Contactez le support.';

      case 'invalid-oauth-provider-credential-token-exp':
        return 'EXP de token d\'identifiants de fournisseur OAuth invalide. Contactez le support.';

      case 'invalid-oauth-provider-credential-token-nbf':
        return 'NBF de token d\'identifiants de fournisseur OAuth invalide. Contactez le support.';

      case 'invalid-oauth-provider-credential-token-jti':
        return 'JTI de token d\'identifiants de fournisseur OAuth invalide. Contactez le support.';

      default:
        return 'Une erreur inattendue s\'est produite. Veuillez réessayer ou contacter le support.';
    }
  }

  /// Traite les erreurs sous forme de chaîne
  static String _getStringErrorMessage(String error) {
    final lowerError = error.toLowerCase();

    if (lowerError.contains('network') || lowerError.contains('connection')) {
      return 'Erreur de réseau. Vérifiez votre connexion internet et réessayez.';
    } else if (lowerError.contains('timeout')) {
      return 'Délai d\'attente dépassé. Vérifiez votre connexion et réessayez.';
    } else if (lowerError.contains('cancelled') ||
        lowerError.contains('canceled')) {
      return 'Opération annulée.';
    } else if (lowerError.contains('permission') ||
        lowerError.contains('access')) {
      return 'Permission refusée. Veuillez autoriser l\'accès requis.';
    } else if (lowerError.contains('not found')) {
      return 'Ressource non trouvée. Veuillez vérifier vos informations.';
    } else if (lowerError.contains('invalid')) {
      return 'Données invalides. Veuillez vérifier vos informations.';
    } else if (lowerError.contains('server')) {
      return 'Erreur serveur. Veuillez réessayer dans quelques instants.';
    } else {
      return 'Une erreur s\'est produite: $error';
    }
  }

  /// Traite les erreurs génériques
  static String _getGenericErrorMessage(dynamic error) {
    if (error == null) {
      return 'Erreur inconnue. Veuillez réessayer.';
    }

    final errorString = error.toString().toLowerCase();

    if (errorString.contains('null')) {
      return 'Données manquantes. Veuillez remplir tous les champs requis.';
    } else if (errorString.contains('format')) {
      return 'Format invalide. Veuillez vérifier vos informations.';
    } else if (errorString.contains('empty')) {
      return 'Champs vides. Veuillez remplir tous les champs requis.';
    } else {
      return 'Une erreur inattendue s\'est produite. Veuillez réessayer.';
    }
  }

  /// Vérifie si l'erreur est liée au réseau
  static bool isNetworkError(dynamic error) {
    if (error is FirebaseAuthException) {
      return error.code == 'network-request-failed';
    } else if (error is String) {
      return error.toLowerCase().contains('network') ||
          error.toLowerCase().contains('connection') ||
          error.toLowerCase().contains('timeout');
    }
    return false;
  }

  /// Vérifie si l'erreur est liée à des identifiants invalides
  static bool isCredentialError(dynamic error) {
    if (error is FirebaseAuthException) {
      return error.code == 'user-not-found' ||
          error.code == 'wrong-password' ||
          error.code == 'invalid-email' ||
          error.code == 'invalid-phone-number' ||
          error.code == 'invalid-credential';
    }
    return false;
  }

  /// Vérifie si l'erreur nécessite une action de l'utilisateur
  static bool requiresUserAction(dynamic error) {
    if (error is FirebaseAuthException) {
      return error.code == 'user-not-found' ||
          error.code == 'wrong-password' ||
          error.code == 'invalid-email' ||
          error.code == 'invalid-phone-number' ||
          error.code == 'weak-password';
    }
    return false;
  }
}
