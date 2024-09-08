import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/sizes/app_sizes.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_button.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class VPerformancesPage extends StatefulWidget {
  const VPerformancesPage({super.key});

  @override
  State<VPerformancesPage> createState() => _VPerformancesPageState();
}

class _VPerformancesPageState extends State<VPerformancesPage> {
  List<double> values = [20.3, 12.05, 42.0, 83.56, 10.05];
  final List<String> _listPeriode = [
    'Auj',
    'Sur 7 jours',
    'Sur 30 jours',
    'Sur 3 mois',
    'Sur 6 mois',
    'Sur 1 an'
  ];

  bool surAuj = true,
      sur7jours = false,
      sur30jours = false,
      sur3mois = false,
      sur6mois = false,
      sur1an = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          /// liste des périodes
          SizedBox(
              height: appHeightSize(context) * 0.07,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  /// Auj
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AppButton(
                          color: surAuj
                              ? primaryColor
                              : Theme.of(context).colorScheme.surface,
                          width: appWidthSize(context) * 0.25,
                          height: appHeightSize(context) * 0.06,
                          bordeurRadius: 20,
                          child: AppText(
                            text: _listPeriode[0],
                            color: surAuj
                                ? Colors.white
                                : Theme.of(context)
                                    .colorScheme
                                    .inversePrimary
                                    .withOpacity(0.2),
                          ),
                          onTap: () {
                            setState(() {
                              surAuj = true;
                              sur7jours = false;
                              sur30jours = false;
                              sur3mois = false;
                              sur6mois = false;
                              sur1an = false;
                            });
                          })),

                  /// sur 7 jours
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AppButton(
                          color: sur7jours
                              ? primaryColor
                              : Theme.of(context).colorScheme.surface,
                          width: appWidthSize(context) * 0.25,
                          height: appHeightSize(context) * 0.06,
                          bordeurRadius: 20,
                          child: AppText(
                            text: _listPeriode[1],
                            color: sur7jours
                                ? Colors.white
                                : Theme.of(context)
                                    .colorScheme
                                    .inversePrimary
                                    .withOpacity(0.2),
                          ),
                          onTap: () {
                            setState(() {
                              surAuj = false;
                              sur7jours = true;
                              sur30jours = false;
                              sur3mois = false;
                              sur6mois = false;
                              sur1an = false;
                            });
                          })),

                  /// sur 30 jours
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AppButton(
                          color: sur30jours
                              ? primaryColor
                              : Theme.of(context).colorScheme.surface,
                          width: appWidthSize(context) * 0.25,
                          height: appHeightSize(context) * 0.06,
                          bordeurRadius: 20,
                          child: AppText(
                            text: _listPeriode[2],
                            color: sur30jours
                                ? Colors.white
                                : Theme.of(context)
                                    .colorScheme
                                    .inversePrimary
                                    .withOpacity(0.2),
                          ),
                          onTap: () {
                            setState(() {
                              surAuj = false;
                              sur7jours = false;
                              sur30jours = true;
                              sur3mois = false;
                              sur6mois = false;
                              sur1an = false;
                            });
                          })),

                  /// sur 3 mois
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AppButton(
                          color: sur3mois
                              ? primaryColor
                              : Theme.of(context).colorScheme.surface,
                          width: appWidthSize(context) * 0.25,
                          height: appHeightSize(context) * 0.06,
                          bordeurRadius: 20,
                          child: AppText(
                            text: _listPeriode[3],
                            color: sur3mois
                                ? Colors.white
                                : Theme.of(context)
                                    .colorScheme
                                    .inversePrimary
                                    .withOpacity(0.2),
                          ),
                          onTap: () {
                            setState(() {
                              surAuj = false;
                              sur7jours = false;
                              sur30jours = false;
                              sur3mois = true;
                              sur6mois = false;
                              sur1an = false;
                            });
                          })),

                  /// sur 6 mois
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AppButton(
                          color: sur6mois
                              ? primaryColor
                              : Theme.of(context).colorScheme.surface,
                          width: appWidthSize(context) * 0.25,
                          height: appHeightSize(context) * 0.06,
                          bordeurRadius: 20,
                          child: AppText(
                            text: _listPeriode[4],
                            color: sur6mois
                                ? Colors.white
                                : Theme.of(context)
                                    .colorScheme
                                    .inversePrimary
                                    .withOpacity(0.2),
                          ),
                          onTap: () {
                            setState(() {
                              surAuj = false;
                              sur7jours = false;
                              sur30jours = false;
                              sur3mois = false;
                              sur6mois = true;
                              sur1an = false;
                            });
                          })),

                  /// sur 1 an
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AppButton(
                          color: sur1an
                              ? primaryColor
                              : Theme.of(context).colorScheme.surface,
                          width: appWidthSize(context) * 0.25,
                          height: appHeightSize(context) * 0.06,
                          bordeurRadius: 20,
                          child: AppText(
                            text: _listPeriode[5],
                            color: sur1an
                                ? Colors.white
                                : Theme.of(context)
                                    .colorScheme
                                    .inversePrimary
                                    .withOpacity(0.2),
                          ),
                          onTap: () {
                            setState(() {
                              surAuj = false;
                              sur7jours = false;
                              sur30jours = false;
                              sur3mois = false;
                              sur6mois = false;
                              sur1an = true;
                            });
                          })),
                ],
              )),

          SizedBox(
            height: appHeightSize(context) * 0.1,
            width: appWidthSize(context),
            child: ListTile(
              title: AppText(
                text: "Ventes ",
                fontSize: largeText(),
                fontWeight: FontWeight.w800,
              ),
              trailing: IconButton(
                icon: const Icon(Icons.info_outline),
                onPressed: () {},
              ),
            ),
          ),

          /// l'histogramme
          SizedBox(
            height: appHeightSize(context) * 0.25,
            //width: 200,
            child: BarChart(
              swapAnimationCurve: Curves.easeInExpo,
              BarChartData(
                  borderData: FlBorderData(show: false),
                  titlesData: const FlTitlesData(
                    show: true,
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: const FlGridData(show: false),
                  maxY: 100,
                  minY: 0,
                  barGroups: [
                    BarChartGroupData(
                        x: 1,
                        barsSpace: 10,
                        barRods: <BarChartRodData>[
                          BarChartRodData(toY: 30),
                          BarChartRodData(toY: 90),
                          BarChartRodData(toY: 40),
                          BarChartRodData(toY: 20),
                          BarChartRodData(
                            toY: 50,
                          ),
                        ]),
                    BarChartGroupData(
                        x: 2,
                        barsSpace: 10,
                        barRods: <BarChartRodData>[
                          BarChartRodData(toY: 30),
                          BarChartRodData(toY: 90),
                          BarChartRodData(toY: 40),
                          BarChartRodData(toY: 20),
                          BarChartRodData(
                            toY: 50,
                          ),
                        ]),
                    BarChartGroupData(
                        x: 3,
                        barsSpace: 10,
                        showingTooltipIndicators: [
                          20,
                          10,
                          30
                        ],
                        barRods: <BarChartRodData>[
                          BarChartRodData(toY: 30),
                          BarChartRodData(toY: 10),
                          BarChartRodData(toY: 40),
                          BarChartRodData(toY: 80),
                          BarChartRodData(
                            toY: 50,
                          ),
                        ]),
                  ]),
            ),
          ),

          /// Divider()
          Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25.0, bottom: 20),
            child: Divider(
              color:
                  Theme.of(context).colorScheme.inverseSurface.withOpacity(0.3),
            ),
          ),

          /// volume de commandes
          ListTile(
              title: AppText(
                text: "Volume de commandes ",
                fontSize: mediumText(),
                // fontWeight: FontWeight.w800,
              ),
              trailing: AppText(
                text: '48',
              )),

          // text
          ListTile(
              title: AppText(
                text: "Ticket moyen ",
                fontSize: mediumText(),
                // fontWeight: FontWeight.w800,
              ),
              trailing: AppText(
                text: '7500 F',
              )),
        ],
      ),
    );
  }
}

class IndividuelBar {
  final int x;
  final double y;

  IndividuelBar(this.x, this.y);
}

class BarData {
  final double sunAmount;
  final double monAmount;
  final double tuesAmount;
  final double winAmount;
  final double thirAmount;

  BarData(
      {required this.sunAmount,
      required this.monAmount,
      required this.tuesAmount,
      required this.winAmount,
      required this.thirAmount});

  List<IndividuelBar> barData = [];

  void initialData() {
    barData = [
      IndividuelBar(0, sunAmount),
      IndividuelBar(0, monAmount),
      IndividuelBar(0, tuesAmount),
      IndividuelBar(0, winAmount),
      IndividuelBar(0, thirAmount),
    ];
  }
}
