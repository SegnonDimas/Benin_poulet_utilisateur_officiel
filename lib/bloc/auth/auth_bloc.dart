//import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../constants/userRoles.dart';

part 'auth_events.dart';
part 'auth_states.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    //==========
    //CONNEXION
    //==========
    on<PhoneLoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final countryCode =
            event.phoneNumber.dialCode ?? '+229'; // Bénin par défaut
        final fullPhoneNumber = event.phoneNumber.phoneNumber?.trim() ?? '';
        final phone = event.phoneNumber;
        final password = event.password;

        // Extraire la partie sans l'indicatif (ex: 0123456789)
        final nationalNumber =
            fullPhoneNumber.replaceFirst(countryCode, '').trim();

        // Vérification : champ vide
        if (fullPhoneNumber.isEmpty) {
          return emit(PhoneLoginRequestFailure(
            errorMessage: 'Veuillez renseigner votre numéro de téléphone',
          ));
        }

        // Vérification spécifique au Bénin
        if (countryCode == '+229') {
          if (nationalNumber.length != 10 || !nationalNumber.startsWith('01')) {
            return emit(PhoneLoginRequestFailure(
              errorMessage:
                  'Le numéro de téléphone doit comporter 10 chiffres pour le Bénin et commencer par 01',
            ));
          }
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
                userId: '${phone.phoneNumber}$password',
                successMessage: 'Utilisateur connecté avec succès'));
          });
        }
      } catch (e) {
        print("::::::::::ERREURE : $e ::::::::::::");
        if (e.toString() == "Null check operator used on a null value") {
          return emit(PhoneLoginRequestFailure(
              errorMessage: "Veuillez renseigner votre numéro de téléphone"));
        }
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
        } else {
          await Future.delayed(const Duration(seconds: 2), () {
            return emit(EmailLoginRequestSuccess(
                userId: email,
                successMessage: 'Utilisateur connecté avec succès'));
          });
        }
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

    //============
    //INSCRIPTION
    //============
    on<PhoneSignUpRequested>((event, emit) {
      emit(AuthLoading());

      try {
        final lastName = event.lastName;
        final firstName = event.firstName;
        final countryCode =
            event.phoneNumber.dialCode ?? '+229'; // Bénin par défaut
        final fullPhoneNumber = event.phoneNumber.phoneNumber?.trim() ?? '';
        final phone = event.phoneNumber;
        final password = event.password;
        final confirmPassword = event.confirmPassword;

        // Extraire la partie sans l'indicatif (ex: 0123456789)
        final nationalNumber =
            fullPhoneNumber.replaceFirst(countryCode, '').trim();

        if (firstName.isEmpty ||
            lastName.isEmpty ||
            fullPhoneNumber.isEmpty ||
            password.isEmpty ||
            confirmPassword.isEmpty) {
          return emit(PhoneSignUpRequestFailure(
              errorMessage: "Veuillez renseigner tous les champs"));
        } else if (password != confirmPassword) {
          return emit(PhoneSignUpRequestFailure(
              errorMessage: "Les mots de passe ne correspondent pas"));
        }
        // Vérification : champ vide
        else if (fullPhoneNumber.isEmpty) {
          return emit(PhoneSignUpRequestFailure(
            errorMessage: 'Veuillez renseigner votre numéro de téléphone',
          ));
        }

        // Vérification spécifique au Bénin
        if (countryCode == '+229') {
          if (nationalNumber.length != 10 || !nationalNumber.startsWith('01')) {
            return emit(PhoneLoginRequestFailure(
              errorMessage:
                  'Le numéro de téléphone doit comporter 10 chiffres pour le Bénin et commencer par 01',
            ));
          }
        }

        if (password.isEmpty) {
          return emit(PhoneLoginRequestFailure(
              errorMessage: 'Veuillez renseigner votre mot de passe'));
        } else if (password.length < 4) {
          return emit(PhoneLoginRequestFailure(
              errorMessage:
                  'Le mot de passe doit être d\'au moins 4 caractères'));
        }
      } catch (e) {}
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
