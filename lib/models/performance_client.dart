import 'package:cloud_firestore/cloud_firestore.dart';

/// Modèle pour les performances client d'un vendeur
class PerformanceClient {
  final String id;
  final String sellerId;
  final int nouveauxClients;
  final int clientsRecurrents;
  final double tauxSatisfaction;
  final Map<String, int> repartitionNotes; // {1: count, 2: count, etc.}
  final double tempsReponse; // en minutes
  final double tauxFidelisation; // en %
  final List<AvisClient> derniersAvis;
  final Map<String, int> evolutionClients; // {date: nombre clients}
  final DateTime dateCalcul;

  PerformanceClient({
    required this.id,
    required this.sellerId,
    required this.nouveauxClients,
    required this.clientsRecurrents,
    required this.tauxSatisfaction,
    required this.repartitionNotes,
    required this.tempsReponse,
    required this.tauxFidelisation,
    required this.derniersAvis,
    required this.evolutionClients,
    required this.dateCalcul,
  });

  factory PerformanceClient.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return PerformanceClient(
      id: doc.id,
      sellerId: data['sellerId'] ?? '',
      nouveauxClients: data['nouveauxClients'] ?? 0,
      clientsRecurrents: data['clientsRecurrents'] ?? 0,
      tauxSatisfaction: (data['tauxSatisfaction'] ?? 0).toDouble(),
      repartitionNotes: Map<String, int>.from(
        data['repartitionNotes'] ?? {},
      ),
      tempsReponse: (data['tempsReponse'] ?? 0).toDouble(),
      tauxFidelisation: (data['tauxFidelisation'] ?? 0).toDouble(),
      derniersAvis: (data['derniersAvis'] as List<dynamic>?)
              ?.map((e) => AvisClient.fromMap(e))
              .toList() ??
          [],
      evolutionClients: Map<String, int>.from(
        data['evolutionClients'] ?? {},
      ),
      dateCalcul:
          (data['dateCalcul'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sellerId': sellerId,
      'nouveauxClients': nouveauxClients,
      'clientsRecurrents': clientsRecurrents,
      'tauxSatisfaction': tauxSatisfaction,
      'repartitionNotes': repartitionNotes,
      'tempsReponse': tempsReponse,
      'tauxFidelisation': tauxFidelisation,
      'derniersAvis': derniersAvis.map((e) => e.toMap()).toList(),
      'evolutionClients': evolutionClients,
      'dateCalcul': Timestamp.fromDate(dateCalcul),
    };
  }

  int get totalClients => nouveauxClients + clientsRecurrents;

  double get pourcentageNouveaux =>
      totalClients > 0 ? (nouveauxClients / totalClients * 100) : 0;
}

/// Avis client
class AvisClient {
  final String clientId;
  final String nomClient;
  final int note;
  final String commentaire;
  final DateTime date;

  AvisClient({
    required this.clientId,
    required this.nomClient,
    required this.note,
    required this.commentaire,
    required this.date,
  });

  factory AvisClient.fromMap(Map<String, dynamic> map) {
    return AvisClient(
      clientId: map['clientId'] ?? '',
      nomClient: map['nomClient'] ?? '',
      note: map['note'] ?? 0,
      commentaire: map['commentaire'] ?? '',
      date: (map['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'clientId': clientId,
      'nomClient': nomClient,
      'note': note,
      'commentaire': commentaire,
      'date': Timestamp.fromDate(date),
    };
  }
}
