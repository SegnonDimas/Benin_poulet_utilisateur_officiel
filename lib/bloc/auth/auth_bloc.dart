import 'package:bloc/bloc.dart';

import 'auth_events.dart';
import 'auth_states.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GoogleAuthRepository? googleAuthRepository;
  final EmailAuthRepository? emailAuthRepository;
  final AppleAuthRepository? appleAuthRepository;
  final PhoneAuthRepository? phoneAuthRepository;

  AuthBloc({
    this.googleAuthRepository,
    this.emailAuthRepository,
    this.appleAuthRepository,
    this.phoneAuthRepository,
  }) : super(AuthInitial()) {
    on<GoogleLoginRequested>(_onGoogleLoginRequested);
    on<EmailLoginRequested>(_onEmailLoginRequested);
    on<PhoneSignUpRequested>(_onPhoneSignUpRequested);
  }

  Future<void> _onGoogleLoginRequested(
    GoogleLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final userId = await googleAuthRepository?.signInWithGoogle();
      emit(AuthAuthenticated(userId));
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
      final userId = await emailAuthRepository?.signInWithEmail(
        event.email,
        event.password,
      );
      emit(AuthAuthenticated(userId));
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
      final userId = await phoneAuthRepository?.signUpWithPhone(
        event.firstName,
        event.lastName,
        event.phoneNumber,
        event.password,
      );
      emit(AuthSignedUp(userId));
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
