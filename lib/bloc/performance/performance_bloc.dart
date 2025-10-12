import 'package:benin_poulet/bloc/performance/performance_event.dart';
import 'package:benin_poulet/bloc/performance/performance_state.dart';
import 'package:benin_poulet/models/indice_performance.dart';
import 'package:benin_poulet/models/performance_client.dart';
import 'package:benin_poulet/models/performance_commercial.dart';
import 'package:benin_poulet/models/performance_marketing.dart';
import 'package:benin_poulet/models/performance_production.dart';
import 'package:benin_poulet/models/performance_produit.dart';
import 'package:benin_poulet/services/performance_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// BLoC pour gérer les performances du vendeur
class PerformanceBloc extends Bloc<PerformanceEvent, PerformanceState> {
  final PerformanceService _performanceService;

  PerformanceBloc({PerformanceService? performanceService})
      : _performanceService = performanceService ?? PerformanceService(),
        super(PerformanceInitial()) {
    on<LoadPerformanceCommercialEvent>(_onLoadPerformanceCommercial);
    on<LoadPerformanceClientEvent>(_onLoadPerformanceClient);
    on<LoadPerformanceProduitEvent>(_onLoadPerformanceProduit);
    on<LoadPerformanceProductionEvent>(_onLoadPerformanceProduction);
    on<LoadIndicePerformanceEvent>(_onLoadIndicePerformance);
    on<LoadPerformanceMarketingEvent>(_onLoadPerformanceMarketing);
    on<MarquerRappelEffectueEvent>(_onMarquerRappelEffectue);
    on<RefreshAllPerformancesEvent>(_onRefreshAllPerformances);
  }

  /// Charger les performances commerciales
  Future<void> _onLoadPerformanceCommercial(
    LoadPerformanceCommercialEvent event,
    Emitter<PerformanceState> emit,
  ) async {
    try {
      emit(const PerformanceLoading('commercial'));

      final performance = await _performanceService.getPerformanceCommercial(
        event.sellerId,
        periode: event.periode,
      );

      if (performance != null) {
        emit(PerformanceCommercialLoaded(performance));
      } else {
        emit(const PerformanceError(
          'Aucune donnée de performance commerciale disponible',
          type: 'commercial',
        ));
      }
    } catch (e) {
      emit(PerformanceError(
        'Erreur lors du chargement des performances commerciales: $e',
        type: 'commercial',
      ));
    }
  }

  /// Charger les performances client
  Future<void> _onLoadPerformanceClient(
    LoadPerformanceClientEvent event,
    Emitter<PerformanceState> emit,
  ) async {
    try {
      emit(const PerformanceLoading('client'));

      final performance = await _performanceService.getPerformanceClient(
        event.sellerId,
        periode: event.periode,
      );

      if (performance != null) {
        emit(PerformanceClientLoaded(performance));
      } else {
        emit(const PerformanceError(
          'Aucune donnée de performance client disponible',
          type: 'client',
        ));
      }
    } catch (e) {
      emit(PerformanceError(
        'Erreur lors du chargement des performances client: $e',
        type: 'client',
      ));
    }
  }

  /// Charger les performances produit
  Future<void> _onLoadPerformanceProduit(
    LoadPerformanceProduitEvent event,
    Emitter<PerformanceState> emit,
  ) async {
    try {
      emit(const PerformanceLoading('produit'));

      final performance = await _performanceService.getPerformanceProduit(
        event.sellerId,
        periode: event.periode,
      );

      if (performance != null) {
        emit(PerformanceProduitLoaded(performance));
      } else {
        emit(const PerformanceError(
          'Aucune donnée de performance produit disponible',
          type: 'produit',
        ));
      }
    } catch (e) {
      emit(PerformanceError(
        'Erreur lors du chargement des performances produit: $e',
        type: 'produit',
      ));
    }
  }

  /// Charger les performances de production
  Future<void> _onLoadPerformanceProduction(
    LoadPerformanceProductionEvent event,
    Emitter<PerformanceState> emit,
  ) async {
    try {
      emit(const PerformanceLoading('production'));

      final performance = await _performanceService.getPerformanceProduction(
        event.sellerId,
      );

      if (performance != null) {
        emit(PerformanceProductionLoaded(performance));
      } else {
        emit(const PerformanceError(
          'Aucune donnée de performance production disponible',
          type: 'production',
        ));
      }
    } catch (e) {
      emit(PerformanceError(
        'Erreur lors du chargement des performances production: $e',
        type: 'production',
      ));
    }
  }

  /// Charger l'indice de performance
  Future<void> _onLoadIndicePerformance(
    LoadIndicePerformanceEvent event,
    Emitter<PerformanceState> emit,
  ) async {
    try {
      emit(const PerformanceLoading('indice'));

      final indice = await _performanceService.getIndicePerformance(
        event.sellerId,
      );

      if (indice != null) {
        emit(IndicePerformanceLoaded(indice));
      } else {
        emit(const PerformanceError(
          'Aucune donnée d\'indice de performance disponible',
          type: 'indice',
        ));
      }
    } catch (e) {
      emit(PerformanceError(
        'Erreur lors du chargement de l\'indice de performance: $e',
        type: 'indice',
      ));
    }
  }

  /// Charger les performances marketing
  Future<void> _onLoadPerformanceMarketing(
    LoadPerformanceMarketingEvent event,
    Emitter<PerformanceState> emit,
  ) async {
    try {
      emit(const PerformanceLoading('marketing'));

      final performance = await _performanceService.getPerformanceMarketing(
        event.sellerId,
        periode: event.periode,
      );

      if (performance != null) {
        emit(PerformanceMarketingLoaded(performance));
      } else {
        emit(const PerformanceError(
          'Aucune donnée de performance marketing disponible',
          type: 'marketing',
        ));
      }
    } catch (e) {
      emit(PerformanceError(
        'Erreur lors du chargement des performances marketing: $e',
        type: 'marketing',
      ));
    }
  }

  /// Marquer un rappel comme effectué
  Future<void> _onMarquerRappelEffectue(
    MarquerRappelEffectueEvent event,
    Emitter<PerformanceState> emit,
  ) async {
    try {
      await _performanceService.marquerRappelEffectue(
        event.rappelId,
        event.sellerId,
      );

      // Recharger les performances de production
      add(LoadPerformanceProductionEvent(sellerId: event.sellerId));
    } catch (e) {
      emit(PerformanceError(
        'Erreur lors de la mise à jour du rappel: $e',
        type: 'production',
      ));
    }
  }

  /// Actualiser toutes les performances
  Future<void> _onRefreshAllPerformances(
    RefreshAllPerformancesEvent event,
    Emitter<PerformanceState> emit,
  ) async {
    try {
      emit(const PerformanceLoading('all'));

      final results = await Future.wait([
        _performanceService.getPerformanceCommercial(event.sellerId),
        _performanceService.getPerformanceClient(event.sellerId),
        _performanceService.getPerformanceProduit(event.sellerId),
        _performanceService.getPerformanceProduction(event.sellerId),
        _performanceService.getIndicePerformance(event.sellerId),
        _performanceService.getPerformanceMarketing(event.sellerId),
      ]);

      emit(AllPerformancesLoaded(
        commercial: results[0] as PerformanceCommercial?,
        client: results[1] as PerformanceClient?,
        produit: results[2] as PerformanceProduit?,
        production: results[3] as PerformanceProduction?,
        indice: results[4] as IndicePerformance?,
        marketing: results[5] as PerformanceMarketing?,
      ));
    } catch (e) {
      emit(PerformanceError(
        'Erreur lors du chargement des performances: $e',
      ));
    }
  }
}
