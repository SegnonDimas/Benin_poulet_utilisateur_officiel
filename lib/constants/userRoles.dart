class UserRoles {
  static const String BUYER = 'buyer';
  static const String SELLER = 'seller';
  static const String ADMIN = 'admin';
  static const String VISITOR = 'visitor';

  // Liste des rôles disponibles
  static List<String> get allRoles => [BUYER, SELLER, ADMIN, VISITOR];

  // Vérifie si un rôle est valide
  static bool isValidRole(String role) {
    return allRoles.contains(role);
  }
}
