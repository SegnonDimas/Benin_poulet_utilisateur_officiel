import 'package:benin_poulet/bloc/performance/performance_bloc.dart';
import 'package:benin_poulet/bloc/performance/performance_event.dart';
import 'package:benin_poulet/bloc/performance/performance_state.dart';
import 'package:benin_poulet/constants/routes.dart';
import 'package:benin_poulet/services/user_data_service.dart';
import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Page principale des performances avec navigation vers les modules
class PerformancesMainPage extends StatefulWidget {
  const PerformancesMainPage({super.key});

  @override
  State<PerformancesMainPage> createState() => _PerformancesMainPageState();
}

class _PerformancesMainPageState extends State<PerformancesMainPage> {
  String? sellerId;
  final UserDataService _userDataService = UserDataService();

  @override
  void initState() {
    super.initState();
    _loadSellerId();
  }

  Future<void> _loadSellerId() async {
    final seller = await _userDataService.getCurrentSeller();
    if (seller != null && mounted) {
      setState(() {
        sellerId = seller.userId;
      });
      // Charger l'indice de performance global
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
          text: 'Performances',
          fontSize: mediumText(),
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: sellerId == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Score global
                  _buildScoreGlobal(),

                  const SizedBox(height: 20),

                  // Modules de performance
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: AppText(
                      text: 'Modules de performance',
                      fontSize: largeText(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Grille des modules
                  _buildModulesGrid(),

                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  /// Widget pour afficher le score global
  Widget _buildScoreGlobal() {
    return BlocBuilder<PerformanceBloc, PerformanceState>(
      builder: (context, state) {
        if (state is PerformanceLoading) {
          return Container(
            height: 200,
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryColor,
                  AppColors.primaryColor.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          );
        }

        if (state is IndicePerformanceLoaded) {
          final indice = state.indice;
          return Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryColor,
                  AppColors.primaryColor.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryColor.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
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
                  fontSize: largeText() * 2,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                AppText(
                  text: '/ 100',
                  fontSize: mediumText(),
                  color: Colors.white70,
                ),
                const SizedBox(height: 10),
                AppText(
                  text: indice.niveauPerformance,
                  fontSize: mediumText(),
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.emoji_events,
                        color: Colors.amber, size: 24),
                    const SizedBox(width: 8),
                    AppText(
                      text: 'Classement: #${indice.classement}',
                      fontSize: smallText(),
                      color: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
          );
        }

        return Container(
          height: 200,
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.grey.shade400,
                Colors.grey.shade300,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: AppText(
              text: 'Données non disponibles',
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  /// Grille des modules de performance
  Widget _buildModulesGrid() {
    final modules = [
      {
        'title': 'Commercial',
        'icon': Icons.trending_up,
        'color': Colors.blue,
        'route': AppRoutes.PERFORMANCE_COMMERCIAL,
        'description': 'CA, ventes, conversion',
      },
      {
        'title': 'Client',
        'icon': Icons.people,
        'color': Colors.green,
        'route': AppRoutes.PERFORMANCE_CLIENT,
        'description': 'Satisfaction, fidélisation',
      },
      {
        'title': 'Produit',
        'icon': Icons.inventory,
        'color': Colors.orange,
        'route': AppRoutes.PERFORMANCE_PRODUIT,
        'description': 'Top ventes, suggestions',
      },
      {
        'title': 'Production',
        'icon': Icons.agriculture,
        'color': Colors.brown,
        'route': AppRoutes.PERFORMANCE_PRODUCTION,
        'description': 'Vaccinations, récoltes',
      },
      {
        'title': 'Indice Global',
        'icon': Icons.dashboard,
        'color': Colors.purple,
        'route': AppRoutes.INDICE_PERFORMANCE,
        'description': 'Score, badges, objectifs',
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.9,
        ),
        itemCount: modules.length,
        itemBuilder: (context, index) {
          final module = modules[index];
          return _buildModuleCard(
            title: module['title'] as String,
            icon: module['icon'] as IconData,
            color: module['color'] as Color,
            route: module['route'] as String,
            description: module['description'] as String,
          );
        },
      ),
    );
  }

  /// Carte de module
  Widget _buildModuleCard({
    required String title,
    required IconData icon,
    required Color color,
    required String route,
    required String description,
  }) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 40,
                color: color,
              ),
            ),
            const SizedBox(height: 12),
            AppText(
              text: title,
              fontSize: mediumText(),
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: AppText(
                text: description,
                fontSize: smallText() * 0.9,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                textAlign: TextAlign.center,
                maxLine: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
