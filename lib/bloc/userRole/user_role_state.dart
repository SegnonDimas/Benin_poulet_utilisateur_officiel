part of 'user_role_bloc.dart';

abstract class UserRoleState {
  final String? role;

  UserRoleState([this.role = UserRoles.VISITOR]);
}

class UserRoleInitial extends UserRoleState {}

class UserRoleLoaded extends UserRoleState {
  UserRoleLoaded(super.role);
}

class UserRoleError extends UserRoleState {
  final String message;
  UserRoleError(this.message);
}
