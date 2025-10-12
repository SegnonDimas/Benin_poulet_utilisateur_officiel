import 'package:benin_poulet/bloc/performance/performance_bloc.dart';
import 'package:benin_poulet/bloc/performance/performance_event.dart';
import 'package:benin_poulet/bloc/performance/performance_state.dart';
import 'package:benin_poulet/services/user_data_service.dart';
import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class PerformanceCommercialPage extends StatefulWidget {
  const PerformanceCommercialPage({super.key});

  @override
  State<PerformanceCommercialPage> createState() =>
      _PerformanceCommercialPageState();
}

class _PerformanceCommercialPageState extends State<PerformanceCommercialPage> {
  String? sellerId;
  String selectedPeriode = 'mois';
  final UserDataService _userDataService = UserDataService();

  final List<String> periodes = [
    'jour',
    'semaine',
    'mois',
    '3mois',
    '6mois',
    'an'
  ];
  final Map<String, String> periodesLabels = {
    'jour': "Aujourd'hui",
    'semaine': '7 jours',
    'mois': '30 jours',
    '3mois': '3 mois',
    '6mois': '6 mois',
    'an': '1 an',
  };

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
            LoadPerformanceCommercialEvent(
              sellerId: seller.userId,
              periode: selectedPeriode,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(
          text: 'Performance Commerciale',
          fontSize: mediumText(),
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
      ),
      body: sellerId == null
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                _loadData();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sélecteur de période
                    _buildPeriodeSelector(),

                    // Contenu principal
                    BlocBuilder<PerformanceBloc, PerformanceState>(
                      builder: (context, state) {
                        if (state is PerformanceLoading) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(50.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        if (state is PerformanceCommercialLoaded) {
                          final perf = state.performance;
                          return Column(
                            children: [
                              // KPIs principaux
                              _buildKPIs(perf),

                              // Graphique d'évolution
                              _buildEvolutionChart(perf),

                              // Comparatif périodes
                              _buildComparatif(perf),

                              // Produits phares
                              _buildProduitsPhares(perf),

                              // Alertes
                              _buildAlertes(perf),

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
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildPeriodeSelector() {
    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: periodes.length,
        itemBuilder: (context, index) {
          final periode = periodes[index];
          final isSelected = selectedPeriode == periode;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ChoiceChip(
              backgroundColor:
                  Theme.of(context).colorScheme.inverseSurface.withOpacity(0.1),
              checkmarkColor: Colors.white,
              label: AppText(
                text: periodesLabels[periode]!,
                color: isSelected
                    ? Colors.white
                    : Theme.of(context)
                        .colorScheme
                        .inverseSurface
                        .withOpacity(0.4),
                fontWeight: FontWeight.bold,
                fontSize: context.smallText,
              ),
              selected: isSelected,
              onSelected: (selected) {
                if (selected && sellerId != null) {
                  setState(() {
                    selectedPeriode = periode;
                  });
                  context.read<PerformanceBloc>().add(
                        LoadPerformanceCommercialEvent(
                          sellerId: sellerId!,
                          periode: periode,
                        ),
                      );
                }
              },
              selectedColor: AppColors.primaryColor,

              //backgroundColor: Colors.grey.shade200,
            ),
          );
        },
      ),
    );
  }

  Widget _buildKPIs(dynamic perf) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: _buildKPICard(
              title: 'Chiffre d\'affaires',
              value:
                  '${NumberFormat.currency(locale: 'fr_FR', symbol: 'F', decimalDigits: 0).format(perf.chiffreAffaires)}',
              icon: Icons.attach_money,
              color: Colors.green,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildKPICard(
              title: 'Volume ventes',
              value: '${perf.volumeVentes}',
              icon: Icons.shopping_cart,
              color: Colors.blue,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildKPICard(
              title: 'Taux conversion',
              value: '${perf.tauxConversion.toStringAsFixed(1)}%',
              icon: Icons.trending_up,
              color: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKPICard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          AppText(
            text: value,
            fontSize: mediumText(),
            fontWeight: FontWeight.bold,
            color: color,
          ),
          AppText(
            text: title,
            fontSize: smallText() * 0.85,
            color: Colors.grey,
            maxLine: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildEvolutionChart(dynamic perf) {
    if (perf.evolutionTemporelle.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: 'Évolution du chiffre d\'affaires',
            fontSize: mediumText(),
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: _getChartSpots(perf.evolutionTemporelle),
                    isCurved: true,
                    color: AppColors.primaryColor,
                    barWidth: 3,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.primaryColor.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _getChartSpots(Map<String, double> data) {
    final entries = data.entries.toList();
    return List.generate(
      entries.length,
      (index) => FlSpot(index.toDouble(), entries[index].value / 1000),
    );
  }

  Widget _buildComparatif(dynamic perf) {
    final hebdo = perf.comparatifPeriodes['hebdomadaire'];
    final mensuel = perf.comparatifPeriodes['mensuel'];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: 'Comparatif périodes',
            fontSize: mediumText(),
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildComparatifCard(
                  'Hebdomadaire',
                  hebdo['evolution'],
                  hebdo['actuel'],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildComparatifCard(
                  'Mensuel',
                  mensuel['evolution'],
                  mensuel['actuel'],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildComparatifCard(String periode, double evolution, double actuel) {
    final isPositive = evolution >= 0;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: (isPositive ? Colors.green : Colors.red).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: (isPositive ? Colors.green : Colors.red).withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          AppText(
            text: periode,
            fontSize: smallText(),
            color: Colors.grey,
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                color: isPositive ? Colors.green : Colors.red,
                size: 20,
              ),
              AppText(
                text: '${evolution.toStringAsFixed(1)}%',
                fontSize: mediumText(),
                fontWeight: FontWeight.bold,
                color: isPositive ? Colors.green : Colors.red,
              ),
            ],
          ),
          AppText(
            text:
                '${NumberFormat.currency(locale: 'fr_FR', symbol: 'F', decimalDigits: 0).format(actuel)}',
            fontSize: smallText(),
          ),
        ],
      ),
    );
  }

  Widget _buildProduitsPhares(dynamic perf) {
    if (perf.produitsPhares.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: 'Produits phares',
            fontSize: mediumText(),
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 12),
          ...perf.produitsPhares
              .map((produit) => _buildProduitCard(produit))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildProduitCard(dynamic produit) {
    final isPositive = produit.evolution >= 0;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.shopping_bag, color: AppColors.primaryColor),
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
                  isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                  color: isPositive ? Colors.green : Colors.red,
                  size: 16,
                ),
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

  Widget _buildAlertes(dynamic perf) {
    if (perf.alertes.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: 'Alertes et notifications',
            fontSize: mediumText(),
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 12),
          ...perf.alertes.map((alerte) => _buildAlerteCard(alerte)).toList(),
        ],
      ),
    );
  }

  Widget _buildAlerteCard(dynamic alerte) {
    Color color;
    IconData icon;

    switch (alerte.type) {
      case 'success':
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      case 'warning':
        color = Colors.orange;
        icon = Icons.warning;
        break;
      default:
        color = Colors.blue;
        icon = Icons.info;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: AppText(
              text: alerte.message,
              fontSize: smallText(),
            ),
          ),
        ],
      ),
    );
  }
}
