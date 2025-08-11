import 'package:benin_poulet/constants/accountStatus.dart';
import 'package:benin_poulet/constants/authProviders.dart';
import 'package:benin_poulet/constants/firebase_collections/usersCollection.dart';
import 'package:benin_poulet/constants/userRoles.dart';

class AppUser {
  final String userId;
  final String authProvider; // phone, email, google, icloud, anonymous
  final String? authIdentifier; // numéro, email, id externe, etc.
  final String? fullName;
  final String? photoUrl;
  final String accountStatus;
  final String role;
  final bool isAnonymous;
  final bool profileComplete;
  final DateTime? createdAt;
  final DateTime? lastLogin;
  final String? password;
  final List<String>? storeIds;
  final List<String>? favoriteStoreIds;

  const AppUser({
    required this.userId,
    this.authProvider = AuthProviders.ANONYMOUS,
    this.authIdentifier,
    this.fullName,
    this.photoUrl,
    this.accountStatus = AccountStatus.ACTIVE,
    this.role = UserRoles.VISITOR,
    this.profileComplete = false,
    this.isAnonymous = true,
    this.createdAt,
    this.lastLogin,
    this.password,
    this.storeIds,
    this.favoriteStoreIds,
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
      UsersCollection.profileComplete: profileComplete,
      UsersCollection.createdAt: createdAt?.toIso8601String(),
      UsersCollection.lastLogin: lastLogin?.toIso8601String(),
      UsersCollection.password: password,
      UsersCollection.storeIds: storeIds,
      UsersCollection.favoritesStoreIds: favoriteStoreIds
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
      profileComplete: map[UsersCollection.profileComplete] ?? false,
      createdAt: map[UsersCollection.createdAt] != null
          ? DateTime.tryParse(map[UsersCollection.createdAt])
          : null,
      lastLogin: map[UsersCollection.lastLogin] != null
          ? DateTime.tryParse(map[UsersCollection.lastLogin])
          : null,
      password: map[UsersCollection.password],
      storeIds: map[UsersCollection.storeIds],
      favoriteStoreIds: map[UsersCollection.favoritesStoreIds] ?? '',
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
    bool? isAnonymous,
    String? password,
    List<String>? storeIds,
    List<String>? favoriteStoreIds,
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
        isAnonymous: isAnonymous ?? this.isAnonymous,
        password: password ?? this.password,
        storeIds: storeIds ?? this.storeIds,
        favoriteStoreIds: favoriteStoreIds ?? this.favoriteStoreIds);
  }
}
