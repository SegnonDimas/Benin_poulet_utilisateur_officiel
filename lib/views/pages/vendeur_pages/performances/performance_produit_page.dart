import 'package:benin_poulet/bloc/performance/performance_bloc.dart';
import 'package:benin_poulet/bloc/performance/performance_event.dart';
import 'package:benin_poulet/bloc/performance/performance_state.dart';
import 'package:benin_poulet/services/user_data_service.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class PerformanceProduitPage extends StatefulWidget {
  const PerformanceProduitPage({super.key});

  @override
  State<PerformanceProduitPage> createState() => _PerformanceProduitPageState();
}

class _PerformanceProduitPageState extends State<PerformanceProduitPage> {
  String? sellerId;
  final UserDataService _userDataService = UserDataService();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final seller = await _userDataService.getCurrentSeller();
    if (seller != null && mounted) {
      setState(() {
        sellerId = seller.userId;
      });
      context.read<PerformanceBloc>().add(
            LoadPerformanceProduitEvent(sellerId: seller.userId),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(
          text: 'Performance Produit',
          fontSize: mediumText(),
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
      ),
      body: sellerId == null
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: BlocBuilder<PerformanceBloc, PerformanceState>(
                  builder: (context, state) {
                    if (state is PerformanceLoading) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(50.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    if (state is PerformanceProduitLoaded) {
                      final perf = state.performance;
                      return Column(
                        children: [
                          _buildTopVentes(perf),
                          _buildProduitsEnBaisse(perf),
                          _buildProduitsAbandonnes(perf),
                          _buildSuggestions(perf),
                          const SizedBox(height: 20),
                        ],
                      );
                    }

                    if (state is PerformanceError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: AppText(
                            text: state.message,
                            color: Colors.red,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
    );
  }

  Widget _buildTopVentes(dynamic perf) {
    if (perf.topVentes.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.emoji_events, color: Colors.amber),
              const SizedBox(width: 8),
              AppText(
                text: 'Top ventes',
                fontSize: mediumText(),
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...perf.topVentes.asMap().entries.map((entry) {
            final index = entry.key;
            final produit = entry.value;
            return _buildTopProduitCard(produit, index + 1);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTopProduitCard(dynamic produit, int rank) {
    final isPositive = produit.evolution >= 0;
    Color rankColor;
    switch (rank) {
      case 1:
        rankColor = Colors.amber;
        break;
      case 2:
        rankColor = Colors.grey.shade400;
        break;
      case 3:
        rankColor = Colors.brown.shade300;
        break;
      default:
        rankColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: rankColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: rankColor.withOpacity(0.1),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: rankColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: AppText(
                text: '$rank',
                fontSize: largeText(),
                fontWeight: FontWeight.bold,
                color: rankColor,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: produit.nom,
                  fontWeight: FontWeight.w600,
                ),
                AppText(
                  text:
                      '${produit.nombreVentes} ventes • ${NumberFormat.currency(locale: 'fr_FR', symbol: 'F', decimalDigits: 0).format(produit.ca)}',
                  fontSize: smallText(),
                  color: Colors.grey,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: (isPositive ? Colors.green : Colors.red).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isPositive ? Icons.trending_up : Icons.trending_down,
                  color: isPositive ? Colors.green : Colors.red,
                  size: 16,
                ),
                const SizedBox(width: 4),
                AppText(
                  text: '${produit.evolution.toStringAsFixed(1)}%',
                  fontSize: smallText(),
                  color: isPositive ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProduitsEnBaisse(dynamic perf) {
    if (perf.produitsEnBaisse.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.trending_down, color: Colors.red),
              const SizedBox(width: 8),
              AppText(
                text: 'Produits en baisse',
                fontSize: mediumText(),
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...perf.produitsEnBaisse
              .map((produit) => _buildProduitBaisseCard(produit))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildProduitBaisseCard(dynamic produit) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber, color: Colors.red),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: produit.nom,
                  fontWeight: FontWeight.w600,
                ),
                AppText(
                  text:
                      'Baisse de ${produit.baisseCA.toStringAsFixed(1)}% • ${produit.nombreVentesActuel} ventes (vs ${produit.nombreVentesPrecedent})',
                  fontSize: smallText(),
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProduitsAbandonnes(dynamic perf) {
    if (perf.produitsAbandonnes.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.remove_shopping_cart, color: Colors.orange),
              const SizedBox(width: 8),
              AppText(
                text: 'Produits abandonnés',
                fontSize: mediumText(),
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...perf.produitsAbandonnes
              .map((produit) => _buildProduitAbandonneCard(produit))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildProduitAbandonneCard(dynamic produit) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.visibility, color: Colors.orange),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: produit.nom,
                  fontWeight: FontWeight.w600,
                ),
                AppText(
                  text:
                      '${produit.nombreConsultations} vues • ${produit.nombreAchats} achats (${produit.tauxAbandon.toStringAsFixed(1)}% d\'abandon)',
                  fontSize: smallText(),
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestions(dynamic perf) {
    if (perf.suggestions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lightbulb, color: Colors.amber),
              const SizedBox(width: 8),
              AppText(
                text: 'Suggestions d\'optimisation',
                fontSize: mediumText(),
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...perf.suggestions
              .map((suggestion) => _buildSuggestionCard(suggestion))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildSuggestionCard(dynamic suggestion) {
    Color priorityColor;
    switch (suggestion.priorite) {
      case 'haute':
        priorityColor = Colors.red;
        break;
      case 'moyenne':
        priorityColor = Colors.orange;
        break;
      default:
        priorityColor = Colors.green;
    }

    IconData typeIcon;
    switch (suggestion.type) {
      case 'prix':
        typeIcon = Icons.attach_money;
        break;
      case 'description':
        typeIcon = Icons.description;
        break;
      case 'images':
        typeIcon = Icons.image;
        break;
      default:
        typeIcon = Icons.tips_and_updates;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: priorityColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: priorityColor.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: priorityColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(typeIcon, color: priorityColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    AppText(
                      text: suggestion.type.toUpperCase(),
                      fontSize: smallText() * 0.9,
                      fontWeight: FontWeight.bold,
                      color: priorityColor,
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: priorityColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: AppText(
                        text: suggestion.priorite,
                        fontSize: smallText() * 0.8,
                        color: priorityColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                AppText(
                  text: suggestion.suggestion,
                  fontSize: smallText(),
                  color: Colors.grey.shade700,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
