import 'package:benin_poulet/bloc/performance/performance_bloc.dart';
import 'package:benin_poulet/bloc/performance/performance_event.dart';
import 'package:benin_poulet/bloc/performance/performance_state.dart';
import 'package:benin_poulet/services/user_data_service.dart';
import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:timeago/timeago.dart' as timeago;

class PerformanceClientPage extends StatefulWidget {
  const PerformanceClientPage({super.key});

  @override
  State<PerformanceClientPage> createState() => _PerformanceClientPageState();
}

class _PerformanceClientPageState extends State<PerformanceClientPage> {
  String? sellerId;
  final UserDataService _userDataService = UserDataService();

  @override
  void initState() {
    super.initState();
    timeago.setLocaleMessages('fr', timeago.FrMessages());
    _loadData();
  }

  Future<void> _loadData() async {
    final seller = await _userDataService.getCurrentSeller();
    if (seller != null && mounted) {
      setState(() {
        sellerId = seller.userId;
      });
      context.read<PerformanceBloc>().add(
            LoadPerformanceClientEvent(sellerId: seller.userId),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(
          text: 'Performance Client',
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

                    if (state is PerformanceClientLoaded) {
                      final perf = state.performance;
                      return Column(
                        children: [
                          _buildKPIs(perf),
                          _buildClientRepartition(perf),
                          _buildSatisfactionChart(perf),
                          _buildTempsReponse(perf),
                          _buildDerniersAvis(perf),
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

  Widget _buildKPIs(dynamic perf) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildKPICard(
                  'Total clients',
                  '${perf.totalClients}',
                  Icons.people,
                  AppColors.primaryColor,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildKPICard(
                  'Satisfaction',
                  '${perf.tauxSatisfaction.toStringAsFixed(1)}/5',
                  Icons.star,
                  Colors.amber,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildKPICard(
                  'Nouveaux',
                  '${perf.nouveauxClients}',
                  Icons.person_add,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildKPICard(
                  'Fidélisation',
                  '${perf.tauxFidelisation.toStringAsFixed(1)}%',
                  Icons.favorite,
                  Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKPICard(String title, String value, IconData icon, Color color) {
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
            fontSize: largeText(),
            fontWeight: FontWeight.bold,
            color: color,
          ),
          AppText(
            text: title,
            fontSize: smallText(),
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildClientRepartition(dynamic perf) {
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
            text: 'Répartition clients',
            fontSize: mediumText(),
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    value: perf.nouveauxClients.toDouble(),
                    title:
                        'Nouveaux\n${perf.pourcentageNouveaux.toStringAsFixed(0)}%',
                    color: Colors.green,
                    radius: 80,
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    value: perf.clientsRecurrents.toDouble(),
                    title:
                        'Récurrents\n${(100 - perf.pourcentageNouveaux).toStringAsFixed(0)}%',
                    color: AppColors.primaryColor,
                    radius: 80,
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
                sectionsSpace: 2,
                centerSpaceRadius: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSatisfactionChart(dynamic perf) {
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
            text: 'Répartition des notes',
            fontSize: mediumText(),
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 20),
          ...List.generate(5, (index) {
            final note = 5 - index;
            final count =
                int.parse(perf.repartitionNotes['$note']?.toString() ?? '0');
            final total = perf.repartitionNotes.values.fold<int>(
              0,
              (int sum, dynamic val) => sum + (val as int),
            );
            final percentage = total > 0 ? (count / total * 100) : 0;

            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 80,
                    child: Row(
                      children: [
                        AppText(text: '$note', fontWeight: FontWeight.w600),
                        const SizedBox(width: 4),
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        Container(
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: percentage / 100,
                          child: Container(
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 50,
                    child: AppText(
                      text: '$count',
                      fontSize: smallText(),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTempsReponse(dynamic perf) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade400, Colors.blue.shade600],
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                text: 'Temps de réponse moyen',
                color: Colors.white70,
                fontSize: smallText(),
              ),
              const SizedBox(height: 4),
              AppText(
                text: '${perf.tempsReponse.toStringAsFixed(1)} min',
                fontSize: largeText(),
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ],
          ),
          const Icon(Icons.access_time, color: Colors.white, size: 40),
        ],
      ),
    );
  }

  Widget _buildDerniersAvis(dynamic perf) {
    if (perf.derniersAvis.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: 'Derniers avis',
            fontSize: mediumText(),
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 12),
          ...perf.derniersAvis.map((avis) => _buildAvisCard(avis)).toList(),
        ],
      ),
    );
  }

  Widget _buildAvisCard(dynamic avis) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                    child: AppText(
                      text: avis.nomClient[0].toUpperCase(),
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: avis.nomClient,
                        fontWeight: FontWeight.w600,
                      ),
                      AppText(
                        text: timeago.format(avis.date, locale: 'fr'),
                        fontSize: smallText() * 0.9,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    index < avis.note ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          AppText(
            text: avis.commentaire,
            fontSize: smallText(),
            color: Colors.grey.shade700,
          ),
        ],
      ),
    );
  }
}
