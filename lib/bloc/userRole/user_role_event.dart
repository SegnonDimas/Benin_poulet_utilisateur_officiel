part of 'user_role_bloc.dart';

abstract class UserRoleEvent {}

class LoadUserRole extends UserRoleEvent {
  final String userId;
  LoadUserRole(this.userId);
}

class UpdateUserRole extends UserRoleEvent {
  final String newRole; // ou List<String> roles;
  UpdateUserRole(this.newRole);
}
