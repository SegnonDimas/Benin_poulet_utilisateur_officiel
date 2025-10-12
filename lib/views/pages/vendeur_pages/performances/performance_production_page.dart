import 'package:benin_poulet/bloc/performance/performance_bloc.dart';
import 'package:benin_poulet/bloc/performance/performance_event.dart';
import 'package:benin_poulet/bloc/performance/performance_state.dart';
import 'package:benin_poulet/services/user_data_service.dart';
import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class PerformanceProductionPage extends StatefulWidget {
  const PerformanceProductionPage({super.key});

  @override
  State<PerformanceProductionPage> createState() =>
      _PerformanceProductionPageState();
}

class _PerformanceProductionPageState extends State<PerformanceProductionPage> {
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
            LoadPerformanceProductionEvent(sellerId: seller.userId),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(
          text: 'Performance Production',
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

                    if (state is PerformanceProductionLoaded) {
                      final perf = state.performance;
                      return Column(
                        children: [
                          _buildRappels(perf),
                          _buildFichesTechniques(perf),
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

  Widget _buildRappels(dynamic perf) {
    final rappelsActifs = perf.rappels.where((r) => !r.effectue).toList();

    if (rappelsActifs.isEmpty) {
      return Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.green.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 40),
            const SizedBox(width: 16),
            Expanded(
              child: AppText(
                text: 'Aucun rappel en attente. Vous êtes à jour !',
                color: Colors.green.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.notifications_active, color: Colors.red),
              const SizedBox(width: 8),
              AppText(
                text: 'Rappels en attente (${rappelsActifs.length})',
                fontSize: mediumText(),
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...rappelsActifs.map((rappel) => _buildRappelCard(rappel)).toList(),
        ],
      ),
    );
  }

  Widget _buildRappelCard(dynamic rappel) {
    Color priorityColor;
    switch (rappel.priorite) {
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
    switch (rappel.type) {
      case 'vaccination':
        typeIcon = Icons.vaccines;
        break;
      case 'recolte':
        typeIcon = Icons.grass;
        break;
      case 'accouplement':
        typeIcon = Icons.favorite;
        break;
      default:
        typeIcon = Icons.event;
    }

    final isOverdue = rappel.datePrevue.isBefore(DateTime.now());

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: priorityColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: priorityColor.withOpacity(0.3),
          width: isOverdue ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: priorityColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(typeIcon, color: priorityColor, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: rappel.titre,
                      fontWeight: FontWeight.bold,
                    ),
                    AppText(
                      text: rappel.description,
                      fontSize: smallText(),
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    isOverdue ? Icons.warning : Icons.calendar_today,
                    size: 16,
                    color: isOverdue ? Colors.red : Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  AppText(
                    text: DateFormat('dd/MM/yyyy').format(rappel.datePrevue),
                    fontSize: smallText(),
                    color: isOverdue ? Colors.red : Colors.grey,
                    fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
                  ),
                  if (isOverdue) ...[
                    const SizedBox(width: 8),
                    AppText(
                      text: '(En retard)',
                      fontSize: smallText(),
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {
                  if (sellerId != null) {
                    context.read<PerformanceBloc>().add(
                          MarquerRappelEffectueEvent(
                            rappelId: rappel.id,
                            sellerId: sellerId!,
                          ),
                        );
                  }
                },
                icon: const Icon(Icons.check, size: 16),
                label: AppText(
                  text: 'Fait',
                  color: Colors.white,
                  fontSize: smallText(),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: priorityColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  minimumSize: Size.zero,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFichesTechniques(dynamic perf) {
    if (perf.fichesTechniques.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.assignment, color: AppColors.primaryColor),
              const SizedBox(width: 8),
              AppText(
                text: 'Fiches techniques',
                fontSize: mediumText(),
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...perf.fichesTechniques
              .map((fiche) => _buildFicheCard(fiche))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildFicheCard(dynamic fiche) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.pets, color: AppColors.primaryColor),
        ),
        title: AppText(
          text: fiche.espece,
          fontWeight: FontWeight.bold,
        ),
        subtitle: AppText(
          text: '${fiche.quantite} têtes',
          fontSize: smallText(),
          color: Colors.grey,
        ),
        children: [
          const Divider(),

          // Statistiques
          if (fiche.statistiques.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: 'Statistiques',
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                  const SizedBox(height: 8),
                  ...fiche.statistiques.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText(
                            text: _capitalizeString(
                                entry.key.replaceAll('_', ' ')),
                            fontSize: smallText(),
                          ),
                          AppText(
                            text: '${entry.value}',
                            fontSize: smallText(),
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ],

          // Vaccinations
          if (fiche.vaccinations.isNotEmpty) ...[
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: 'Vaccinations',
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 8),
                  ...fiche.vaccinations
                      .map((vacc) => _buildVaccinationItem(vacc))
                      .toList(),
                ],
              ),
            ),
          ],

          // Périodes de récolte
          if (fiche.periodesRecolte.isNotEmpty) ...[
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: 'Dernières récoltes',
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 8),
                  ...fiche.periodesRecolte
                      .map((periode) => _buildRecolteItem(periode))
                      .toList(),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildVaccinationItem(dynamic vacc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: vacc.effectuee
            ? Colors.green.withOpacity(0.1)
            : Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: vacc.effectuee
              ? Colors.green.withOpacity(0.3)
              : Colors.orange.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            vacc.effectuee ? Icons.check_circle : Icons.pending,
            color: vacc.effectuee ? Colors.green : Colors.orange,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: vacc.nom,
                  fontSize: smallText(),
                  fontWeight: FontWeight.w600,
                ),
                AppText(
                  text:
                      'Prévu: ${DateFormat('dd/MM/yyyy').format(vacc.datePrevue)}',
                  fontSize: smallText() * 0.9,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecolteItem(dynamic periode) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                text: periode.type.toUpperCase(),
                fontSize: smallText() * 0.9,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
              AppText(
                text:
                    '${DateFormat('dd/MM').format(periode.dateDebut)} - ${DateFormat('dd/MM/yy').format(periode.dateFin)}',
                fontSize: smallText() * 0.85,
                color: Colors.grey,
              ),
            ],
          ),
          AppText(
            text: '${periode.quantiteRecoltee}',
            fontSize: mediumText(),
            fontWeight: FontWeight.bold,
            color: Colors.green,
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
