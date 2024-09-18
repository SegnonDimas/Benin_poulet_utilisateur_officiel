import 'package:benin_poulet/views/sizes/app_sizes.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';

import '../../../bloc/auth/auth_bloc.dart';

class CHomePage extends StatefulWidget {
  const CHomePage({super.key});

  @override
  State<CHomePage> createState() => _CHomePageState();
}

class _CHomePageState extends State<CHomePage> {
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state as AuthAuthenticated;
    return Scaffold(
      appBar: AppBar(
        title: AppText(text: authState.userId.replaceAll(' ', '')),
        centerTitle: true,
        actions: const [Icon(Icons.account_circle)],
      ),
      body: Column(
        children: [
          Container(
              height: 150,
              width: appWidthSize(context),
              color: Colors.green,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CarouselSlider(
                      items: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 130,
                            width: appWidthSize(context),
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(20)),
                            child: Image.asset(
                              'assets/images/welcome.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 130,
                            width: appWidthSize(context) * 0.8,
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(20)),
                            child: Image.asset('assets/images/oeuf2.png',
                                fit: BoxFit.cover),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 130,
                            width: appWidthSize(context) * 0.8,
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(20)),
                            child: Image.asset(
                                'assets/images/pouletCouveuse.png',
                                fit: BoxFit.cover),
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          child: Image.asset('assets/images/oeuf2.png',
                              fit: BoxFit.cover),
                        )
                      ],
                      options: CarouselOptions(
                          autoPlay: true,
                          autoPlayCurve: Curves.fastEaseInToSlowEaseOut,
                          aspectRatio: 13 / 5,
                          enlargeFactor: 0.5,
                          onPageChanged: (index, CarouselPageChangedReason c) {
                            //return index;
                            setState(() {
                              pageIndex = index;
                            });
                          })),
                  Positioned(
                    bottom: 10,
                    child: Container(
                      alignment: Alignment.center,
                      height: 20,
                      width: appWidthSize(context) * 0.25,
                      decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .background
                              .withOpacity(0.7),
                          borderRadius: BorderRadius.circular(20)),
                      child: PageViewDotIndicator(
                          currentItem: pageIndex,
                          count: 4,
                          size: Size(8, 8),
                          unselectedColor: Colors.grey.shade600,
                          selectedColor: Colors.grey.shade100),
                    ),
                  )
                ],
              ))
        ],
      ),
    );
  }
}
