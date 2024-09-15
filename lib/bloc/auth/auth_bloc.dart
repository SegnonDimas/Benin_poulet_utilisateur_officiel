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
              errorMessage: 'Veuillez renseigner votre numéro de téléphone'));
        }
        if (password.isEmpty) {
          return emit(PhoneLoginRequestFailure(
              errorMessage: 'Veuillez renseigner votre mot de passe'));
        } else if (password.length < 4) {
          return emit(PhoneLoginRequestFailure(
              errorMessage:
                  'Le mot de passe doit être d\'au moins 4 caractères'));
        } else {
          await Future.delayed(const Duration(seconds: 2), () {
            return emit(PhoneLoginRequestSuccess(
                userId: '$phoneNumber$password',
                successMessage: 'Utilisateur connecté avec succès'));
          });
        }
      } catch (e) {
        return emit(PhoneLoginRequestFailure(errorMessage: e.toString()));
      }
    });

    on<EmailLoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final email = event.email;
        final password = event.password;
        if (email.isEmpty) {
          return emit(EmailLoginRequestFailure(
              errorMessage: 'Veuillez renseigner votre adresse email'));
        }
        if (password.isEmpty) {
          return emit(EmailLoginRequestFailure(
              errorMessage: 'Veuillez renseigner votre mot de passe'));
        } else if (password.length < 4) {
          return emit(EmailLoginRequestFailure(
              errorMessage:
                  'Le mot de passe doit être d\'au moins 4 caractères'));
        }

        await Future.delayed(const Duration(seconds: 2), () {
          return emit(EmailLoginRequestSuccess(
              userId: email,
              successMessage: 'Utilisateur connecté avec succès'));
        });
      } catch (e) {
        return emit(EmailLoginRequestFailure(errorMessage: e.toString()));
      }
    });

    on<GoogleLoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await Future.delayed(const Duration(seconds: 2), () {
          return emit(GoogleLoginRequestSuccess(userId: 'googleUser'));
        });
      } catch (e) {
        return emit(GoogleLoginRequestFailure(errorMessage: e.toString()));
      }
    });

    on<ICloudLoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await Future.delayed(const Duration(seconds: 2), () {
          return emit(ICloudLoginRequestSuccess(userId: 'icloudUser'));
        });
      } catch (e) {
        return emit(ICloudLoginRequestFailure(errorMessage: e.toString()));
      }
    });
  }

  Future<void> _onGoogleLoginRequested(
    GoogleLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      //final userId = await googleAuthRepository?.signInWithGoogle();
      //emit(AuthAuthenticated(userId));
    } catch (e) {
      emit(AuthFailure(errorMessage: e.toString()));
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
      emit(AuthFailure(errorMessage: error.toString()));
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
      emit(AuthFailure(errorMessage: error.toString()));
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
