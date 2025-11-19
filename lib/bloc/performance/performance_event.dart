import 'package:equatable/equatable.dart';

/// Événements pour le BLoC des performances
abstract class PerformanceEvent extends Equatable {
  const PerformanceEvent();

  @override
  List<Object?> get props => [];
}

/// Charger les performances commerciales
class LoadPerformanceCommercialEvent extends PerformanceEvent {
  final String sellerId;
  final String periode; // 'jour', 'semaine', 'mois', '3mois', '6mois', 'an'

  const LoadPerformanceCommercialEvent({
    required this.sellerId,
    this.periode = 'mois',
  });

  @override
  List<Object?> get props => [sellerId, periode];
}

/// Charger les performances client
class LoadPerformanceClientEvent extends PerformanceEvent {
  final String sellerId;
  final String periode;

  const LoadPerformanceClientEvent({
    required this.sellerId,
    this.periode = 'mois',
  });

  @override
  List<Object?> get props => [sellerId, periode];
}

/// Charger les performances produit
class LoadPerformanceProduitEvent extends PerformanceEvent {
  final String sellerId;
  final String periode;

  const LoadPerformanceProduitEvent({
    required this.sellerId,
    this.periode = 'mois',
  });

  @override
  List<Object?> get props => [sellerId, periode];
}

/// Charger les performances de production
class LoadPerformanceProductionEvent extends PerformanceEvent {
  final String sellerId;

  const LoadPerformanceProductionEvent({
    required this.sellerId,
  });

  @override
  List<Object?> get props => [sellerId];
}

/// Charger l'indice de performance
class LoadIndicePerformanceEvent extends PerformanceEvent {
  final String sellerId;

  const LoadIndicePerformanceEvent({
    required this.sellerId,
  });

  @override
  List<Object?> get props => [sellerId];
}

/// Charger les performances marketing
class LoadPerformanceMarketingEvent extends PerformanceEvent {
  final String sellerId;
  final String periode;

  const LoadPerformanceMarketingEvent({
    required this.sellerId,
    this.periode = 'mois',
  });

  @override
  List<Object?> get props => [sellerId, periode];
}

/// Marquer un rappel de production comme effectué
class MarquerRappelEffectueEvent extends PerformanceEvent {
  final String rappelId;
  final String sellerId;

  const MarquerRappelEffectueEvent({
    required this.rappelId,
    required this.sellerId,
  });

  @override
  List<Object?> get props => [rappelId, sellerId];
}

/// Actualiser toutes les performances
class RefreshAllPerformancesEvent extends PerformanceEvent {
  final String sellerId;

  const RefreshAllPerformancesEvent({
    required this.sellerId,
  });

  @override
  List<Object?> get props => [sellerId];
}


