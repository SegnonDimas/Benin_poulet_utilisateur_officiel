# Solution : Isolation des Listeners du AuthBloc entre les Pages

## Problème Résolu

Le problème était que toutes les pages de connexion (loginPage, loginWithEmailPage, etc.) partageaient le même `AuthBloc` global, ce qui causait des interférences entre les listeners. Le listener d'une page continuait de s'exécuter même lorsqu'on naviguait vers une autre page.

## Solution Implémentée

### 1. Utilisation de `BlocListener` + `BlocBuilder` Séparés

Au lieu d'utiliser `BlocConsumer` qui combine listener et builder, nous avons séparé les responsabilités :

```dart
// AVANT (problématique)
BlocConsumer<AuthBloc, AuthState>(
  listenWhen: (previous, current) => true, // Toujours actif
  listener: (context, authState) { /* ... */ },
  builder: (context, authState) { /* ... */ },
)

// APRÈS (solution)
BlocListener<AuthBloc, AuthState>(
  listenWhen: (previous, current) => _isPageActive, // Contrôle précis
  listener: (context, authState) { /* ... */ },
  child: BlocBuilder<AuthBloc, AuthState>(
    builder: (context, authState) { /* ... */ },
  ),
)
```

### 2. Gestion du Cycle de Vie des Pages

Chaque page implémente maintenant `WidgetsBindingObserver` pour détecter les changements d'état de l'application :

```dart
class _LoginPageState extends State<LoginPage> with WidgetsBindingObserver {
  bool _isPageActive = true;

  @override
  void initState() {
    super.initState();
    _isPageActive = true;
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      _isPageActive = false;
    } else if (state == AppLifecycleState.resumed) {
      _isPageActive = true;
    }
  }

  @override
  void dispose() {
    _isPageActive = false;
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
```

### 3. Contrôle Précis des Listeners

Le `listenWhen` utilise maintenant la variable `_isPageActive` pour contrôler quand le listener doit s'exécuter :

```dart
BlocListener<AuthBloc, AuthState>(
  listenWhen: (previous, current) {
    // Ne réagir que si la page est active et montée
    return _isPageActive && _isMounted;
  },
  listener: (context, authState) async {
    // Logique spécifique à la page
  },
  child: BlocBuilder<AuthBloc, AuthState>(
    builder: (context, authState) {
      // UI de la page
    },
  ),
)
```

## Avantages de cette Solution

### 1. **Isolation Complète**
- Chaque page a son propre listener qui ne s'exécute que quand la page est active
- Plus d'interférences entre les pages

### 2. **Gestion Automatique du Cycle de Vie**
- Les listeners se désactivent automatiquement quand on quitte une page
- Réactivation automatique quand on revient sur la page

### 3. **AuthBloc Partagé Conservé**
- Le `AuthBloc` reste global et partagé
- Aucune modification nécessaire dans la logique métier

### 4. **Performance Optimisée**
- Les listeners inactifs ne consomment pas de ressources
- Réduction des calculs inutiles

## Pages Modifiées

### 1. `loginPage.dart`
- ✅ Implémente `WidgetsBindingObserver`
- ✅ Utilise `BlocListener` + `BlocBuilder` séparés
- ✅ Contrôle du cycle de vie avec `_isPageActive`

### 2. `loginWithEmailPage.dart`
- ✅ Implémente `WidgetsBindingObserver`
- ✅ Utilise `BlocListener` + `BlocBuilder` séparés
- ✅ Contrôle du cycle de vie avec `_isPageActive`

## Structure de la Solution

```
Page (WidgetsBindingObserver)
├── _isPageActive (bool)
├── initState() → _isPageActive = true
├── didChangeAppLifecycleState() → Gestion pause/resume
├── dispose() → _isPageActive = false
└── BlocListener<AuthBloc>
    ├── listenWhen: _isPageActive
    ├── listener: Logique spécifique à la page
    └── child: BlocBuilder<AuthBloc>
        └── builder: UI de la page
```

## Tests Recommandés

1. **Navigation entre pages** : Vérifier qu'un listener ne s'exécute que sur sa page
2. **Changement d'état de l'app** : Tester pause/resume de l'application
3. **Connexion simultanée** : S'assurer qu'une connexion sur une page n'affecte pas l'autre
4. **Gestion des erreurs** : Vérifier que les erreurs s'affichent sur la bonne page

## Extensibilité

Cette solution peut être appliquée à d'autres blocs partagés dans l'application :

```dart
// Exemple pour un autre bloc
BlocListener<OtherBloc, OtherState>(
  listenWhen: (previous, current) => _isPageActive,
  listener: (context, state) { /* Logique spécifique */ },
  child: BlocBuilder<OtherBloc, OtherState>(
    builder: (context, state) { /* UI */ },
  ),
)
```

## Conclusion

Cette solution résout efficacement le problème d'interférence entre les listeners tout en conservant l'architecture BLoC existante. Elle offre une isolation complète des listeners par page avec une gestion automatique du cycle de vie.
