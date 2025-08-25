import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/client/profile_client_bloc.dart';
import '../../../services/user_data_service.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_text.dart';
import '../../../widgets/app_textField.dart';
import '../../colors/app_colors.dart';
import '../../../constants/routes.dart';

class ProfileClientPage extends StatefulWidget {
  const ProfileClientPage({super.key});

  @override
  State<ProfileClientPage> createState() => _ProfileClientPageState();
}

class _ProfileClientPageState extends State<ProfileClientPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isEditing = false;
  final UserDataService _userDataService = UserDataService();
  
  // Statistiques du client
  int _ordersCount = 0;
  int _favoritesCount = 0;
  int _reviewsCount = 0;

  @override
  void initState() {
    super.initState();
    context.read<ProfileClientBloc>().add(LoadProfile());
    _loadStatistics();
  }
  
  Future<void> _loadStatistics() async {
    try {
      final ordersCount = await _userDataService.getCurrentClientOrdersCount();
      final favoritesCount = await _userDataService.getCurrentClientFavoritesCount();
      final reviewsCount = await _userDataService.getCurrentClientReviewsCount();
      
      if (mounted) {
        setState(() {
          _ordersCount = ordersCount;
          _favoritesCount = favoritesCount;
          _reviewsCount = reviewsCount;
        });
      }
    } catch (e) {
      print('Erreur lors du chargement des statistiques: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText(text: 'Mon Profil'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              if (_isEditing) {
                _saveProfile();
              } else {
                setState(() {
                  _isEditing = true;
                });
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<ProfileClientBloc, ProfileClientState>(
        builder: (context, state) {
          if (state is ProfileClientLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProfileClientLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Photo de profil
                    _buildProfilePicture(state),

                    const SizedBox(height: 24),

                    // Informations personnelles
                    _buildPersonalInfo(state),

                    const SizedBox(height: 24),

                    // Informations de contact
                    _buildContactInfo(state),

                    const SizedBox(height: 24),

                    // Adresse
                    _buildAddressInfo(state),

                    const SizedBox(height: 24),

                    // Préférences
                    _buildPreferences(state),

                    const SizedBox(height: 24),

                    // Actions
                    _buildActions(),
                  ],
                ),
              ),
            );
          }

          if (state is ProfileClientError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  AppText(
                    text: state.message,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(height: 16),
                  AppButton(
                    child: AppText(
                      text: 'Réessayer',
                      color: Colors.white,
                    ),
                    onTap: () {
                      context.read<ProfileClientBloc>().add(LoadProfile());
                    },
                    color: AppColors.primaryColor,
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: AppText(text: 'Chargement...'),
          );
        },
      ),
    );
  }

  Widget _buildProfilePicture(ProfileClientLoaded state) {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage: NetworkImage(state.profile.imageUrl),
            onBackgroundImageError: (exception, stackTrace) {
              // Gérer l'erreur de chargement d'image
            },
          ),
          if (_isEditing)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfo(ProfileClientLoaded state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              text: 'Informations personnelles',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Nom complet',
              initialValue: state.profile.fullName,
              enabled: _isEditing,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Le nom complet est requis';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            AppTextField(
              label: 'Date de naissance',
              initialValue: state.profile.dateOfBirth,
              enabled: _isEditing,
              suffixIcon: Icon(Icons.calendar_today),
            ),
            const SizedBox(height: 12),
            AppTextField(
              label: 'Genre',
              initialValue: state.profile.gender,
              enabled: _isEditing,
              suffixIcon: Icon(Icons.arrow_drop_down),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfo(ProfileClientLoaded state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              text: 'Informations de contact',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Email',
              initialValue: state.profile.email,
              enabled: _isEditing,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'L\'email est requis';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                    .hasMatch(value)) {
                  return 'Veuillez entrer un email valide';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            AppTextField(
              label: 'Téléphone',
              initialValue: state.profile.phone,
              enabled: _isEditing,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Le téléphone est requis';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressInfo(ProfileClientLoaded state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              text: 'Adresse',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Adresse',
              initialValue: state.profile.address,
              enabled: _isEditing,
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    label: 'Ville',
                    initialValue: state.profile.city,
                    enabled: _isEditing,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppTextField(
                    label: 'Code postal',
                    initialValue: state.profile.postalCode,
                    enabled: _isEditing,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferences(ProfileClientLoaded state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              text: 'Préférences',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const AppText(text: 'Notifications push'),
              subtitle: const AppText(
                text: 'Recevoir des notifications sur votre téléphone',
                fontSize: 12,
                color: Colors.grey,
              ),
              value: state.profile.pushNotifications,
              onChanged: _isEditing
                  ? (value) {
                      context.read<ProfileClientBloc>().add(
                            UpdatePreference(
                              key: 'pushNotifications',
                              value: value,
                            ),
                          );
                    }
                  : null,
              activeColor: AppColors.primaryColor,
            ),
            SwitchListTile(
              title: const AppText(text: 'Newsletter'),
              subtitle: const AppText(
                text: 'Recevoir des offres et actualités par email',
                fontSize: 12,
                color: Colors.grey,
              ),
              value: state.profile.newsletter,
              onChanged: _isEditing
                  ? (value) {
                      context.read<ProfileClientBloc>().add(
                            UpdatePreference(
                              key: 'newsletter',
                              value: value,
                            ),
                          );
                    }
                  : null,
              activeColor: AppColors.primaryColor,
            ),
            SwitchListTile(
              title: const AppText(text: 'Localisation'),
              subtitle: const AppText(
                text:
                    'Partager votre localisation pour une meilleure expérience',
                fontSize: 12,
                color: Colors.grey,
              ),
              value: state.profile.locationSharing,
              onChanged: _isEditing
                  ? (value) {
                      context.read<ProfileClientBloc>().add(
                            UpdatePreference(
                              key: 'locationSharing',
                              value: value,
                            ),
                          );
                    }
                  : null,
              activeColor: AppColors.primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActions() {
    return Column(
      children: [
        // Bouton changer mot de passe
        SizedBox(
          width: double.infinity,
          child: AppButton(
            child: AppText(
              text: 'Changer le mot de passe',
              color: Colors.black87,
            ),
            onTap: () {
                              Navigator.pushNamed(context, AppRoutes.CHANGEPASSWORD);
            },
            color: Colors.grey.shade200,
          ),
        ),

        const SizedBox(height: 12),

        // Bouton supprimer compte
        SizedBox(
          width: double.infinity,
          child: AppButton(
            child: AppText(
              text: 'Supprimer mon compte',
              color: Colors.white,
            ),
            onTap: () {
              _showDeleteAccountDialog();
            },
            color: AppColors.redColor,
          ),
        ),

        const SizedBox(height: 24),

        // Statistiques
        _buildStatistics(),
      ],
    );
  }

  Widget _buildStatistics() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              text: 'Statistiques',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.shopping_bag,
                    label: 'Commandes',
                    value: _ordersCount.toString(),
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.favorite,
                    label: 'Favoris',
                    value: _favoritesCount.toString(),
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.star,
                    label: 'Avis',
                    value: _reviewsCount.toString(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppColors.primaryColor,
          size: 32,
        ),
        const SizedBox(height: 8),
        AppText(
          text: value,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        AppText(
          text: label,
          fontSize: 12,
          color: Colors.grey.shade600,
        ),
      ],
    );
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      context.read<ProfileClientBloc>().add(SaveProfile());
      setState(() {
        _isEditing = false;
      });
    }
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const AppText(text: 'Supprimer le compte'),
        content: const AppText(
          text:
              'Êtes-vous sûr de vouloir supprimer votre compte ? Cette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: AppText(text: 'Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<ProfileClientBloc>().add(DeleteAccount());
            },
            child: AppText(
              text: 'Supprimer',
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
