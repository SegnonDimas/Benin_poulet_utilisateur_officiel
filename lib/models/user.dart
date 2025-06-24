import 'package:benin_poulet/constants/accountStatus.dart';

import '../constants/authProviders.dart';
import '../constants/userRoles.dart';

class AppUser {
  final String userId;
  final String authProvider; // phone, email, google, icloud, anonymous
  final String? authIdentifier; // numéro, email, id externe, etc.
  final String? fullName;
  final String? photoUrl;
  final String accountStatus;
  final String role;
  final List<String>? storeIds;
  final bool isAnonymous;
  final bool profileComplete;
  final DateTime? createdAt;
  final DateTime? lastLogin;

  const AppUser({
    required this.userId,
    this.authProvider = AuthProviders.ANONYMOUS,
    this.authIdentifier,
    this.fullName,
    this.photoUrl,
    this.accountStatus = AccountStatus.ACTIVE,
    this.role = UserRoles.VISITOR,
    this.storeIds = const [],
    this.profileComplete = false,
    this.isAnonymous = true,
    this.createdAt,
    this.lastLogin,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'authProvider': authProvider,
      'authIdentifier': authIdentifier,
      'fullName': fullName,
      'photoUrl': photoUrl,
      'accountStatus': accountStatus,
      'role': role,
      'storeIds': storeIds,
      'isAnonymous': isAnonymous,
      'profileComplete': profileComplete,
      'createdAt': createdAt?.toIso8601String(),
      'lastLogin': lastLogin?.toIso8601String(),
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      userId: map['userId'],
      authProvider: map['authProvider'] ?? AuthProviders.ANONYMOUS,
      authIdentifier: map['authIdentifier'],
      fullName: map['fullName'],
      photoUrl: map['photoUrl'],
      accountStatus: map['accountStatus'] ?? AccountStatus.ACTIVE,
      role: map['role'] ?? UserRoles.VISITOR,
      storeIds:
          map['storeIds'] != null ? List<String>.from(map['storeIds']) : [],
      isAnonymous: map['isAnonymous'] ?? true,
      profileComplete: map['profileComplete'] ?? false,
      createdAt:
          map['createdAt'] != null ? DateTime.tryParse(map['createdAt']) : null,
      lastLogin:
          map['lastLogin'] != null ? DateTime.tryParse(map['lastLogin']) : null,
    );
  }

  AppUser copyWith({
    String? userId,
    String? authProvider,
    final String? authIdentifier,
    String? fullName,
    String? photoUrl,
    DateTime? createdAt,
    DateTime? lastLogin,
    bool? profileComplete,
    String? accountStatus,
    String? role,
    List<String>? storeIds,
    bool? isAnonymous,
  }) {
    return AppUser(
      userId: userId ?? this.userId,
      authProvider: authProvider ?? this.authProvider,
      authIdentifier: authIdentifier ?? this.authIdentifier,
      fullName: fullName ?? this.fullName,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      profileComplete: profileComplete ?? this.profileComplete,
      accountStatus: accountStatus ?? this.accountStatus,
      role: role ?? this.role,
      storeIds: storeIds ?? this.storeIds,
      isAnonymous: isAnonymous ?? this.isAnonymous,
    );
  }
}

//@Deprecated("Utiliser AppUser à la place")
/*
class User {
  final String userId;
  final String? email;
  final String accountStatus;
  final String? phoneNumber; // pour l'authentification par numéro de téléphone
  final String? emailAdress; // pour l'authentification par email
  final String? googleAccount; // pour l'authentification par Google
  final String? iCloudAccount; // pour l'authentification par iCloud
  final String? fullName;
  final String? photoUrl;
  final String? role;
  final bool profileComplete; // pour vérifier si le profil est complet
  final DateTime? createdAt;
  final DateTime? lastLogin;

  const User({
    required this.userId,
    this.accountStatus = AccountStatus.ACTIVE, // par défaut 'active'
    this.email,
    this.phoneNumber, // pour l'authentification par numéro de téléphone
    this.emailAdress, // pour l'authentification par email
    this.googleAccount, // pour l'authentification par Google
    this.iCloudAccount, // pour l'authentification par iCloud
    this.fullName,
    this.photoUrl,
    this.role = UserRoles.VISITOR, // par défaut 'visitor'
    this.profileComplete = false, // par défaut 'false'
    this.createdAt,
    this.lastLogin,
  });

  // Convertit un User vers un Map pour Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'accountStatus': accountStatus,
      'email': email,
      'phoneNumber': phoneNumber,
      'emailAdress': emailAdress,
      'googleAccount': googleAccount,
      'iCloudAccount': iCloudAccount,
      'fullName': fullName,
      'photoUrl': photoUrl,
      'role': role,
      'profileComplete': profileComplete,
      'createdAt': createdAt?.toIso8601String(),
      'lastLogin': lastLogin?.toIso8601String(),
    };
  }

  // Crée un User depuis une Map Firestore
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      userId: map['userId'],
      accountStatus: map['accountStatus'] ?? 'active',
      email: map['email'],
      phoneNumber:
          map['phoneNumber'], // pour l'authentification par numéro de téléphone
      emailAdress: map['emailAdress'], // pour l'authentification par email
      googleAccount: map['googleAccount'], // pour l'authentification par Google
      iCloudAccount: map['iCloudAccount'], // pour l'authentification par iCloud
      fullName: map['fullName'],
      photoUrl: map['photoUrl'],
      role: map['role'] ?? UserRoles.VISITOR,
      profileComplete: map['profileComplete'] ?? false,
      createdAt:
          map['createdAt'] != null ? DateTime.tryParse(map['createdAt']) : null,
      lastLogin:
          map['lastLogin'] != null ? DateTime.tryParse(map['lastLogin']) : null,
    );
  }

  // méthode utile pour copier l’utilisateur
  User copyWith({
    String? userId,
    String? accountStatus,
    String? email,
    String? phoneNumber, // pour l'authentification par numéro de téléphone
    String? emailAdress, // pour l'authentification par email
    String? googleAccount, // pour l'authentification par Google
    String? iCloudAccount, // pour l'authentification par iCloud
    String? fullName,
    String? photoUrl,
    String? role,
    bool? profileComplete,
    DateTime? createdAt,
    DateTime? lastLogin,
  }) {
    return User(
      userId: userId ?? this.userId,
      accountStatus: accountStatus ?? this.accountStatus,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      emailAdress: emailAdress ?? this.emailAdress,
      googleAccount: googleAccount ?? this.googleAccount,
      iCloudAccount: iCloudAccount ?? this.iCloudAccount,
      fullName: fullName ?? this.fullName,
      photoUrl: photoUrl ?? this.photoUrl,
      role: role ?? this.role,
      profileComplete: profileComplete ?? this.profileComplete,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }
}
*/
