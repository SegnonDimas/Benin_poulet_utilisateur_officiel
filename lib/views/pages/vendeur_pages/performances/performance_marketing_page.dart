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

class PerformanceMarketingPage extends StatefulWidget {
  const PerformanceMarketingPage({super.key});

  @override
  State<PerformanceMarketingPage> createState() =>
      _PerformanceMarketingPageState();
}

class _PerformanceMarketingPageState extends State<PerformanceMarketingPage> {
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
            LoadPerformanceMarketingEvent(sellerId: seller.userId),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(
          text: 'Performance Marketing',
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

                    if (state is PerformanceMarketingLoaded) {
                      final perf = state.performance;
                      return Column(
                        children: [
                          _buildAnalyseTrafic(perf),
                          _buildImpactPromotions(perf),
                          _buildTraficChart(perf),
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

  Widget _buildAnalyseTrafic(dynamic perf) {
    final trafic = perf.analyseTrafic;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: 'Analyse de trafic',
            fontSize: mediumText(),
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTraficCard(
                  'Vues boutique',
                  '${trafic.vuesBoutique}',
                  Icons.visibility,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildTraficCard(
                  'Visiteurs uniques',
                  '${trafic.visiteursUniques}',
                  Icons.people,
                  Colors.purple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildTraficCard(
                  'Taux rebond',
                  '${trafic.tauxRebond.toStringAsFixed(1)}%',
                  Icons.exit_to_app,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildTraficCard(
                  'Durée moyenne',
                  '${trafic.dureeMoyenneVisite.toStringAsFixed(1)} min',
                  Icons.access_time,
                  Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTraficCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 30),
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
            textAlign: TextAlign.center,
            maxLine: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildTraficChart(dynamic perf) {
    final trafic = perf.analyseTrafic;

    if (trafic.vuesParJour.isEmpty) {
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
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: 'Évolution du trafic',
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
                    spots: _getChartSpots(trafic.vuesParJour),
                    isCurved: true,
                    color: Colors.blue,
                    barWidth: 3,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.blue.withOpacity(0.1),
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

  List<FlSpot> _getChartSpots(Map<String, int> data) {
    final entries = data.entries.toList();
    return List.generate(
      entries.length,
      (index) => FlSpot(index.toDouble(), entries[index].value.toDouble()),
    );
  }

  Widget _buildImpactPromotions(dynamic perf) {
    if (perf.impactPromotions.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.blue.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              const Icon(Icons.info, color: Colors.blue),
              const SizedBox(width: 12),
              Expanded(
                child: AppText(
                  text:
                      'Aucune promotion en cours. Créez une promotion pour booster vos ventes !',
                  fontSize: smallText(),
                  color: Colors.blue.shade700,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: 'Impact des promotions',
            fontSize: mediumText(),
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 12),
          ...perf.impactPromotions
              .map((promo) => _buildPromotionCard(promo))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildPromotionCard(dynamic promo) {
    final isPositive = promo.augmentationCA >= 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.local_offer,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: promo.nomPromotion,
                      fontWeight: FontWeight.bold,
                    ),
                    AppText(
                      text:
                          '${DateFormat('dd/MM').format(promo.dateDebut)} - ${DateFormat('dd/MM/yy').format(promo.dateFin)}',
                      fontSize: smallText(),
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color:
                      (isPositive ? Colors.green : Colors.red).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPositive ? Icons.trending_up : Icons.trending_down,
                      color: isPositive ? Colors.green : Colors.red,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    AppText(
                      text: '${promo.augmentationCA.toStringAsFixed(1)}%',
                      fontWeight: FontWeight.bold,
                      color: isPositive ? Colors.green : Colors.red,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'CA avec promo',
                  NumberFormat.currency(
                          locale: 'fr_FR', symbol: 'F', decimalDigits: 0)
                      .format(promo.caAvecPromo),
                  Colors.green,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.grey.shade300,
              ),
              Expanded(
                child: _buildStatItem(
                  'CA sans promo',
                  NumberFormat.currency(
                          locale: 'fr_FR', symbol: 'F', decimalDigits: 0)
                      .format(promo.caSansPromo),
                  Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Ventes avec',
                  '${promo.ventesAvecPromo}',
                  Colors.blue,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.grey.shade300,
              ),
              Expanded(
                child: _buildStatItem(
                  'Ventes sans',
                  '${promo.ventesSansPromo}',
                  Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        AppText(
          text: value,
          fontSize: mediumText(),
          fontWeight: FontWeight.bold,
          color: color,
        ),
        const SizedBox(height: 4),
        AppText(
          text: label,
          fontSize: smallText() * 0.9,
          color: Colors.grey,
          textAlign: TextAlign.center,
        ),
      ],
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
                text: 'Suggestions marketing',
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
      case 'promotion':
        typeIcon = Icons.local_offer;
        break;
      case 'visibilite':
        typeIcon = Icons.visibility;
        break;
      case 'prix':
        typeIcon = Icons.attach_money;
        break;
      default:
        typeIcon = Icons.tips_and_updates;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: priorityColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(typeIcon, color: priorityColor, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: AppText(
                        text: suggestion.titre,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: priorityColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: AppText(
                        text: suggestion.priorite.toUpperCase(),
                        fontSize: smallText() * 0.8,
                        color: priorityColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                AppText(
                  text: suggestion.description,
                  fontSize: smallText(),
                  color: Colors.grey.shade700,
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: priorityColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: AppText(
                    text: suggestion.type.toUpperCase(),
                    fontSize: smallText() * 0.8,
                    color: priorityColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
