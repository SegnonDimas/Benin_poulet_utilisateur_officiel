# Flux de Création de Boutique avec Notifications

## Vue d'ensemble

Le système de création de boutique a été amélioré pour offrir une meilleure expérience utilisateur avec des notifications appropriées à chaque étape du processus.

## Fonctionnalités

### 1. Notifications en Temps Réel

- **Chargement** : Indicateur visuel pendant la création de la boutique
- **Succès** : Confirmation de création réussie
- **Erreur** : Messages d'erreur détaillés avec option de réessayer

### 2. États du BLoC

Le `StoreCreationBloc` gère maintenant les états suivants :

- `StoreCreationInitial` : État initial
- `StoreCreationLoading` : Création en cours
- `StoreCreationSuccess` : Création réussie (avec ID de la boutique)
- `StoreCreationError` : Erreur lors de la création (avec préservation des données)

### 3. Gestion des Erreurs

Le système détecte automatiquement différents types d'erreurs :

- **Erreurs de connexion** : "Erreur de connexion. Vérifiez votre connexion internet et réessayez."
- **Erreurs de permission** : "Erreur de permission. Vous n'avez pas les droits nécessaires."
- **Timeouts** : "Délai d'attente dépassé. Veuillez réessayer."
- **Erreurs générales** : Messages d'erreur personnalisés

**Important** : Toutes les données saisies par l'utilisateur sont préservées lors d'une erreur. L'utilisateur peut simplement cliquer sur "Réessayer" sans avoir à ressaisir ses informations.

### 4. Préservation de l'État

L'une des améliorations majeures est la préservation de l'état lors des erreurs :

- **Avant** : En cas d'erreur, tous les champs étaient effacés
- **Maintenant** : Toutes les données saisies sont conservées dans l'état d'erreur
- **Bénéfice** : L'utilisateur n'a plus besoin de ressaisir ses informations

## Utilisation

### Dans la Page de Création

```dart
// Le BlocListener gère automatiquement les notifications
BlocListener<StoreCreationBloc, StoreCreationState>(
  listener: (context, state) {
    if (state is StoreCreationLoading) {
      // Notification de chargement automatique
    } else if (state is StoreCreationSuccess) {
      // Notification de succès et redirection
    } else if (state is StoreCreationError) {
      // Notification d'erreur avec option de réessayer
      // Les données sont automatiquement préservées
    }
  },
  child: // Votre widget
)
```

### Déclenchement de la Création

```dart
// Au lieu d'appeler directement Firebase
context.read<StoreCreationBloc>().add(StoreCreationSubmit());
```

### Widgets de Notification

```dart
// Notification de chargement
NotificationWidgets.showLoadingNotification(context, 'Message...');

// Notification de succès
NotificationWidgets.showSuccessNotification(context, 'Message...');

// Notification d'erreur avec option de réessayer
NotificationWidgets.showErrorNotification(
  context, 
  'Message d\'erreur',
  () => // Fonction de réessai
);
```

## Flux Utilisateur

1. **Saisie des informations** : L'utilisateur remplit les formulaires
2. **Soumission** : Clic sur "Soumettre"
3. **Chargement** : Notification "Création de votre boutique en cours..."
4. **Résultat** :
   - **Succès** : "Boutique créée avec succès !" → Redirection vers VENDEURMAINPAGE
   - **Erreur** : Message d'erreur avec bouton "Réessayer" (données préservées)

## Avantages

- **Feedback immédiat** : L'utilisateur sait toujours ce qui se passe
- **Gestion d'erreurs robuste** : Messages clairs et options de récupération
- **Préservation de l'état** : Les données saisies sont conservées même en cas d'erreur
- **UX améliorée** : Boutons désactivés pendant le chargement
- **Maintenabilité** : Code centralisé et réutilisable

## Tests

Le système inclut des tests unitaires pour vérifier :

- Les transitions d'état
- La gestion des événements
- Les mises à jour d'état
- La gestion des erreurs
- **La préservation de l'état lors des erreurs**

## Configuration

Aucune configuration supplémentaire n'est nécessaire. Le système utilise les providers BLoC déjà configurés dans `blocProviders.dart`.
