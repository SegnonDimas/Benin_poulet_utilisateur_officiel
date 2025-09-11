import 'package:benin_poulet/constants/accountStatus.dart';
import 'package:benin_poulet/constants/authProviders.dart';
import 'package:benin_poulet/constants/firebase_collections/usersCollection.dart';
import 'package:benin_poulet/constants/userRoles.dart';
import 'package:benin_poulet/constants/user_profilStatus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String userId;
  final String authProvider; // phone, email, google, icloud, anonymous
  final String? authIdentifier; // numéro, email, id externe, etc.
  final String? fullName;
  final String? photoUrl;
  final String accountStatus;
  final String role;
  final bool isAnonymous;
  final String profilStatus;
  final DateTime? dateOfBirth;
  final String? placeOfBirth;
  final String? currentAddress;
  final String? idDocumentType;
  final String? idDocumentCountry;
  final Map<String, String>? idDocumentPhoto;
  final DateTime? createdAt;
  final DateTime? lastLogin;
  final String? password;
  final List<String>? storeIds;
  final List<String>? favoriteStoreIds;
  final List<String>? favoriteProductIds;

  const AppUser({
    required this.userId,
    this.authProvider = AuthProviders.ANONYMOUS,
    this.authIdentifier,
    this.fullName,
    this.photoUrl,
    this.accountStatus = AccountStatus.ACTIVE,
    this.role = UserRoles.VISITOR,
    this.profilStatus = UserProfilStatus.unverified,
    this.isAnonymous = true,
    this.dateOfBirth,
    this.placeOfBirth,
    this.currentAddress,
    this.idDocumentType,
    this.idDocumentCountry,
    this.idDocumentPhoto,
    this.createdAt,
    this.lastLogin,
    this.password,
    this.storeIds,
    this.favoriteStoreIds,
    this.favoriteProductIds,
  });

  Map<String, dynamic> toMap() {
    return {
      UsersCollection.userId: userId,
      UsersCollection.authProvider: authProvider,
      UsersCollection.authIdentifier: authIdentifier,
      UsersCollection.fullName: fullName,
      UsersCollection.photoUrl: photoUrl,
      UsersCollection.accountStatus: accountStatus,
      UsersCollection.role: role,
      UsersCollection.isAnonymous: isAnonymous,
      UsersCollection.profilStatus: profilStatus,
      UsersCollection.dateOfBirth: dateOfBirth?.toIso8601String(),
      UsersCollection.placeOfBirth: placeOfBirth,
      UsersCollection.currentAddress: currentAddress,
      UsersCollection.idDocumentType: idDocumentType,
      UsersCollection.idDocumentCountry: idDocumentCountry,
      UsersCollection.idDocumentPhoto: idDocumentPhoto,
      UsersCollection.createdAt: createdAt?.toIso8601String(),
      UsersCollection.lastLogin: lastLogin?.toIso8601String(),
      UsersCollection.password: password,
      UsersCollection.storeIds: storeIds,
      UsersCollection.favoritesStoreIds: favoriteStoreIds,
      UsersCollection.favoritesProductIds: favoriteProductIds
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      userId: map[UsersCollection.userId],
      authProvider:
          map[UsersCollection.authProvider] ?? AuthProviders.ANONYMOUS,
      authIdentifier: map[UsersCollection.authIdentifier],
      fullName: map[UsersCollection.fullName],
      photoUrl: map[UsersCollection.photoUrl],
      accountStatus: map[UsersCollection.accountStatus] ?? AccountStatus.ACTIVE,
      role: map[UsersCollection.role] ?? UserRoles.VISITOR,
      isAnonymous: map[UsersCollection.isAnonymous] ?? true,
      profilStatus: map[UsersCollection.profilStatus] ?? UserProfilStatus.unverified,
      dateOfBirth: _parseDateTime(map[UsersCollection.dateOfBirth]),
      placeOfBirth: map[UsersCollection.placeOfBirth],
      currentAddress: map[UsersCollection.currentAddress],
      idDocumentType: map[UsersCollection.idDocumentType],
      idDocumentCountry: map[UsersCollection.idDocumentCountry],
      idDocumentPhoto: _parseDocumentPhoto(map[UsersCollection.idDocumentPhoto]),
      createdAt: _parseDateTime(map[UsersCollection.createdAt]),
      lastLogin: _parseDateTime(map[UsersCollection.lastLogin]),
      password: map[UsersCollection.password],
      storeIds: _parseStringList(map[UsersCollection.storeIds]),
      favoriteStoreIds: _parseStringList(map[UsersCollection.favoritesStoreIds]),
      favoriteProductIds: _parseStringList(map[UsersCollection.favoritesProductIds]),
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
    String? profilStatus,
    DateTime? dateOfBirth,
    String? placeOfBirth,
    String? currentAddress,
    String? idDocumentType,
    String? idDocumentCountry,
    Map<String, String>? idDocumentPhoto,
    String? accountStatus,
    String? role,
    bool? isAnonymous,
    String? password,
    List<String>? storeIds,
    List<String>? favoriteStoreIds,
    List<String>? favoriteProductIds,
  }) {
    return AppUser(
        userId: userId ?? this.userId,
        authProvider: authProvider ?? this.authProvider,
        authIdentifier: authIdentifier ?? this.authIdentifier,
        fullName: fullName ?? this.fullName,
        photoUrl: photoUrl ?? this.photoUrl,
        createdAt: createdAt ?? this.createdAt,
        lastLogin: lastLogin ?? this.lastLogin,
        profilStatus: profilStatus ?? this.profilStatus,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        placeOfBirth: placeOfBirth ?? this.placeOfBirth,
        currentAddress: currentAddress ?? this.currentAddress,
        idDocumentType: idDocumentType ?? this.idDocumentType,
        idDocumentCountry: idDocumentCountry ?? this.idDocumentCountry,
        idDocumentPhoto: idDocumentPhoto ?? this.idDocumentPhoto,
        accountStatus: accountStatus ?? this.accountStatus,
        role: role ?? this.role,
        isAnonymous: isAnonymous ?? this.isAnonymous,
        password: password ?? this.password,
        storeIds: storeIds ?? this.storeIds,
        favoriteStoreIds: favoriteStoreIds ?? this.favoriteStoreIds,
        favoriteProductIds: favoriteProductIds ?? this.favoriteProductIds);
  }

  /// Méthode utilitaire pour parser une liste de strings depuis Firestore
  static List<String>? _parseStringList(dynamic value) {
    if (value == null) return null;
    if (value is List) {
      return value.map((item) => item.toString()).toList();
    }
    if (value is String) {
      // Si c'est une string, essayer de la traiter comme une liste JSON
      try {
        // Pour les cas où la valeur est stockée comme une string vide ou null
        if (value.isEmpty) return null;
        // Si c'est une string simple, la traiter comme un élément unique
        return [value];
      } catch (e) {
        print('Erreur lors du parsing de la liste: $e');
        return null;
      }
    }
    return null;
  }

  /// Méthode utilitaire pour parser les photos de documents depuis Firestore
  static Map<String, String>? _parseDocumentPhoto(dynamic value) {
    if (value == null) return null;
    if (value is Map) {
      return Map<String, String>.from(value);
    }
    if (value is String) {
      // Si c'est une string (ancien format), la traiter comme recto
      if (value.isNotEmpty) {
        return {'recto': value};
      }
    }
    return null;
  }

  /// Méthode utilitaire pour parser les dates depuis Firestore
  /// Gère les Timestamp Firestore et les strings ISO8601
  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    
    // Si c'est un Timestamp Firestore
    if (value is Timestamp) {
      return value.toDate();
    }
    
    // Si c'est une string ISO8601
    if (value is String) {
      return DateTime.tryParse(value);
    }
    
    // Si c'est déjà un DateTime
    if (value is DateTime) {
      return value;
    }
    
    return null;
  }
}
