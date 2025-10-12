import 'package:benin_poulet/models/indice_performance.dart';
import 'package:benin_poulet/models/performance_client.dart';
import 'package:benin_poulet/models/performance_commercial.dart';
import 'package:benin_poulet/models/performance_marketing.dart';
import 'package:benin_poulet/models/performance_production.dart';
import 'package:benin_poulet/models/performance_produit.dart';
import 'package:equatable/equatable.dart';

/// États pour le BLoC des performances
abstract class PerformanceState extends Equatable {
  const PerformanceState();

  @override
  List<Object?> get props => [];
}

/// État initial
class PerformanceInitial extends PerformanceState {}

/// Chargement en cours
class PerformanceLoading extends PerformanceState {
  final String type; // 'commercial', 'client', 'produit', etc.

  const PerformanceLoading(this.type);

  @override
  List<Object?> get props => [type];
}

/// Performance commerciale chargée
class PerformanceCommercialLoaded extends PerformanceState {
  final PerformanceCommercial performance;

  const PerformanceCommercialLoaded(this.performance);

  @override
  List<Object?> get props => [performance];
}

/// Performance client chargée
class PerformanceClientLoaded extends PerformanceState {
  final PerformanceClient performance;

  const PerformanceClientLoaded(this.performance);

  @override
  List<Object?> get props => [performance];
}

/// Performance produit chargée
class PerformanceProduitLoaded extends PerformanceState {
  final PerformanceProduit performance;

  const PerformanceProduitLoaded(this.performance);

  @override
  List<Object?> get props => [performance];
}

/// Performance production chargée
class PerformanceProductionLoaded extends PerformanceState {
  final PerformanceProduction performance;

  const PerformanceProductionLoaded(this.performance);

  @override
  List<Object?> get props => [performance];
}

/// Indice de performance chargé
class IndicePerformanceLoaded extends PerformanceState {
  final IndicePerformance indice;

  const IndicePerformanceLoaded(this.indice);

  @override
  List<Object?> get props => [indice];
}

/// Performance marketing chargée
class PerformanceMarketingLoaded extends PerformanceState {
  final PerformanceMarketing performance;

  const PerformanceMarketingLoaded(this.performance);

  @override
  List<Object?> get props => [performance];
}

/// Toutes les performances chargées
class AllPerformancesLoaded extends PerformanceState {
  final PerformanceCommercial? commercial;
  final PerformanceClient? client;
  final PerformanceProduit? produit;
  final PerformanceProduction? production;
  final IndicePerformance? indice;
  final PerformanceMarketing? marketing;

  const AllPerformancesLoaded({
    this.commercial,
    this.client,
    this.produit,
    this.production,
    this.indice,
    this.marketing,
  });

  @override
  List<Object?> get props => [
        commercial,
        client,
        produit,
        production,
        indice,
        marketing,
      ];

  AllPerformancesLoaded copyWith({
    PerformanceCommercial? commercial,
    PerformanceClient? client,
    PerformanceProduit? produit,
    PerformanceProduction? production,
    IndicePerformance? indice,
    PerformanceMarketing? marketing,
  }) {
    return AllPerformancesLoaded(
      commercial: commercial ?? this.commercial,
      client: client ?? this.client,
      produit: produit ?? this.produit,
      production: production ?? this.production,
      indice: indice ?? this.indice,
      marketing: marketing ?? this.marketing,
    );
  }
}

/// Erreur lors du chargement
class PerformanceError extends PerformanceState {
  final String message;
  final String? type;

  const PerformanceError(this.message, {this.type});

  @override
  List<Object?> get props => [message, type];
}
