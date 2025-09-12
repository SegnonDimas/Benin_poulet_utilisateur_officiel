import 'package:benin_poulet/constants/imagesPaths.dart';
import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/pages/vendeur_pages/v_homePage.dart';
import 'package:benin_poulet/views/sizes/app_sizes.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/app_attributs.dart';
import '../../../constants/routes.dart';
import '../../../core/firebase/auth/auth_services.dart';
import '../../../services/user_data_service.dart';
import '../../../utils/app_utils.dart';
import '../../../widgets/app_text.dart';
import '../../sizes/text_sizes.dart';

class VMainPage extends StatefulWidget {
  const VMainPage({super.key});

  @override
  State<VMainPage> createState() => _VMainPageState();
}

class _VMainPageState extends State<VMainPage> {
  // page view controller
  final PageController _pageViewController = PageController(
    initialPage: 0,
  );

  // liste des icônes du bottomNavigationBar
  final List<Icon> _bottomNavigationBarItems = [
    Icon(
      Icons.home_filled,
      size: largeText() * 1.2,
    ),
    /*Icon(Icons.edit_calendar_rounded, size: largeText() * 1.2),
    Icon(
      Icons.payment,
      size: largeText() * 1.2,
    ),*/
    Icon(
      Icons.wechat_rounded,
      size: largeText() * 1.2,
    ),
  ];

  // liste des pages de la page principale
  final List<Widget> _pages = [
    const VHomePage(),
    Center(
      child: AppText(text: 'Messages page'),
    ),
  ];

  // liste des titres de l'AppBar (en fonction de l'index de la page currentPagee
  final List<Widget> _pagesTitle = [
    AppText(text: 'Accueil'),
    AppText(text: 'Messages'),
  ];

  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    var space = SizedBox(
      height: appHeightSize(context) * 0.05,
    );
    return SafeArea(
      top: false,
      child: Scaffold(
        ///Drawer
        drawer: _buildDrawer(),

        ///AppBar
        appBar: AppBar(
          //leading: IconButton(onPressed: null, icon: Icon(Icons.account_circle)),
          title: _pagesTitle[currentPage],
          centerTitle: true,
          actions: const [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Icon(Icons.notifications_sharp),
            )
          ],
        ),

        /// corps de l'app
        body: Center(
          child: PageView.builder(
            itemCount: _pages.length,
            controller: _pageViewController,
            onPageChanged: (index) {
              setState(() {
                if (index == _pages.length) {
                  currentPage = _pages.length - 1;
                } else {
                  currentPage = index;
                }
              });
            },
            itemBuilder: (BuildContext context, int index) {
              return _pages[currentPage];
            },

            /*controller: _pageViewController,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
            children: _pages,*/
          ),
        ),

        /// bottomNavigationBar
        bottomNavigationBar: CurvedNavigationBar(
          height: context.height * 0.07,
          backgroundColor: Colors.transparent,
          color: Theme.of(context).colorScheme.background,
          //buttonBackgroundColor: primaryColor,
          //selectedColor: Colors.white,
          //unselectedColor: Theme.of(context).colorScheme.inversePrimary,
          items: _bottomNavigationBarItems,
          index: currentPage,
          onTap: (index) {
            //Handle button tap
            setState(() {
              currentPage = index;

              //_pageViewController.jumpToPage(currentPage);
              _pageViewController.animateToPage(currentPage,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.linear);
            });
          },
        ),
      ),
    );
  }

  /// Construit le Drawer moderne pour les vendeurs
  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          // Header du Drawer
          _buildDrawerHeader(),

          // Liste des éléments de navigation
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Section principale
                // _buildNavigationSection(),

                // Divider
                //const Divider(),
                SizedBox(
                  height: context.height * 0.06,
                ),
                // Section aide et support
                _buildHelpSection(),

                // Divider
                const Divider(),

                // Section paramètres et déconnexion
                _buildSettingsSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Construit l'en-tête du Drawer avec les informations utilisateur
  Widget _buildDrawerHeader() {
    return Container(
      height: context.height * 0.3,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryColor,
            AppColors.primaryColor.withOpacity(0.8),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Logo
            ClipRRect(
              borderRadius: BorderRadius.circular(1000),
              child: Image.asset(
                ImagesPaths.logoLanhi,
                width: context.height * 0.15,
                height: context.height * 0.15,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 15),
            // Nom de l'utilisateur
            FutureBuilder<String?>(
              future: _getUserName(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  return AppText(
                    text: snapshot.data!,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  );
                }
                return const AppText(
                  text: 'Vendeur',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                );
              },
            ),
            const SizedBox(height: 5),
            // Nom de la boutique
            FutureBuilder<String?>(
              future: _getStoreName(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  return AppText(
                    text: "(${snapshot.data!})",
                    fontSize: 14,
                    color: Colors.white,
                  );
                }
                return const AppText(
                  text: 'Boutique',
                  fontSize: 14,
                  color: Colors.white70,
                );
              },
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  /// Construit la section de navigation principale
  Widget _buildNavigationSection() {
    return Column(
      children: [
        _buildDrawerItem(
          icon: Icons.dashboard,
          title: 'Tableau de bord',
          onTap: () {
            Navigator.pop(context);
            // Déjà sur la page d'accueil
          },
        ),
        _buildDrawerItem(
          icon: Icons.store,
          title: 'Ma boutique',
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(
                context, AppRoutes.VENDEURPRESENTATIONBOUTIQUEPAGE);
          },
        ),
        _buildDrawerItem(
          icon: Icons.inventory,
          title: 'Mes produits',
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, AppRoutes.VENDEURPRODUITSLISTPAGE);
          },
        ),
        _buildDrawerItem(
          icon: Icons.add_box,
          title: 'Ajouter un produit',
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, AppRoutes.AJOUTNOUVEAUPRODUITPAGE);
          },
        ),
        _buildDrawerItem(
          icon: Icons.shopping_bag,
          title: 'Commandes',
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, AppRoutes.VENDEURCOMMANDELISTPAGE);
          },
        ),
        _buildDrawerItem(
          icon: Icons.analytics,
          title: 'Performances',
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, AppRoutes.VENDEURPERFORMANCESPAGE);
          },
        ),
        _buildDrawerItem(
          icon: Icons.account_balance_wallet,
          title: 'Portefeuille',
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, AppRoutes.VENDEURPORTEFEUILLEPAGE);
          },
        ),
        _buildDrawerItem(
          icon: Icons.person,
          title: 'Mon profil',
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, AppRoutes.VENDEURPROFILPAGE);
          },
        ),
      ],
    );
  }

  /// Construit la section d'aide et support
  Widget _buildHelpSection() {
    return Column(
      children: [
        _buildDrawerItem(
          icon: Icons.help_outline,
          title: 'Aide & Support',
          onTap: () {
            Navigator.pop(context);
            _showHelpDialog();
          },
        ),
        _buildDrawerItem(
          icon: Icons.info_outline,
          title: 'À propos',
          onTap: () {
            Navigator.pop(context);
            _showAboutDialog();
          },
        ),
        _buildDrawerItem(
          icon: Icons.share,
          title: 'Partager l\'application',
          onTap: () {
            Navigator.pop(context);
            _shareApp();
          },
        ),
      ],
    );
  }

  /// Construit la section des paramètres et déconnexion
  Widget _buildSettingsSection() {
    return Column(
      children: [
        _buildDrawerItem(
          icon: Icons.settings,
          title: 'Paramètres',
          onTap: () {
            Navigator.pop(context);
            // TODO: Implémenter la page des paramètres
            AppUtils.showInfoNotification(
                context, 'Page des paramètres en cours de développement');
          },
        ),
        _buildDrawerItem(
          icon: Icons.logout,
          title: 'Déconnexion',
          onTap: () {
            Navigator.pop(context);
            _showLogoutDialog();
          },
        ),
      ],
    );
  }

  /// Construit un élément du Drawer
  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: AppColors.primaryColor,
        size: 24,
      ),
      title: AppText(
        text: title,
        fontSize: 16,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      onTap: onTap,
      hoverColor: AppColors.primaryColor.withOpacity(0.1),
    );
  }

  /// Récupère le nom de l'utilisateur connecté
  Future<String?> _getUserName() async {
    try {
      final user = await UserDataService().getCurrentUser();
      return user?.fullName;
    } catch (e) {
      print('Erreur lors de la récupération du nom utilisateur: $e');
      return null;
    }
  }

  Future<String?> _getStoreName() async {
    try {
      final storeName = await UserDataService().getCurrentSellerShopName();
      return storeName;
    } catch (e) {
      print('Erreur lors de la récupération du nom utilisateur: $e');
      return null;
    }
  }

  /// Affiche le dialogue d'aide et support
  /*void _showHelpDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    text: 'Aide & Support',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Contact
                    _buildContactSection(),
                    const SizedBox(height: 30),

                    // FAQ
                    _buildFAQSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }*/

  /// Construit la section de contact
  Widget _buildContactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: 'Contactez-nous',
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 15),
        _buildContactItem(
          icon: Icons.phone,
          title: 'Téléphone',
          subtitle: AppAttributes.appAuthorPhone,
          onTap: () {
            // TODO: Implémenter l'appel téléphonique
            AppUtils.showInfoNotification(
                context, 'Fonctionnalité d\'appel en cours de développement');
          },
        ),
        _buildContactItem(
          icon: Icons.email,
          title: 'Email',
          subtitle: AppAttributes.appAuthorEmail,
          onTap: () {
            // TODO: Implémenter l'envoi d'email
            AppUtils.showInfoNotification(
                context, 'Fonctionnalité d\'email en cours de développement');
          },
        ),
        _buildContactItem(
          icon: Icons.access_time,
          title: 'Heures de support',
          subtitle: 'Lundi - Vendredi: 8h00 - 18h00',
          onTap: null,
        ),
      ],
    );
  }

  /// Construit un élément de contact
  /*Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primaryColor.withOpacity(0.1),
          child: Icon(icon, color: AppColors.primaryColor),
        ),
        title: AppText(text: title, fontWeight: FontWeight.w600),
        subtitle: AppText(text: subtitle, fontSize: 14),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        tileColor:
            onTap != null ? AppColors.primaryColor.withOpacity(0.05) : null,
      ),
    );
  }*/

  /// Construit la section FAQ
  Widget _buildFAQSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: 'Questions fréquentes',
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 15),
        _buildFAQItem(
          question: 'Comment ajouter un nouveau produit ?',
          answer:
              'Allez dans "Ajouter un produit" et remplissez les informations requises.',
        ),
        _buildFAQItem(
          question: 'Comment gérer mes commandes ?',
          answer:
              'Consultez la section "Commandes" pour voir et gérer toutes vos commandes.',
        ),
        _buildFAQItem(
          question: 'Comment consulter mes performances ?',
          answer:
              'La section "Performances" vous donne un aperçu de vos ventes et statistiques.',
        ),
      ],
    );
  }

  /// Construit un élément FAQ
  Widget _buildFAQItem({
    required String question,
    required String answer,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: question,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryColor,
          ),
          const SizedBox(height: 8),
          AppText(
            text: answer,
            fontSize: 14,
            color: Colors.grey.shade700,
          ),
        ],
      ),
    );
  }

  void _showHelpDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      //showDragHandle: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 10),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .inverseSurface
                      .withOpacity(0.6),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Icon(
                      Icons.help_outline,
                      color: AppColors.primaryColor,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    AppText(
                      text: 'Aide & Support',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                      overflow: TextOverflow.visible,
                      maxLine: 2,
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.close,
                        color: Theme.of(context)
                            .colorScheme
                            .inverseSurface
                            .withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          text: 'Comment pouvons-nous vous aider ?',
                          fontSize: 16,
                        ),
                        const SizedBox(height: 24),

                        // Contact items
                        _buildContactItem(
                          icon: Icons.phone,
                          title: 'Téléphone',
                          subtitle: AppAttributes.appAuthorPhone,
                          onTap: () {
                            // TODO: Implémenter l'appel téléphonique
                          },
                        ),

                        const SizedBox(height: 16),

                        _buildContactItem(
                          icon: Icons.email,
                          title: 'Email',
                          subtitle: AppAttributes.appAuthorEmail,
                          onTap: () {
                            // TODO: Implémenter l'envoi d'email
                          },
                        ),

                        const SizedBox(height: 16),

                        _buildContactItem(
                          icon: Icons.access_time,
                          title: 'Horaires de support',
                          subtitle: 'Lun - Ven: 8h - 18h\nSam: 9h - 15h',
                          onTap: null,
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Construit un élément de contact
  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: onTap != null
              ? AppColors.primaryColor.withOpacity(0.05)
              : Theme.of(context).colorScheme.inverseSurface.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: onTap != null
                ? AppColors.primaryColor.withOpacity(0.2)
                : Theme.of(context).colorScheme.inverseSurface.withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: AppColors.primaryColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: title,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    // color: Colors.black87,
                  ),
                  const SizedBox(height: 4),
                  AppText(
                    text: subtitle,
                    fontSize: 12,
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.arrow_forward_ios,
                color: AppColors.primaryColor,
                size: 16,
              ),
          ],
        ),
      ),
    );
  }

  /// Affiche le dialogue À propos
  void _showAboutDialog() {
    AppUtils.showDialog(
        context: context,
        title: 'À propos de ${AppAttributes.appName}',
        titleColor: AppColors.primaryColor,
        content:
            'Version : ${AppAttributes.appVersion}\n\nDéveloppé par: ${AppAttributes.appAuthor}\n\n${AppAttributes.appDescription}',
        cancelText: 'Fermer',
        onConfirm: () {});
  }

  /// Partage l'application
  void _shareApp() {
    // TODO: Implémenter le partage d'application
    AppUtils.showInfoNotification(
        context, 'Fonctionnalité de partage en cours de développement');
  }

  /// Affiche le dialogue de déconnexion
  void _showLogoutDialog() {
    AppUtils.showDialog(
      context: context,
      title: 'Déconnexion',
      content: 'Êtes-vous sûr de vouloir vous déconnecter ?',
      confirmText: 'Déconnexion',
      cancelText: 'Annuler',
    ).then((confirmed) {
      if (confirmed == true) {
        _handleSignOut();
      }
    });
  }

  /// Gère la déconnexion de l'utilisateur
  Future<void> _handleSignOut() async {
    try {
      // Afficher un indicateur de chargement
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Déconnexion
      await AuthServices.signOut();

      // Fermer l'indicateur de chargement
      if (mounted) Navigator.pop(context);

      // Rediriger vers la page de connexion
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.LOGINPAGE,
          (Route<dynamic> route) => false,
        );
      }

      AppUtils.showSuccessNotification(context, 'Déconnexion réussie');
    } catch (e) {
      // Fermer l'indicateur de chargement
      if (mounted) Navigator.pop(context);

      AppUtils.showErrorNotification(
          context, 'Erreur lors de la déconnexion: $e', null);
    }
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    super.dispose();
  }
}
