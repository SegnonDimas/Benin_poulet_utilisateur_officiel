//import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
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

    // connexion avec téléphone
    on<PhoneLoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final countryCode =
            event.phoneNumber.dialCode ?? '+229'; // Bénin par défaut
        final fullPhoneNumber = event.phoneNumber.phoneNumber?.trim() ?? '';
        final phone = event.phoneNumber;
        final password = event.password;
        final longeurMotDePasse = 6;

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

        // Vérification : mot de passe
        if (password.isEmpty) {
          return emit(PhoneLoginRequestFailure(
              errorMessage: 'Veuillez renseigner votre mot de passe'));
        } else if (password.length < longeurMotDePasse) {
          return emit(PhoneLoginRequestFailure(
              errorMessage:
                  'Le mot de passe doit être d\'au moins $longeurMotDePasse caractères'));
        } else {
          await Future.delayed(const Duration(seconds: 2), () {
            emit(AuthAuthenticated());

            return emit(PhoneLoginRequestSuccess(
                //userId: '${phone.phoneNumber}$password',
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

    // connexion avec addresse email
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
          emit(AuthAuthenticated(
              successMessage: 'Utilisateur connecté avec succès'));
          emit(EmailLoginRequestSuccess(
              //userId: email,
              successMessage: 'Utilisateur connecté avec succès'));
        }
      } catch (e) {
        return emit(EmailLoginRequestFailure(errorMessage: e.toString()));
      }
    });

    // connexion avec google
    on<GoogleLoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        //final userId = AuthServices.userId;
        //emit(AuthAuthenticated());
        //Deprecié : TODO : à délaisser au profil de AuthAuthentificated
        emit(GoogleLoginRequestSuccess());
      } catch (e) {
        return emit(GoogleLoginRequestFailure(errorMessage: e.toString()));
      }
    });

    // connexion avec icloud
    on<ICloudLoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await Future.delayed(const Duration(seconds: 2), () {
          return emit(ICloudLoginRequestSuccess());
        });
      } catch (e) {
        return emit(ICloudLoginRequestFailure(errorMessage: e.toString()));
      }
    });

    //============
    //INSCRIPTION
    //============

    // inscription avec téléphone
    on<PhoneSignUpRequested>((event, emit) async {
      emit(AuthLoading());
      var instance = FirebaseAuth.instance;
      var userId = instance.currentUser?.uid;
      print(":::::::::::::PhoneSignUpRequested : User ID : $userId ::::::::");

      try {
        final lastName = event.lastName;
        final firstName = event.firstName;
        final countryCode =
            event.phoneNumber.dialCode ?? '+229'; // Bénin par défaut
        final fullPhoneNumber = event.phoneNumber.phoneNumber?.trim() ?? '';
        final phone = event.phoneNumber;
        final password = event.password;
        final confirmPassword = event.confirmPassword;
        final longeurMotDePasse = 6;

        // Extraire la partie sans l'indicatif (ex: 0123456789)
        final nationalNumber =
            fullPhoneNumber.replaceFirst(countryCode, '').trim();

        print(
            "DEBUG Champs : firstName=$firstName, lastName=$lastName, fullPhoneNumber=$fullPhoneNumber, password=$password, confirmPassword=$confirmPassword");

        if (firstName.isEmpty ||
            lastName.isEmpty ||
            fullPhoneNumber.isEmpty ||
            password.isEmpty ||
            confirmPassword.isEmpty) {
          emit(
              AuthFailure(errorMessage: "Veuillez renseigner tous les champs"));
        }
        // Vérification : mots de passe identiques
        if (password != confirmPassword) {
          emit(AuthFailure(
              errorMessage: "Les mots de passe ne correspondent pas"));
        }
        // Vérification : champ numéro de teléphone vide
        if (fullPhoneNumber.isEmpty) {
          emit(AuthFailure(
            errorMessage: 'Veuillez renseigner votre numéro de téléphone',
          ));
        }
        // Vérification spécifique au Bénin
        if (countryCode == '+229') {
          //vérifier que le numéro de teléphone commence par 01 et contient 10 chiffres
          if (nationalNumber.length != 10 || !nationalNumber.startsWith('01')) {
            emit(AuthFailure(
              errorMessage:
                  'Le numéro de téléphone doit comporter 10 chiffres pour le Bénin et commencer par 01',
            ));
          }
        }
        // Vérification : champ mot de passe vide
        if (password.isEmpty) {
          emit(AuthFailure(
              errorMessage: 'Veuillez renseigner votre mot de passe'));
        }
        // Vérification : longueur du mot de passe
        if (password.length < longeurMotDePasse) {
          emit(AuthFailure(
              errorMessage:
                  'Le mot de passe doit être d\'au moins $longeurMotDePasse caractères'));
        }
        //tout est ok
        {
          //var instance = FirebaseAuth.instance;
          //var userId = instance.currentUser?.uid;
          /*
          emit(PhoneSignUpRequestSuccess(userId: userId!) as AuthState);
          */
          print("::::::::::::::::JE SUIS VENU ICI::::::::::::");
          //emit(AuthAuthenticated(userId: 'userId!'));
          emit(AuthAuthenticated());
        }
      } catch (e) {
        print(":::::::::::ERREUR : $e :::::::::::::");
        emit(AuthFailure(errorMessage: e.toString()));
      }
    });

    // inscription avec google
    on<GoogleSignUpRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        emit(AuthAuthenticated());
        //return emit(GoogleLoginRequestSuccess(userId: userId!));
      } catch (e) {
        emit(AuthFailure(errorMessage: e.toString()));
        //return emit(GoogleLoginRequestFailure(errorMessage: e.toString()));
      }
    });

    // inscription avec addresse email
    on<EmailSignUpRequested>((event, emit) async {
      emit(AuthLoading());
      final email = event.email;
      final password = event.password;
      final confirmPassword = event.confirmPassword;
      final longeurMotDePasse = 6;

      // Verification : email
      if (email.isEmpty || email == "") {
        emit(AuthFailure(errorMessage: "Veuillez saisir votre adresse email"));
      }

      // Verification : mot de passe
      else if (password.isEmpty || password == "") {
        emit(AuthFailure(errorMessage: 'Veuillez saisir votre mot de passe'));
      }

      // Verification : confirmation du mot de passe
      else if (confirmPassword.isEmpty || confirmPassword == "") {
        emit(
            AuthFailure(errorMessage: 'Veuillez confirmer votre mot de passe'));
      }

      // Verification : mots de passe identiques
      else if (password != confirmPassword) {
        emit(AuthFailure(
            errorMessage: 'Les mots de passe ne correspondent pas'));
      }

      // Verification : longueur du mot de passe
      else if (password.length < longeurMotDePasse) {
        emit(AuthFailure(
            errorMessage:
                'Le mot de passe doit contenir au moins $longeurMotDePasse caractères'));
      } else {
        try {
          //final userId = AuthServices.userId;
          emit(AuthAuthenticated());
        } catch (e) {
          if (e.toString().contains('already')) {
            emit(AuthFailure(
                errorMessage: 'Cette adresse est deja associee a un compte'));
          }
          if (kDebugMode) {
            print(
                '::::::::::::::Erreur lors de la connexion : $e ::::::::::::::');
          }

          /*AppUtils.showSnackBar(
          context, "Cette adresse est deja associee a un compte");*/
        }
      }
    });
    // inscription avec icloud
  }
}
