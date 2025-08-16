import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Modèles temporaires pour les placeholders
class UserProfile {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String imageUrl;
  final String dateOfBirth;
  final String gender;
  final String address;
  final String city;
  final String postalCode;
  final bool pushNotifications;
  final bool newsletter;
  final bool locationSharing;

  UserProfile({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.imageUrl,
    required this.dateOfBirth,
    required this.gender,
    required this.address,
    required this.city,
    required this.postalCode,
    required this.pushNotifications,
    required this.newsletter,
    required this.locationSharing,
  });

  UserProfile copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phone,
    String? imageUrl,
    String? dateOfBirth,
    String? gender,
    String? address,
    String? city,
    String? postalCode,
    bool? pushNotifications,
    bool? newsletter,
    bool? locationSharing,
  }) {
    return UserProfile(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      imageUrl: imageUrl ?? this.imageUrl,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      city: city ?? this.city,
      postalCode: postalCode ?? this.postalCode,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      newsletter: newsletter ?? this.newsletter,
      locationSharing: locationSharing ?? this.locationSharing,
    );
  }
}

// Événements
abstract class ProfileClientEvent extends Equatable {
  const ProfileClientEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileClientEvent {}

class SaveProfile extends ProfileClientEvent {}

class UpdatePreference extends ProfileClientEvent {
  final String key;
  final dynamic value;

  const UpdatePreference({required this.key, required this.value});

  @override
  List<Object?> get props => [key, value];
}

class DeleteAccount extends ProfileClientEvent {}

class ChangePassword extends ProfileClientEvent {
  final String currentPassword;
  final String newPassword;

  const ChangePassword({
    required this.currentPassword,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [currentPassword, newPassword];
}

// États
abstract class ProfileClientState extends Equatable {
  const ProfileClientState();

  @override
  List<Object?> get props => [];
}

class ProfileClientInitial extends ProfileClientState {}

class ProfileClientLoading extends ProfileClientState {}

class ProfileClientLoaded extends ProfileClientState {
  final UserProfile profile;

  const ProfileClientLoaded({required this.profile});

  @override
  List<Object?> get props => [profile];

  ProfileClientLoaded copyWith({
    UserProfile? profile,
  }) {
    return ProfileClientLoaded(
      profile: profile ?? this.profile,
    );
  }
}

class ProfileClientError extends ProfileClientState {
  final String message;

  const ProfileClientError({required this.message});

  @override
  List<Object?> get props => [message];
}

class ProfileClientSaving extends ProfileClientState {}

class ProfileClientSaved extends ProfileClientState {
  final String message;

  const ProfileClientSaved({required this.message});

  @override
  List<Object?> get props => [message];
}

// BLoC
class ProfileClientBloc extends Bloc<ProfileClientEvent, ProfileClientState> {
  ProfileClientBloc() : super(ProfileClientInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<SaveProfile>(_onSaveProfile);
    on<UpdatePreference>(_onUpdatePreference);
    on<DeleteAccount>(_onDeleteAccount);
    on<ChangePassword>(_onChangePassword);
  }

  UserProfile? _currentProfile;

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileClientState> emit,
  ) async {
    emit(ProfileClientLoading());
    
    try {
      // Simulation d'un délai de chargement
      await Future.delayed(const Duration(seconds: 1));
      
      // Données temporaires du profil
      _currentProfile = UserProfile(
        id: 'user123',
        fullName: 'Jean Dupont',
        email: 'jean.dupont@email.com',
        phone: '+229 90 00 00 00',
        imageUrl: 'https://via.placeholder.com/150',
        dateOfBirth: '15/03/1990',
        gender: 'Homme',
        address: '123 Rue de la Paix',
        city: 'Cotonou',
        postalCode: '01 BP 1234',
        pushNotifications: true,
        newsletter: false,
        locationSharing: true,
      );
      
      emit(ProfileClientLoaded(profile: _currentProfile!));
    } catch (e) {
      emit(ProfileClientError(message: 'Erreur lors du chargement du profil'));
    }
  }

  Future<void> _onSaveProfile(
    SaveProfile event,
    Emitter<ProfileClientState> emit,
  ) async {
    if (state is ProfileClientLoaded) {
      emit(ProfileClientSaving());
      
      try {
        // Simulation d'un délai de sauvegarde
        await Future.delayed(const Duration(seconds: 1));
        
        // TODO: Implémenter la sauvegarde avec le backend
        
        emit(ProfileClientSaved(message: 'Profil mis à jour avec succès'));
        
        // Recharger le profil
        await Future.delayed(const Duration(seconds: 1));
        emit(ProfileClientLoaded(profile: _currentProfile!));
      } catch (e) {
        emit(ProfileClientError(message: 'Erreur lors de la sauvegarde'));
      }
    }
  }

  Future<void> _onUpdatePreference(
    UpdatePreference event,
    Emitter<ProfileClientState> emit,
  ) async {
    if (state is ProfileClientLoaded && _currentProfile != null) {
      final currentState = state as ProfileClientLoaded;
      
      UserProfile updatedProfile;
      
      switch (event.key) {
        case 'pushNotifications':
          updatedProfile = _currentProfile!.copyWith(
            pushNotifications: event.value as bool,
          );
          break;
        case 'newsletter':
          updatedProfile = _currentProfile!.copyWith(
            newsletter: event.value as bool,
          );
          break;
        case 'locationSharing':
          updatedProfile = _currentProfile!.copyWith(
            locationSharing: event.value as bool,
          );
          break;
        default:
          return;
      }
      
      _currentProfile = updatedProfile;
      emit(currentState.copyWith(profile: updatedProfile));
    }
  }

  Future<void> _onDeleteAccount(
    DeleteAccount event,
    Emitter<ProfileClientState> emit,
  ) async {
    emit(ProfileClientLoading());
    
    try {
      // Simulation d'un délai de suppression
      await Future.delayed(const Duration(seconds: 2));
      
      // TODO: Implémenter la suppression de compte avec le backend
      
      emit(ProfileClientSaved(message: 'Compte supprimé avec succès'));
    } catch (e) {
      emit(ProfileClientError(message: 'Erreur lors de la suppression du compte'));
    }
  }

  Future<void> _onChangePassword(
    ChangePassword event,
    Emitter<ProfileClientState> emit,
  ) async {
    emit(ProfileClientLoading());
    
    try {
      // Simulation d'un délai de changement de mot de passe
      await Future.delayed(const Duration(seconds: 1));
      
      // TODO: Implémenter le changement de mot de passe avec le backend
      
      emit(ProfileClientSaved(message: 'Mot de passe modifié avec succès'));
    } catch (e) {
      emit(ProfileClientError(message: 'Erreur lors du changement de mot de passe'));
    }
  }
}
