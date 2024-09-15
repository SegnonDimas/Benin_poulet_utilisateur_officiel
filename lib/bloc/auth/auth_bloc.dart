import 'package:bloc/bloc.dart';

part 'auth_events.dart';
part 'auth_states.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<PhoneLoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final phoneNumber = event.phoneNumber;
        final password = event.password;
        if (phoneNumber.isEmpty) {
          return emit(PhoneLoginRequestFailure(
              erroMessage: 'Veuillez renseigner votre numéro de téléphone'));
        }
        if (password.isEmpty) {
          return emit(PhoneLoginRequestFailure(
              erroMessage: 'Veuillez renseigner votre mot de passe'));
        } else if (password.length < 4) {
          return emit(PhoneLoginRequestFailure(
              erroMessage:
                  'Le mot de passe doit être d\'au moins 4 caractères'));
        }

        await Future.delayed(const Duration(seconds: 2), () {
          return emit(PhoneLoginRequestSuccess(
              uid: '$phoneNumber$password',
              successMessage: 'Utilisateur connecté avec succès'));
        });
      } catch (e) {
        return emit(PhoneLoginRequestFailure(erroMessage: e.toString()));
      }
    });

    on<EmailLoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final email = event.email;
        final password = event.password;
        if (email.isEmpty) {
          return emit(EmailLoginRequestFailure(
              erroMessage: 'Veuillez renseigner votre adresse email'));
        }
        if (password.isEmpty) {
          return emit(EmailLoginRequestFailure(
              erroMessage: 'Veuillez renseigner votre mot de passe'));
        } else if (password.length < 4) {
          return emit(EmailLoginRequestFailure(
              erroMessage:
                  'Le mot de passe doit être d\'au moins 4 caractères'));
        }

        await Future.delayed(const Duration(seconds: 2), () {
          return emit(EmailLoginRequestSuccess(
              uid: email, successMessage: 'Utilisateur connecté avec succès'));
        });
      } catch (e) {
        return emit(EmailLoginRequestFailure(erroMessage: e.toString()));
      }
    });

    on<GoogleLoginRequested>(_onGoogleLoginRequested);

    on<PhoneSignUpRequested>(_onPhoneSignUpRequested);
  }

  Future<void> _onGoogleLoginRequested(
    GoogleLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      //final userId = await googleAuthRepository?.signInWithGoogle();
      //emit(AuthAuthenticated(userId));
    } catch (error) {
      emit(AuthError(error.toString()));
    }
  }

  Future<void> _onEmailLoginRequested(
    EmailLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      //final userId = await emailAuthRepository?.signInWithEmail(
      //  event.email,
      //  event.password,
      //);
      // emit(AuthAuthenticated(userId));
    } catch (error) {
      emit(AuthError(error.toString()));
    }
  }

  Future<void> _onPhoneSignUpRequested(
    PhoneSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      /*final userId = await phoneAuthRepository?.signUpWithPhone(
        event.firstName,
        event.lastName,
        event.phoneNumber,
        event.password,
      );
      emit(AuthSignedUp(userId));*/
    } catch (error) {
      emit(AuthError(error.toString()));
    }
  }
}

class PhoneAuthRepository {
  signUpWithPhone(
      String firstName, String lastName, String phoneNumber, String password) {}
}

class AppleAuthRepository {}

class EmailAuthRepository {
  signInWithEmail(String email, String password) {}
}

class GoogleAuthRepository {
  signInWithGoogle() {}
}
