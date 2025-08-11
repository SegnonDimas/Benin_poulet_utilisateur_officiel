# Architecture des Collections Firebase

## Vue d'ensemble

Ce projet utilise une architecture de collections Firebase bien structurée pour gérer les utilisateurs, vendeurs et boutiques de manière efficace et scalable.

## Collections principales

### 1. Collection `users`
**Objectif** : Stocker les informations de base de tous les utilisateurs (vendeurs, clients, administrateurs, visiteurs)

**Champs principaux** :
- `userId` : Identifiant unique de l'utilisateur
- `authProvider` : Méthode d'authentification (phone, email, google, etc.)
- `authIdentifier` : Identifiant d'authentification (numéro, email, etc.)
- `fullName` : Nom complet de l'utilisateur
- `photoUrl` : URL de la photo de profil
- `accountStatus` : Statut du compte (active, inactive, suspended)
- `role` : Rôle de l'utilisateur (visitor, seller, admin, buyer)
- `isAnonymous` : Si l'utilisateur est anonyme
- `profileComplete` : Si le profil est complet
- `createdAt` : Date de création
- `lastLogin` : Dernière connexion
- `password` : Mot de passe (optionnel)

### 2. Collection `sellers`
**Objectif** : Stocker les informations spécifiques aux vendeurs

**Champs principaux** :
- `sellerId` : Identifiant unique du vendeur (même que userId)
- `userId` : Référence vers l'utilisateur
- `createdAt` : Date de création du profil vendeur
- `deliveryInfos` : Informations de livraison
- `documentsVerified` : Statut de vérification des documents
- `fiscality` : Informations fiscales
- `identyCardUrl` : URLs de la carte d'identité
- `mobileMoney` : Informations de mobile money
- `sectors` : Secteurs d'activité
- `storeIds` : Liste des IDs des boutiques
- `storeInfos` : Informations générales de la boutique
- `subSectors` : Sous-secteurs d'activité

### 3. Collection `stores`
**Objectif** : Stocker les informations des boutiques

**Champs principaux** :
- `storeId` : Identifiant unique de la boutique
- `sellerId` : Référence vers le vendeur
- `mobileMoney` : Informations de mobile money de la boutique
- `sellerOwnDeliver` : Si le vendeur livre lui-même
- `storeAddress` : Adresse de la boutique
- `storeComments` : Commentaires sur la boutique
- `storeCoverPath` : Chemin de l'image de couverture
- `storeDescription` : Description de la boutique
- `storeFiscalType` : Type fiscal de la boutique
- `storeInfos` : Informations de contact de la boutique
- `storeLocation` : Localisation de la boutique
- `storeLogoPath` : Chemin du logo
- `storeProducts` : Liste des produits
- `storeRatings` : Évaluations de la boutique
- `storeSectors` : Secteurs de la boutique
- `storeState` : État de la boutique (open, closed)
- `storeStatus` : Statut de la boutique (active, inactive)
- `storeSubsectors` : Sous-secteurs de la boutique

## Logique métier

### Inscription d'un vendeur
1. Créer l'utilisateur dans la collection `users`
2. Créer le profil vendeur dans la collection `sellers`

### Création d'une boutique
1. Créer la boutique dans la collection `stores`
2. Ajouter l'ID de la boutique à la liste `storeIds` du vendeur

### Relations entre collections
- Un utilisateur peut avoir un rôle de vendeur
- Un vendeur peut avoir plusieurs boutiques
- Chaque boutique appartient à un seul vendeur

## Avantages de cette architecture

1. **Séparation des responsabilités** : Chaque collection a un rôle spécifique
2. **Scalabilité** : Facile d'ajouter de nouvelles fonctionnalités
3. **Performance** : Requêtes optimisées par collection
4. **Maintenabilité** : Code organisé et facile à comprendre
5. **Flexibilité** : Possibilité d'ajouter de nouveaux champs facilement
6. **Données complètes** : Toutes les données sont envoyées vers Firebase, même si elles sont null

## Utilisation dans le code

### Exemple de création d'un utilisateur complet
```dart
final firestoreService = FirestoreService();

await firestoreService.createCompleteUser(
  userId: 'user123',
  authProvider: 'email',
  authIdentifier: 'user@example.com',
  fullName: 'John Doe',
  photoUrl: 'https://example.com/photo.jpg',
  accountStatus: 'active',
  role: UserRoles.VISITOR,
  isAnonymous: false,
  profileComplete: true,
  createdAt: DateTime.now(),
  lastLogin: DateTime.now(),
);
```

### Exemple de création d'un vendeur complet
```dart
await firestoreService.createCompleteSeller(
  sellerId: 'seller123',
  userId: 'seller123',
  deliveryInfos: {
    'location': 'Cotonou, Bénin',
    'locationDescription': 'Zone commerciale',
    'sellerOwnDeliver': true,
  },
  documentsVerified: false,
  fiscality: {
    'taxId': 'TAX123456',
    'fiscalType': 'auto-entrepreneur',
  },
  identityCardUrl: {
    'recto': 'https://example.com/recto.jpg',
    'verso': 'https://example.com/verso.jpg',
  },
  sectors: ['alimentation', 'boissons'],
  subSectors: ['fruits', 'légumes'],
);
```

### Exemple de création d'une boutique complète
```dart
final storeId = await firestoreService.createCompleteStore(
  sellerId: 'seller123',
  storeAddress: '123 Rue du Marché, Cotonou',
  storeDescription: 'Boutique de fruits et légumes',
  storeFiscalType: 'auto-entrepreneur',
  sellerOwnDeliver: true,
  storeSectors: ['alimentation'],
  storeSubsectors: ['fruits', 'légumes'],
  storeState: 'open',
  storeStatus: 'active',
  storeInfos: {
    'name': 'Fruits & Légumes Marie',
    'phone': '+22912345678',
    'email': 'marie@fruitslegumes.bj',
  },
  mobileMoney: [
    {
      'gsmService': 'MTN',
      'name': 'Marie Dupont',
      'phone': '+22912345678',
    }
  ],
);
```

### Exemple de récupération des données
```dart
final userData = await firestoreService.getUserWithSellerInfo('user123');
final sellerData = await firestoreService.getSellerWithStores('user123');
```

### Exemple de workflow complet
```dart
// 1. Créer l'utilisateur
await firestoreService.createCompleteUser(
  userId: 'seller123',
  authProvider: 'phone',
  authIdentifier: '+22912345678',
  fullName: 'Marie Dupont',
  role: UserRoles.SELLER,
);

// 2. Créer le vendeur
await firestoreService.createCompleteSeller(
  sellerId: 'seller123',
  userId: 'seller123',
  deliveryInfos: {...},
  sectors: ['alimentation'],
);

// 3. Créer la boutique
final storeId = await firestoreService.createCompleteStore(
  sellerId: 'seller123',
  storeAddress: '123 Rue du Marché',
  storeSectors: ['alimentation'],
);
```

## Gestion des données null

**Important** : Toutes les données sont envoyées vers Firebase, même si elles sont `null`. Cela garantit que :

- Tous les champs définis dans les collections sont toujours présents
- La structure des données est cohérente
- Les requêtes peuvent toujours compter sur l'existence des champs
- Les mises à jour partielles sont plus prévisibles

### Exemple de données envoyées
```dart
// Même si certaines données sont null, elles sont toutes envoyées
final seller = Seller(
  sellerId: 'seller123',
  userId: 'seller123',
  deliveryInfos: null,        // Envoyé comme null
  documentsVerified: null,    // Envoyé comme null
  sectors: ['alimentation'],  // Envoyé avec des données
  storeIds: [],              // Envoyé comme liste vide
);
```

## Migration des données existantes

Si vous avez des données existantes, vous devrez :
1. Migrer les utilisateurs vers la nouvelle structure
2. Créer les profils vendeurs pour les utilisateurs existants
3. Réorganiser les données des boutiques selon la nouvelle structure

## Sécurité

Assurez-vous de configurer les règles de sécurité Firestore appropriées pour chaque collection selon les rôles des utilisateurs.

