import 'package:flutter/material.dart';

import '../../widgets/app_button.dart';
import '../../widgets/app_text.dart';
import '../sizes/text_sizes.dart';

class ModelRecomandation extends StatelessWidget {
  final String? backgroundImage;
  final String? shopName;
  final String? description;
  final double? price;
  final String? unit;

  const ModelRecomandation(
      {super.key,
      this.backgroundImage,
      this.shopName,
      this.description,
      this.price,
      this.unit});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(right: 2.0, left: 2.0),
      child: SizedBox(
        child: AppButton(
          height: height * 0.25,
          width: width * 0.45,
          color: Colors.black26,
          onTap: () {},
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //image produit
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 0.0),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                        bottomLeft: Radius.circular(5),
                        bottomRight: Radius.circular(25),
                      ),
                      child: SizedBox(
                          height: height * 0.12,
                          width: width * 0.47,
                          child: Image.asset(
                              fit: BoxFit.cover,
                              backgroundImage ?? 'assets/images/oeuf2.png')),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: AppButton(
                        color: Colors.black54,
                        height: 25,
                        width: 70,
                        child: AppText(
                          text: '${price ?? ''}/${unit ?? 'Kg'}',
                          fontSize: 8,
                        )),
                  )
                ],
              ),

              // note
              Expanded(
                child: ListTile(
                  title: AppText(text: shopName ?? ''),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(right: 4.0, left: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          //width: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                text: '4.0',
                                fontSize: smallText(),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              const Icon(
                                Icons.star,
                                color: Colors.deepOrange,
                                size: 15,
                              )
                            ],
                          ),
                        ),
                        Icon(
                          Icons.verified_sharp,
                          color: Colors.blue.shade900,
                          size: 15,
                        )
                      ],
                    ),
                  ),
                  minTileHeight: 0,
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(
                    top: 6, right: 4.0, left: 4.0, bottom: 3.0),
                child: AppButton(
                  bordeurRadius: 10,
                  color:
                      Theme.of(context).colorScheme.background.withOpacity(0.7),
                  height: height * 0.05,
                  width: width * 0.5,
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                    child: ListTile(
                      title: AppText(
                        text: "Ajouter au panier",
                        //color: Colors.deepOrange.withOpacity(0.8),
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                      ),
                      trailing: Icon(
                        Icons.add_shopping_cart,
                        size: 12,
                      ),
                      minTileHeight: 0,
                      minVerticalPadding: 0,
                      minLeadingWidth: 0,
                      horizontalTitleGap: 0,
                      titleAlignment: ListTileTitleAlignment.center,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
