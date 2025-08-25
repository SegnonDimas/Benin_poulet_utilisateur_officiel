import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:benin_poulet/core/firebase/firestore/firestore_service.dart';
import 'package:benin_poulet/core/firebase/auth/auth_services.dart';
import 'package:benin_poulet/models/store.dart';
import 'package:benin_poulet/services/cache_manager.dart';
import 'package:benin_poulet/services/sync_service.dart';

// Événements
abstract class StoreEvent {}

class LoadVendorStore extends StoreEvent {
  final String? sellerId;
  LoadVendorStore({this.sellerId});
}

class LoadStoreById extends StoreEvent {
  final String storeId;
  LoadStoreById(this.storeId);
}

class UpdateStoreInfo extends StoreEvent {
  final String storeId;
  final Map<String, dynamic> updates;
  UpdateStoreInfo(this.storeId, this.updates);
}

class RefreshStoreData extends StoreEvent {
  final String? sellerId;
  RefreshStoreData({this.sellerId});
}

// États
abstract class StoreState {}

class StoreInitial extends StoreState {}

class StoreLoading extends StoreState {}

class StoreLoaded extends StoreState {
  final Store store;
  final bool isFromCache;
  StoreLoaded(this.store, {this.isFromCache = false});
}

class StoreError extends StoreState {
  final String message;
  final bool hasCachedData;
  StoreError(this.message, {this.hasCachedData = false});
}

class StoreUpdated extends StoreState {
  final Store store;
  StoreUpdated(this.store);
}

class StoreOffline extends StoreState {
  final Store? cachedStore;
  final String message;
  StoreOffline({this.cachedStore, required this.message});
}

// BLoC
class StoreBloc extends Bloc<StoreEvent, StoreState> {
  final FirestoreService _firestoreService = FirestoreService();

  StoreBloc() : super(StoreInitial()) {
    on<LoadVendorStore>(_onLoadVendorStore);
    on<LoadStoreById>(_onLoadStoreById);
    on<UpdateStoreInfo>(_onUpdateStoreInfo);
    on<RefreshStoreData>(_onRefreshStoreData);
  }

  Future<void> _onLoadVendorStore(
    LoadVendorStore event,
    Emitter<StoreState> emit,
  ) async {
    emit(StoreLoading());
    
    try {
      final sellerId = event.sellerId ?? AuthServices.auth.currentUser?.uid;
      if (sellerId == null) {
        emit(StoreError('Aucun vendeur connecté'));
        return;
      }

      // Vérifier d'abord le cache
      final cachedStores = CacheManager.getCachedStores();
      final cachedStore = cachedStores.where((store) => store.sellerId == sellerId).firstOrNull;
      
      if (cachedStore != null) {
        emit(StoreLoaded(cachedStore, isFromCache: true));
      }

      // Vérifier la connectivité
      final isOnline = await CacheManager.isOnline();
      if (!isOnline) {
        if (cachedStore != null) {
          emit(StoreOffline(
            cachedStore: cachedStore,
            message: 'Mode hors ligne - Données en cache affichées',
          ));
        } else {
          emit(StoreError(
            'Aucune donnée disponible hors ligne. Veuillez vérifier votre connexion.',
            hasCachedData: false,
          ));
        }
        return;
      }

      // Récupérer les données depuis Firestore
      final sellerWithStores = await _firestoreService.getSellerWithStores(sellerId);
      
      if (sellerWithStores == null || sellerWithStores['stores'] == null || (sellerWithStores['stores'] as List<Store>).isEmpty) {
        if (cachedStore != null) {
          emit(StoreOffline(
            cachedStore: cachedStore,
            message: 'Aucune boutique trouvée en ligne. Données en cache affichées.',
          ));
        } else {
          emit(StoreError('Aucune boutique trouvée pour ce vendeur'));
        }
        return;
      }

      // Prendre la première boutique (ou la plus récente)
      final stores = sellerWithStores['stores'] as List<Store>;
      final store = stores.first;
      
      // Mettre en cache la boutique
      await CacheManager.cacheStore(store);
      
      emit(StoreLoaded(store, isFromCache: false));
    } catch (e) {
      // En cas d'erreur, essayer d'utiliser le cache
      final sellerId = event.sellerId ?? AuthServices.auth.currentUser?.uid;
      if (sellerId != null) {
        final cachedStores = CacheManager.getCachedStores();
        final cachedStore = cachedStores.where((store) => store.sellerId == sellerId).firstOrNull;
        
        if (cachedStore != null) {
          emit(StoreOffline(
            cachedStore: cachedStore,
            message: 'Erreur de connexion. Données en cache affichées.',
          ));
          return;
        }
      }
      
      emit(StoreError('Erreur lors du chargement de la boutique: $e'));
    }
  }

  Future<void> _onLoadStoreById(
    LoadStoreById event,
    Emitter<StoreState> emit,
  ) async {
    emit(StoreLoading());
    
    try {
      // Vérifier d'abord le cache
      final cachedStore = CacheManager.getCachedStore(event.storeId);
      if (cachedStore != null) {
        emit(StoreLoaded(cachedStore, isFromCache: true));
      }

      // Vérifier la connectivité
      final isOnline = await CacheManager.isOnline();
      if (!isOnline) {
        if (cachedStore != null) {
          emit(StoreOffline(
            cachedStore: cachedStore,
            message: 'Mode hors ligne - Données en cache affichées',
          ));
        } else {
          emit(StoreError(
            'Aucune donnée disponible hors ligne. Veuillez vérifier votre connexion.',
            hasCachedData: false,
          ));
        }
        return;
      }

      final store = await _firestoreService.getStore(event.storeId);
      if (store == null) {
        if (cachedStore != null) {
          emit(StoreOffline(
            cachedStore: cachedStore,
            message: 'Boutique non trouvée en ligne. Données en cache affichées.',
          ));
        } else {
          emit(StoreError('Boutique non trouvée'));
        }
        return;
      }
      
      // Mettre en cache la boutique
      await CacheManager.cacheStore(store);
      
      emit(StoreLoaded(store, isFromCache: false));
    } catch (e) {
      // En cas d'erreur, essayer d'utiliser le cache
      final cachedStore = CacheManager.getCachedStore(event.storeId);
      if (cachedStore != null) {
        emit(StoreOffline(
          cachedStore: cachedStore,
          message: 'Erreur de connexion. Données en cache affichées.',
        ));
        return;
      }
      
      emit(StoreError('Erreur lors du chargement de la boutique: $e'));
    }
  }

  Future<void> _onUpdateStoreInfo(
    UpdateStoreInfo event,
    Emitter<StoreState> emit,
  ) async {
    try {
      final isOnline = await CacheManager.isOnline();
      
      if (isOnline) {
        await _firestoreService.updateStore(event.storeId, event.updates);
        
        // Recharger la boutique mise à jour
        final store = await _firestoreService.getStore(event.storeId);
        if (store != null) {
          await CacheManager.cacheStore(store);
          emit(StoreUpdated(store));
        }
      } else {
        // Mode hors ligne - ajouter à la file d'attente
        await CacheManager.addOfflineAction({
          'type': 'update_store',
          'storeId': event.storeId,
          'updates': event.updates,
        });
        
        // Mettre à jour le cache local
        final cachedStore = CacheManager.getCachedStore(event.storeId);
        if (cachedStore != null) {
          // Créer une version mise à jour de la boutique
          final updatedStore = cachedStore.copyWith(
            // Mettre à jour les champs selon les updates
            // Cette logique dépend de la structure des updates
          );
          await CacheManager.cacheStore(updatedStore);
          emit(StoreUpdated(updatedStore));
        }
      }
    } catch (e) {
      emit(StoreError('Erreur lors de la mise à jour: $e'));
    }
  }

  Future<void> _onRefreshStoreData(
    RefreshStoreData event,
    Emitter<StoreState> emit,
  ) async {
    // Forcer le rechargement depuis Firestore
    add(LoadVendorStore(sellerId: event.sellerId));
  }
}
