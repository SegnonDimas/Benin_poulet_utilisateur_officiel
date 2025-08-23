# Guide de Test : Solution AuthBloc Listeners

## Tests à Effectuer

### 1. Test de Navigation entre Pages

**Objectif** : Vérifier que les listeners ne s'interfèrent pas entre les pages.

**Étapes** :
1. Ouvrir l'application
2. Aller sur `loginPage`
3. Taper un numéro de téléphone invalide (ex: "123")
4. Taper un mot de passe
5. Cliquer sur "Connexion"
6. **AVANT** : Attendre que l'erreur s'affiche
7. **PENDANT** l'affichage de l'erreur, naviguer vers `loginWithEmailPage`
8. **RÉSULTAT ATTENDU** : L'erreur de `loginPage` ne doit PAS s'afficher sur `loginWithEmailPage`

### 2. Test de Connexion Simultanée

**Objectif** : Vérifier que chaque page gère ses propres états de connexion.

**Étapes** :
1. Ouvrir `loginPage` dans un onglet/émulateur
2. Ouvrir `loginWithEmailPage` dans un autre onglet/émulateur
3. Sur `loginPage` : déclencher une connexion téléphone
4. Sur `loginWithEmailPage` : déclencher une connexion email
5. **RÉSULTAT ATTENDU** : Chaque page doit gérer sa propre connexion indépendamment

### 3. Test de Cycle de Vie de l'Application

**Objectif** : Vérifier que les listeners se désactivent quand l'app passe en arrière-plan.

**Étapes** :
1. Sur `loginPage`, déclencher une connexion
2. **PENDANT** le chargement, mettre l'app en arrière-plan (bouton home)
3. Remettre l'app au premier plan
4. **RÉSULTAT ATTENDU** : Le listener ne doit plus réagir aux changements d'état

### 4. Test de Gestion des Erreurs

**Objectif** : Vérifier que les erreurs s'affichent sur la bonne page.

**Étapes** :
1. Sur `loginPage` : utiliser des identifiants invalides
2. Attendre l'erreur
3. Naviguer vers `loginWithEmailPage`
4. **RÉSULTAT ATTENDU** : L'erreur de `loginPage` ne doit pas apparaître sur `loginWithEmailPage`

### 5. Test de Performance

**Objectif** : Vérifier que les listeners inactifs ne consomment pas de ressources.

**Étapes** :
1. Ouvrir `loginPage`
2. Naviguer vers `loginWithEmailPage`
3. Retourner sur `loginPage`
4. **RÉSULTAT ATTENDU** : Aucun comportement étrange, navigation fluide

## Code de Test pour Vérification

### Test Manuel avec Logs

Ajoutez temporairement ces logs pour vérifier le comportement :

```dart
// Dans loginPage.dart, ajoutez dans le listener :
listener: (context, authState) async {
  print('🔵 LOGIN_PAGE: État reçu: ${authState.runtimeType}');
  if (_isPageActive) {
    print('🔵 LOGIN_PAGE: Page active, traitement de l\'état');
    // ... logique existante
  } else {
    print('🔵 LOGIN_PAGE: Page inactive, état ignoré');
  }
},

// Dans loginWithEmailPage.dart, ajoutez dans le listener :
listener: (context, authState) async {
  print('🟡 EMAIL_PAGE: État reçu: ${authState.runtimeType}');
  if (_isPageActive) {
    print('🟡 EMAIL_PAGE: Page active, traitement de l\'état');
    // ... logique existante
  } else {
    print('🟡 EMAIL_PAGE: Page inactive, état ignoré');
  }
},
```

### Résultats Attendus

**Scénario 1** : Navigation de loginPage vers loginWithEmailPage
```
🔵 LOGIN_PAGE: État reçu: AuthLoading
🔵 LOGIN_PAGE: Page active, traitement de l'état
🔵 LOGIN_PAGE: État reçu: AuthFailure
🔵 LOGIN_PAGE: Page inactive, état ignoré
🟡 EMAIL_PAGE: État reçu: AuthFailure
🟡 EMAIL_PAGE: Page inactive, état ignoré
```

**Scénario 2** : Connexion sur loginWithEmailPage
```
🟡 EMAIL_PAGE: État reçu: AuthLoading
🟡 EMAIL_PAGE: Page active, traitement de l'état
🟡 EMAIL_PAGE: État reçu: AuthAuthenticated
🟡 EMAIL_PAGE: Page active, traitement de l'état
```

## Validation de la Solution

### ✅ Critères de Succès

1. **Isolation** : Les listeners ne s'interfèrent pas entre les pages
2. **Cycle de vie** : Les listeners se désactivent automatiquement
3. **Performance** : Aucun ralentissement ou comportement étrange
4. **Fonctionnalité** : Toutes les fonctionnalités existantes continuent de fonctionner

### ❌ Problèmes à Détecter

1. **Interférence** : Un listener s'exécute sur la mauvaise page
2. **Mémoire** : Les listeners restent actifs après navigation
3. **Performance** : Ralentissements ou freezes
4. **Fonctionnalité** : Perte de fonctionnalités existantes

## Dépannage

### Si les listeners s'interfèrent encore :

1. Vérifier que `_isPageActive` est bien mis à `false` dans `dispose()`
2. Vérifier que `WidgetsBindingObserver` est bien implémenté
3. Vérifier que `listenWhen` utilise bien `_isPageActive`

### Si les listeners ne s'exécutent plus du tout :

1. Vérifier que `_isPageActive` est bien initialisé à `true`
2. Vérifier que `WidgetsBinding.instance.addObserver(this)` est appelé
3. Vérifier que la logique dans `listenWhen` est correcte

### Si l'application plante :

1. Vérifier que `WidgetsBinding.instance.removeObserver(this)` est appelé dans `dispose()`
2. Vérifier qu'il n'y a pas de références circulaires
3. Vérifier que tous les imports sont corrects

## Conclusion

Si tous les tests passent, la solution est fonctionnelle et résout le problème d'interférence entre les listeners du `AuthBloc` tout en conservant l'architecture existante.
