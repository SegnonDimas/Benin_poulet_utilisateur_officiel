part of 'user_profile_bloc.dart';

abstract class UserProfileEvent {}

class LoadUserProfile extends UserProfileEvent {
  final String userId;
  LoadUserProfile(this.userId);
}

class UpdateUserRole extends UserProfileEvent {
  final String newRole; // ou List<String> roles;
  UpdateUserRole(this.newRole);
}
