import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user.dart';

part 'user_profile_event.dart';
part 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserProfileBloc() : super(UserProfileInitial()) {
    on<LoadUserProfile>((event, emit) async {
      try {
        final doc =
            await _firestore.collection('users').doc(event.userId).get();
        if (doc.exists) {
          final user = User.fromMap(doc.data()!);
          emit(UserProfileLoaded(user));
        } else {
          emit(UserProfileError('Utilisateur introuvable.'));
        }
      } catch (e) {
        emit(UserProfileError(e.toString()));
      }
    });

    on<UpdateUserRole>((event, emit) async {
      try {
        final userId = (state as UserProfileLoaded).user.userId;
        await _firestore.collection('users').doc(userId).update({
          'role': event.newRole,
        });
        add(LoadUserProfile(userId)); // rechargement
      } catch (e) {
        emit(UserProfileError(e.toString()));
      }
    });
  }
}
