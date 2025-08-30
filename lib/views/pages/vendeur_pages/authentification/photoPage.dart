import 'package:benin_poulet/bloc/authentification/authentification_bloc.dart';
import 'package:benin_poulet/views/sizes/app_sizes.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'dart:io';

import '../../../models_ui/model_photoSelecteur.dart';

class PhotoPage extends StatefulWidget {
  @override
  PhotoPageState createState() {
    return PhotoPageState();
  }
}

class PhotoPageState extends State<PhotoPage> {
  String _sellerType = 'Particulier';
  String _mobileMoney = '';
  bool isMtn = false;
  bool isMoov = false;
  bool isCeltiis = false;

  final List<String> _titrePiece = [
    'Le recto de votre pièce',
    'Le verso de votre pièce',
    'Selfie'
  ];

  final List<String> _descriptionPiece = [
    'charger la photo',
    'charger la photo',
    'prendre une photo'
  ];

  final List<String> _trailing = ['prendre une photo', 'prendre une photo', ''];

  // Variables pour stocker les chemins des photos
  String _photoRecto = '';
  String _photoVerso = '';
  String _photoSelfie = '';

  String initialCountry = 'BJ';
  PhoneNumber number = PhoneNumber(isoCode: 'BJ');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            // sélection pays
            // texte
            AppText(
              text: 'Prendre en photo votre pièce',
              fontSize: smallText() * 1.1,
            ),
            const SizedBox(
              height: 10,
            ),

            // liste des pièces
            SizedBox(
              child: Column(
                children: List.generate(_titrePiece.length - 1, (index) {
                  return Padding(
                    padding:
                        EdgeInsets.only(bottom: appHeightSize(context) * 0.02),
                    child: GestureDetector(
                      onTap: () {
                        _takePhoto(index);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: (index == 0 && _photoRecto.isNotEmpty) || 
                                   (index == 1 && _photoVerso.isNotEmpty)
                                ? Colors.green
                                : Colors.grey.withOpacity(0.3),
                            width: (index == 0 && _photoRecto.isNotEmpty) || 
                                   (index == 1 && _photoVerso.isNotEmpty) ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ModelPhotoSelecteur(
                          title: _titrePiece[index],
                          description: (index == 0 && _photoRecto.isNotEmpty) || 
                                       (index == 1 && _photoVerso.isNotEmpty)
                              ? 'Photo prise ✓'
                              : _descriptionPiece[index],
                          trailing: _trailing[index],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            // espace
            const SizedBox(
              height: 20,
            ),

            // texte
            AppText(
              text: 'Prendre une photo de vous avec votre pièce',
              fontSize: smallText() * 1.1,
            ),
            // espace
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              child: Column(
                children: List.generate(1, (index) {
                  return Padding(
                    padding:
                        EdgeInsets.only(bottom: appHeightSize(context) * 0.02),
                    child: GestureDetector(
                      onTap: () {
                        _takePhoto(2); // Index 2 pour le selfie
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _photoSelfie.isNotEmpty
                                ? Colors.green
                                : Colors.grey.withOpacity(0.3),
                            width: _photoSelfie.isNotEmpty ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ModelPhotoSelecteur(
                          title: _titrePiece[2],
                          description: _photoSelfie.isNotEmpty
                              ? 'Photo prise ✓'
                              : _descriptionPiece[2],
                          trailing: _trailing[2],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            // Espace pour compenser l'espace occupé par le bouton "Suivant" dans la page CreationBoutiquePage
            SizedBox(
              height: context.height * 0.07,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _takePhoto(int photoIndex) async {
    final ImagePicker picker = ImagePicker();
    
    // Afficher un dialogue pour choisir la source
    final String? source = await _showImageSourceDialog();
    if (source == null) return;
    
    try {
      XFile? image;
      
      if (source == 'camera') {
        image = await picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 80,
        );
      } else if (source == 'gallery') {
        image = await picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 80,
        );
      }
      
      if (image != null) {
        setState(() {
          switch (photoIndex) {
            case 0:
              _photoRecto = image!.path;
              break;
            case 1:
              _photoVerso = image!.path;
              break;
            case 2:
              _photoSelfie = image!.path;
              break;
          }
        });
        
        _updateAuthentificationState();
      }
    } catch (e) {
      print('Erreur lors de la prise de photo: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la prise de photo: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<String?> _showImageSourceDialog() async {
    return await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choisir la source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Appareil photo'),
                onTap: () => Navigator.of(context).pop('camera'),
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Galerie'),
                onTap: () => Navigator.of(context).pop('gallery'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _updateAuthentificationState() {
    // Récupérer l'état actuel du BLoC
    final currentState = context.read<AuthentificationBloc>().state;
    if (currentState is AuthentificationGlobalState) {
      // Créer un nouvel événement avec les données mises à jour
              final event = SubmitPhotoDocuments(
          idDocumentPhoto: {
            'recto': _photoRecto,
            'verso': _photoVerso,
            'selfie': _photoSelfie,
          },
        );
      context.read<AuthentificationBloc>().add(event);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
