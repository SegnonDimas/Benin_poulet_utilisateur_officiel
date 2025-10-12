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

class IndicePerformancePage extends StatefulWidget {
  const IndicePerformancePage({super.key});

  @override
  State<IndicePerformancePage> createState() => _IndicePerformancePageState();
}

class _IndicePerformancePageState extends State<IndicePerformancePage> {
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
            LoadIndicePerformanceEvent(sellerId: seller.userId),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(
          text: 'Indice Global de Performance',
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

                    if (state is IndicePerformanceLoaded) {
                      final indice = state.indice;
                      return Column(
                        children: [
                          _buildScoreGlobal(indice),
                          _buildScoresDetailles(indice),
                          _buildBadges(indice),
                          _buildObjectifs(indice),
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

  Widget _buildScoreGlobal(dynamic indice) {
    Color scoreColor;
    if (indice.scoreGlobal >= 80) {
      scoreColor = Colors.green;
    } else if (indice.scoreGlobal >= 60) {
      scoreColor = Colors.orange;
    } else {
      scoreColor = Colors.red;
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [scoreColor, scoreColor.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: scoreColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          AppText(
            text: 'Score Global',
            fontSize: mediumText(),
            color: Colors.white70,
          ),
          const SizedBox(height: 10),
          AppText(
            text: indice.scoreGlobal.toStringAsFixed(1),
            fontSize: largeText() * 2.5,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          AppText(
            text: '/ 100',
            fontSize: mediumText(),
            color: Colors.white70,
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: AppText(
              text: indice.niveauPerformance,
              fontSize: mediumText(),
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.emoji_events, color: Colors.amber, size: 28),
              const SizedBox(width: 8),
              AppText(
                text: 'Classement: #${indice.classement}',
                fontSize: mediumText(),
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScoresDetailles(dynamic indice) {
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
            text: 'Détails par catégorie',
            fontSize: mediumText(),
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 250,
            child: RadarChart(
              RadarChartData(
                radarShape: RadarShape.polygon,
                tickCount: 5,
                ticksTextStyle: const TextStyle(fontSize: 0),
                radarBorderData: BorderSide(color: Colors.grey.shade300),
                gridBorderData: BorderSide(color: Colors.grey.shade200),
                getTitle: (index, angle) {
                  final entries = indice.scoresDetailles.entries.toList();
                  if (index >= entries.length)
                    return const RadarChartTitle(text: '');
                  return RadarChartTitle(
                    text: _capitalizeString(entries[index].key),
                    angle: angle,
                  );
                },
                dataSets: [
                  RadarDataSet(
                    fillColor: AppColors.primaryColor.withOpacity(0.2),
                    borderColor: AppColors.primaryColor,
                    dataEntries: List<RadarEntry>.from(
                      indice.scoresDetailles.values
                          .map((score) => RadarEntry(value: score)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ...indice.scoresDetailles.entries.map((entry) {
            return _buildScoreBar(_capitalizeString(entry.key), entry.value);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildScoreBar(String category, double score) {
    Color barColor;
    if (score >= 80) {
      barColor = Colors.green;
    } else if (score >= 60) {
      barColor = Colors.orange;
    } else {
      barColor = Colors.red;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                text: category,
                fontSize: smallText(),
                fontWeight: FontWeight.w600,
              ),
              AppText(
                text: score.toStringAsFixed(1),
                fontSize: smallText(),
                fontWeight: FontWeight.bold,
                color: barColor,
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: score / 100,
              backgroundColor: Colors.grey.shade200,
              color: barColor,
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadges(dynamic indice) {
    if (indice.badges.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.stars, color: Colors.amber),
              const SizedBox(width: 8),
              AppText(
                text: 'Vos badges (${indice.badges.length})',
                fontSize: mediumText(),
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 140,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: indice.badges.length,
              itemBuilder: (context, index) {
                final badge = indice.badges[index];
                return _buildBadgeCard(badge);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeCard(dynamic badge) {
    Color niveauColor;
    switch (badge.niveau) {
      case 'platine':
        niveauColor = Colors.cyan;
        break;
      case 'or':
        niveauColor = Colors.amber;
        break;
      case 'argent':
        niveauColor = Colors.grey.shade400;
        break;
      default:
        niveauColor = Colors.brown.shade300;
    }

    return Container(
      width: 130,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: niveauColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: niveauColor.withOpacity(0.3), width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            badge.icone,
            style: const TextStyle(fontSize: 40),
          ),
          const SizedBox(height: 8),
          AppText(
            text: badge.nom,
            fontSize: smallText(),
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.center,
            maxLine: 2,
          ),
          const SizedBox(height: 4),
          AppText(
            text: badge.niveau.toUpperCase(),
            fontSize: smallText() * 0.8,
            color: niveauColor,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }

  Widget _buildObjectifs(dynamic indice) {
    if (indice.objectifs.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.flag, color: AppColors.primaryColor),
              const SizedBox(width: 8),
              AppText(
                text: 'Objectifs en cours',
                fontSize: mediumText(),
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...indice.objectifs
              .map((objectif) => _buildObjectifCard(objectif))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildObjectifCard(dynamic objectif) {
    final progression = objectif.progression;
    Color progressColor;

    if (progression >= 80) {
      progressColor = Colors.green;
    } else if (progression >= 50) {
      progressColor = Colors.orange;
    } else {
      progressColor = Colors.red;
    }

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
              Expanded(
                child: AppText(
                  text: objectif.titre,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (objectif.atteint)
                const Icon(Icons.check_circle, color: Colors.green, size: 20),
            ],
          ),
          const SizedBox(height: 4),
          AppText(
            text: objectif.description,
            fontSize: smallText(),
            color: Colors.grey,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progression / 100,
                    backgroundColor: Colors.grey.shade200,
                    color: progressColor,
                    minHeight: 10,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              AppText(
                text: '${progression.toStringAsFixed(0)}%',
                fontSize: smallText(),
                fontWeight: FontWeight.bold,
                color: progressColor,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                text:
                    'Actuel: ${objectif.actuel.toStringAsFixed(1)} / ${objectif.cible.toStringAsFixed(1)}',
                fontSize: smallText() * 0.9,
                color: Colors.grey,
              ),
              AppText(
                text:
                    'Échéance: ${DateFormat('dd/MM/yy').format(objectif.dateEcheance)}',
                fontSize: smallText() * 0.9,
                color: Colors.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _capitalizeString(String text) {
    if (text.isEmpty) return text;
    return '${text[0].toUpperCase()}${text.substring(1)}';
  }
}
