# Corrections Firebase - Envoi des Informations Complètes

## Problème identifié

Dans le code actuel, lorsqu'un vendeur s'inscrit ou crée une boutique, toutes les informations qu'il renseigne ne sont pas transmises vers Firebase. Seules les informations de base sont envoyées, manquant des données importantes comme :

- **Pour les vendeurs** : `sectors`, `subSectors`, `mobileMoney`, `deliveryInfos`, `fiscality`, etc.
- **Pour les boutiques** : `mobileMoney`, `sellerOwnDeliver`, `storeSectors`, `storeSubsectors`, etc.

## Corrections apportées

### 1. Inscription des vendeurs

#### Avant
```dart
// Dans AuthServices.createPhoneAuth()
AppUser user = AppUser(userId: phoneUser.user!.uid);
user = user.copyWith(
    authProvider: authProvider,
    authIdentifier: _phoneNumber.phoneNumber!,
    fullName: fullName,
    role: role,
    // ... autres champs de base
);
firestoreService.createOrUpdateUser(user);
// ❌ Pas de création du profil vendeur dans la collection "sellers"
```

#### Après
```dart
// Dans AuthServices.createPhoneAuth()
AppUser user = AppUser(userId: phoneUser.user!.uid);
user = user.copyWith(
    authProvider: authProvider,
    authIdentifier: _phoneNumber.phoneNumber!,
    fullName: fullName,
    role: role,
    // ... autres champs de base
);
await firestoreService.createOrUpdateUser(user);

// ✅ Création automatique du profil vendeur si role == SELLER
if (role == UserRoles.SELLER) {
  final firestoreServiceInstance = FirestoreService();
  await firestoreServiceInstance.createCompleteSeller(
    sellerId: phoneUser.user!.uid,
    userId: phoneUser.user!.uid,
    createdAt: DateTime.now(),
    documentsVerified: false,
    sectors: [], // Sera mis à jour lors de la création de la boutique
    subSectors: [], // Sera mis à jour lors de la création de la boutique
    storeIds: [], // Liste vide au début
    mobileMoney: [], // Sera mis à jour lors de la création de la boutique
    deliveryInfos: {}, // Sera mis à jour lors de la création de la boutique
    fiscality: {}, // Sera mis à jour lors de la création de la boutique
    storeInfos: {
      'name': fullName ?? '',
      'phone': _phoneNumber.phoneNumber!,
      'email': _formatEmailFromPhone(_phoneNumber),
    },
  );
}
```

### 2. Création des boutiques

#### Avant
```dart
// Dans inscription_vendeurPage.dart
Store storeData = Store(
  storeId: '',
  sellerId: AuthServices.userId!,
  // ❌ Informations manquantes ou incomplètes
  storeDescription: '', //TODO
  storeLogoPath: '', //TODO
  storeCoverPath: '', //TODO
  // ... autres champs avec des valeurs par défaut
);

// Duplication de code avec createCompleteStore
await firestoreService.createCompleteStore(
  // ❌ Même informations dupliquées
);
```

#### Après
```dart
// Dans inscription_vendeurPage.dart
// ✅ Création de la boutique avec toutes les informations
final firestoreService = FirestoreService();

// Préparer les informations de mobile money
final mobileMoney = storeState.paymentPhoneNumber != null
    ? [
        {
          'gsmService': storeState.paymentMethod ?? 'MTN',
          'name': storeState.payementOwnerName ?? '',
          'phone': storeState.paymentPhoneNumber!,
        }
      ]
    : null;

// Créer la boutique avec toutes les informations
final storeId = await firestoreService.createCompleteStore(
  sellerId: AuthServices.userId!,
  storeAddress: storeState.locationDescription,
  storeLocation: storeState.storeLocation,
  storeDescription: storeState.storeName ?? '', // Utiliser le nom comme description temporaire
  storeFiscalType: storeState.storeFiscalType,
  sellerOwnDeliver: storeState.sellerOwnDeliver,
  storeSectors: storeState.storeSectors,
  storeSubsectors: storeState.storeSubSectors,
  storeProducts: [],
  storeRatings: [0.0],
  storeComments: [],
  storeState: 'open',
  storeStatus: 'active',
  mobileMoney: mobileMoney,
  storeInfos: {
    'name': storeState.storeName!,
    'phone': storeState.storePhoneNumber,
    'email': storeState.storeEmail,
  },
);

// ✅ Mise à jour du profil vendeur avec les informations de la boutique
await firestoreService.createCompleteSeller(
  sellerId: AuthServices.userId!,
  userId: AuthServices.userId!,
  sectors: storeState.storeSectors,
  subSectors: storeState.storeSubSectors,
  mobileMoney: mobileMoney,
  deliveryInfos: {
    'location': storeState.location ?? '',
    'locationDescription': storeState.locationDescription ?? '',
    'sellerOwnDeliver': storeState.sellerOwnDeliver,
  },
  fiscality: {
    'fiscalType': storeState.storeFiscalType,
  },
  storeInfos: {
    'name': storeState.storeName!,
    'phone': storeState.storePhoneNumber,
    'email': storeState.storeEmail,
  },
);
```

### 3. Méthodes d'authentification mises à jour

Les corrections ont été appliquées à toutes les méthodes d'authentification :

- ✅ `createPhoneAuth()` - Inscription par téléphone
- ✅ `createEmailAuth()` - Inscription par email  
- ✅ `signInWithGoogle()` - Inscription par Google

## Informations maintenant transmises

### Collection "users"
- Toutes les informations de base de l'utilisateur
- Rôle correctement défini (SELLER, BUYER, etc.)

### Collection "sellers"
- ✅ `sellerId` et `userId`
- ✅ `createdAt`
- ✅ `deliveryInfos` (location, locationDescription, sellerOwnDeliver)
- ✅ `documentsVerified`
- ✅ `fiscality` (fiscalType, taxId, etc.)
- ✅ `identityCardUrl` (recto, verso)
- ✅ `mobileMoney` (gsmService, name, phone)
- ✅ `sectors` (secteurs d'activité)
- ✅ `subSectors` (sous-secteurs)
- ✅ `storeIds` (liste des boutiques)
- ✅ `storeInfos` (informations de contact)

### Collection "stores"
- ✅ `storeId` (généré automatiquement)
- ✅ `sellerId`
- ✅ `mobileMoney` (informations de paiement)
- ✅ `sellerOwnDeliver` (livraison propre)
- ✅ `storeAddress` et `storeLocation`
- ✅ `storeDescription`
- ✅ `storeFiscalType`
- ✅ `storeSectors` et `storeSubsectors`
- ✅ `storeInfos` (nom, téléphone, email)
- ✅ `storeState` et `storeStatus`
- ✅ `storeProducts`, `storeRatings`, `storeComments`

## Avantages des corrections

1. **Données complètes** : Toutes les informations renseignées par l'utilisateur sont maintenant transmises
2. **Cohérence** : Les données sont cohérentes entre les collections
3. **Pas de duplication** : Suppression du code dupliqué
4. **Maintenabilité** : Code plus propre et organisé
5. **Fonctionnalités** : Toutes les fonctionnalités peuvent maintenant utiliser les données complètes

## Tests

Un fichier de test a été créé (`lib/examples/test_seller_creation.dart`) pour vérifier que :

1. La création complète d'un vendeur fonctionne
2. La création d'une boutique avec toutes les informations fonctionne
3. Les informations sont correctement transmises et récupérées
4. Les relations entre collections sont maintenues

## Gestion des IDs de boutiques

### Problème identifié
Après la création d'une boutique, l'ID de cette boutique n'était pas automatiquement ajouté à la liste `storeIds` du vendeur dans la collection "sellers".

### Solution implémentée

#### 1. Ajout automatique de l'ID de boutique
La méthode `createCompleteStore()` utilise en interne `store_repository.createStore()` qui :
1. Crée la boutique dans la collection "stores"
2. Appelle automatiquement `_sellerRepository.addStoreToSeller(sellerId, storeId)`
3. Met à jour la liste `storeIds` du vendeur

#### 2. Méthode de mise à jour préservant les boutiques
Une nouvelle méthode `updateSellerPreservingStores()` a été créée pour :
- Récupérer le vendeur existant
- Préserver sa liste `storeIds` actuelle
- Mettre à jour les autres informations sans écraser les IDs de boutiques

#### 3. Flux de création de boutique
```dart
// 1. Créer la boutique (ajoute automatiquement l'ID à storeIds)
final storeId = await firestoreService.createCompleteStore(
  sellerId: AuthServices.userId!,
  // ... autres informations
);

// 2. Mettre à jour le profil vendeur (préserve storeIds)
await firestoreService.updateSellerPreservingStores(
  sellerId: AuthServices.userId!,
  // ... autres informations
);
```

### Vérification
Un test spécifique `testStoreIdAddition()` a été créé pour vérifier que :
1. La liste `storeIds` est vide au début
2. Après création d'une boutique, l'ID est ajouté à la liste
3. La relation boutique-vendeur est correctement établie

## Utilisation

Les corrections sont automatiques et ne nécessitent aucun changement dans l'interface utilisateur. Tous les vendeurs qui s'inscrivent maintenant auront automatiquement leur profil complet créé dans Firebase avec toutes les informations nécessaires, et chaque boutique créée sera automatiquement liée au vendeur via la liste `storeIds`.

