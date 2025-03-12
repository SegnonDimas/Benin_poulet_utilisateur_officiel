import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/sizes/app_sizes.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_tooltip/super_tooltip.dart';

import '../../../../bloc/choixCategorie/choix_categorie_bloc.dart';
import '../../../../bloc/choixCategorie/choix_categorie_event.dart';
import '../../../../bloc/choixCategorie/choix_categorie_state.dart';

class ChoixCategoriePage extends StatefulWidget {
  @override
  State<ChoixCategoriePage> createState() => _ChoixCategoriePageState();
}

class _ChoixCategoriePageState extends State<ChoixCategoriePage> {
  final List<String> _secteurs = ['Volaille', 'Bétaille', 'Pisciculture'];

  final List<String> _categorieVolaille = [
    'Pigeon',
    'pintarde',
    'Poulet',
    'Dinde',
    'Canards',
    'Oies',
  ];

  final List<String> _categoriePisciculture = [
    'Tilapia',
    'Carpe',
    'Faux barre',
    'Vrai barre',
    'Poissons chat',
  ];

  final List<String> _categries = [];

  // Méthode pour ajouter les catégories volaille
  void ajouterSecteurVolaille() {
    _categries.addAll(_categorieVolaille);
  }

// Méthode pour ajouter les catégories betaille
  void ajouterSecteurPisciculture() {
    _categries.addAll(_categoriePisciculture);
  }

// Méthode pour supprimer les catégories volaille
  void supprimerSecteurVolaille() {
    _categries.removeWhere((element) => _categorieVolaille.contains(element));
  }

// Méthode pour supprimer les catégories betaille
  void supprimerCategoriesPoisson() {
    _categries
        .removeWhere((element) => _categoriePisciculture.contains(element));
  }

// Transformation des éléments de _categries en Widgets
  List<Widget> _buildCategoriesWidgets(BuildContext context) {
    return _categries
        .map((categorie) => ModelCategorie(
              text: categorie,
              activeColor: primaryColor,
              disabledColor: Theme.of(context).colorScheme.background,
              description: 'Ceci fait partie de vos activités',
            ))
        .toList();
  }

  // Transformation des éléments de _secteurs en Widgets
  List<Widget> _buildSecteursWidgets(BuildContext context) {
    return _secteurs
        .map((secteur) => ModelCategorie(
              text: secteur,
              activeColor: primaryColor,
              disabledColor: Theme.of(context).colorScheme.background,
              description:
                  'Ceci fait partie des secteurs dans lequels vous intervenez',
            ))
        .toList();
  }

  bool volaille = false, pisciculture = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(height: appHeightSize(context) * 0.025),
            AppText(
              text: 'Choisissez vos secteurs',
              fontWeight: FontWeight.normal,
              fontSize: mediumText() * 1.1,
            ),
            SizedBox(height: appHeightSize(context) * 0.025),
            /*Wrap(
              children: _buildSecteursWidgets(context),
            ),*/

            /*Wrap(
              children: [
                ModelSecteur(
                  activeColor: primaryColor,
                  onTap: () {
                    setState(() {
                      volaille = !volaille;
                      if (volaille) {
                        ajouterSecteurVolaille(); //_categries.addAll(_categorieVolaille);
                      } else {
                        supprimerSecteurVolaille(); //_categries.removeWhere((element) => _categorieVolaille.contains(element));
                      }
                    });
                  },
                  text: 'Volaille',
                  isSelected: null,
                ),
                ModelSecteur(
                  activeColor: primaryColor,
                  disabledColor: Colors.grey,
                  onTap: () {
                    setState(() {
                      pisciculture = !pisciculture;
                      if (pisciculture) {
                        ajouterSecteurPisciculture(); //_categries.addAll(_categorieVolaille);
                      } else {
                        supprimerCategoriesPoisson(); //_categries.removeWhere((element) => _categorieVolaille.contains(element));
                      }
                    });
                  },
                  text: 'Pisciculture',
                ),
                SizedBox(height: appHeightSize(context) * 0.025),
              ], //_categorie,
            ),*/
            BlocBuilder<ChoixCategorieBloc, ChoixCategorieState>(
              builder: (context, state) {
                return Wrap(
                  children: state.secteursSelectionnes.keys.map((secteur) {
                    final isSelected =
                        state.secteursSelectionnes[secteur] ?? false;
                    return ModelSecteur(
                      text: secteur,
                      isSelected: isSelected,
                      activeColor: Colors.green,
                      disabledColor: Colors.grey,
                      onTap: () {
                        context
                            .read<ChoixCategorieBloc>()
                            .add(SecteurToggled(secteur));
                      },
                    );
                  }).toList(),
                );
              },
            ),
            Divider(
              color: Theme.of(context).colorScheme.background,
            ),
            AppText(
              text: 'Sélectionnez les catégories de votre activté :',
              color: primaryColor,
              fontSize: smallText() * 1.1,
            ),
            Wrap(
              children: _buildCategoriesWidgets(context),
            )
          ]),
        ),
      ),
    );
  }
}

class ModelCategorie extends StatefulWidget {
  late Color? backgroundColor;
  late Color? activeColor;
  late Color? disabledColor;
  final String? description;
  final String? text;
  late bool? isSelected;
  final Function()? onTap;

  ModelCategorie({
    super.key,
    this.backgroundColor,
    this.activeColor = Colors.green,
    this.description,
    this.disabledColor = Colors.grey,
    this.text,
    this.isSelected = false,
    this.onTap,
  });

  @override
  State<ModelCategorie> createState() => _ModelCategorieState();
}

class _ModelCategorieState extends State<ModelCategorie> {
  bool isSelected = false;

  final _controller = SuperTooltipController();

  Future<bool> _willPopCallback() async {
    /*Si l'info-bulle est ouverte, nous n'affichons pas la page en appuyant sur le bouton Retour, mais fermons l'info-bulle.*/
    if (_controller.isVisible) {
      await _controller.hideTooltip();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap

      /*() {
        setState(() {
          isSelected = !isSelected;
          widget.isSelected = isSelected;
          if (isSelected) {
            widget.backgroundColor = widget.activeColor ?? primaryColor;
          } else {
            widget.backgroundColor = widget.disabledColor ??
                Theme.of(context).colorScheme.background;
          }
        });
      }*/
      ,
      child: Tooltip(
        message: 'Vous commercialisez ${widget.text}',
        decoration: Decoration.lerp(
            BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: BorderRadius.circular(5)),
            BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(5)),
            0.2),
        textStyle: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
            fontSize: smallText()),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: widget.backgroundColor ??
                  Theme.of(context).colorScheme.background.withOpacity(0.6),
              borderRadius: BorderRadius.circular(15),
            ),
            child: AppText(
              text: widget.text ?? '',
              color: isSelected
                  ? Colors.white
                  : Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
        ),
      ),
    );
  }
}

/*

class ModelSecteur extends StatefulWidget {
  late Color? backgroundColor;
  late Color? activeColor;
  late Color? disabledColor;
  final String? description;
  final String? text;
  late bool? isSelected;
  final Function()? onTap;

  ModelSecteur(
      {super.key,
      this.text,
      this.onTap,
      this.description,
      this.isSelected,
      this.disabledColor,
      this.backgroundColor,
      this.activeColor});

  @override
  State<ModelSecteur> createState() => _ModelSecteurState();
}

class _ModelSecteurState extends State<ModelSecteur> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChoixCategorieBloc, ChoixCategorieState>(
        builder: (context, state) {
      final state = context.watch<ChoixCategorieBloc>().state;
      return GestureDetector(
        onTap: widget.onTap,
        child: Tooltip(
          message: 'L\'un de vos secteurs d\'intervention est : ${widget.text}',
          decoration: Decoration.lerp(
              BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.circular(5)),
              BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(5)),
              0.2),
          textStyle: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
              fontSize: smallText()),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: state.color
                */
/*widget.backgroundColor ??
                  Theme.of(context).colorScheme.background.withOpacity(0.6)*/ /*

                ,
                borderRadius: BorderRadius.circular(15),
              ),
              child: AppText(
                text: widget.text ?? '',
                color: isSelected
                    ? Colors.white
                    : Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ),
        ),
      );
    });
  }
}
*/
class ModelSecteur extends StatelessWidget {
  final String text;
  final bool isSelected;
  final Color activeColor;
  final Color disabledColor;
  final Function() onTap;

  const ModelSecteur({
    required this.text,
    required this.isSelected,
    required this.activeColor,
    required this.disabledColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Tooltip(
        message: 'L\'un de vos secteurs d\'intervention est : $text',
        decoration: BoxDecoration(
          color: isSelected ? activeColor : disabledColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelected
                  ? activeColor
                  : Theme.of(context).colorScheme.background.withOpacity(0.6),
              borderRadius: BorderRadius.circular(15),
            ),
            child: AppText(
              text: text,
              color: isSelected
                  ? Colors.white
                  : Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
        ),
      ),
    );
  }
}
