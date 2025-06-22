import 'package:benin_poulet/constants/accountStatus.dart';

import '../constants/userRoles.dart';

class User {
  final String userId;
  final String? email;
  final String accountStatus;
  final String? phoneNumber;
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
    this.phoneNumber,
    this.emailAdress, // pour l'authentification par email
    this.googleAccount, // pour l'authentification par Google
    this.iCloudAccount, // pour l'authentification par iCloud
    this.fullName,
    this.photoUrl,
    this.role = UserRoles.BUYER, // par défaut 'buyer'
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
      phoneNumber: map['phoneNumber'],
      emailAdress: map['emailAdress'], // pour l'authentification par email
      googleAccount: map['googleAccount'], // pour l'authentification par Google
      iCloudAccount: map['iCloudAccount'], // pour l'authentification par iCloud
      fullName: map['fullName'],
      photoUrl: map['photoUrl'],
      role: map['role'] ?? UserRoles.BUYER,
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
    String? phoneNumber,
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
