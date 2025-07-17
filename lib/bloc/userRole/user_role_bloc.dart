import 'package:benin_poulet/constants/userRoles.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/firebase/firestore/user_repository.dart';

part 'user_role_event.dart';
part 'user_role_state.dart';

class UserRoleBloc extends Bloc<UserRoleEvent, UserRoleState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserRoleBloc() : super(UserRoleInitial()) {
    on<LoadUserRole>((event, emit) async {
      try {
        final auth = FirebaseAuth.instance;
        final fs = FirestoreService();
        final u = await auth.signInAnonymously();
        if (auth.currentUser == null) {
          u;
        }
        final doc =
            await _firestore.collection('users').doc(event.userId).get();
        /*if (doc.exists) {
          final user = User.fromMap(doc.data()!);
          emit(UserRoleLoaded(user));
        } else {
          emit(UserRoleError('Utilisateur introuvable.'));
        }*/
      } catch (e) {
        emit(UserRoleError(e.toString()));
      }
    });

    on<UpdateUserRole>((event, emit) {
      try {
        emit(UserRoleLoaded(event.newRole));
      } catch (e) {}
    });

    /*on<UpdateUserRole>((event, emit) async {
      try {
        */ /*final userId = (state as UserRoleLoaded).user.userId!;
        await _firestore.collection('users').doc(userId).update({
          'role': event.newRole,
        });
        add(LoadUserRole(userId)); // rechargement*/ /*
      } catch (e) {
        emit(UserRoleError(e.toString()));
      }
    });*/
  }
}
