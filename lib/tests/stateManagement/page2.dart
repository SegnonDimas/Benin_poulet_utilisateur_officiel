import 'package:benin_poulet/bloc/blocLogic.dart';
import 'package:benin_poulet/bloc/events/appColorsEvents.dart';
import 'package:benin_poulet/bloc/states/AppColorsStates.dart';
import 'package:benin_poulet/tests/stateManagement/bloc/counter.bloc.dart';
import 'package:benin_poulet/tests/stateManagement/stateWithBloc.dart';
import 'package:benin_poulet/views/sizes/app_sizes.dart';
import 'package:benin_poulet/widgets/app_button.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Page2 extends StatelessWidget {
  const Page2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                BlocBuilder<AppColorsBloc, AppColorState>(
                  builder: (context, state) {
                    //context.read<CounterBloc>().add(IncrementCounterEvent());
                    return Container(
                      color: state.color,
                      height: 80,
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MenuBar(children: [
                    GestureDetector(
                        onTap: () {
                          context.read<AppColorsBloc>().add(AppRedColorEvent());
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AppText(text: '   RED   '),
                        )),
                    GestureDetector(
                      onTap: () {
                        context.read<AppColorsBloc>().add(AppBlueColorEvent());
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AppText(text: '   BLUE   '),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.read<AppColorsBloc>().add(AppBlackColorEvent());
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AppText(text: '   BLACK   '),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.read<AppColorsBloc>().add(AppGreenColorEvent());
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AppText(text: '   GREEN   '),
                      ),
                    ),
                  ]),
                ),
                AppText(text: 'Le compteur est à :'),
                BlocBuilder<CounterBloc, CounterState>(
                    builder: (context, state) {
                  print('\n:::: Counter : ${state.counter}');

                  if (state is CounterSuccessState ||
                      state is CounterInitialState) {
                    return BlocBuilder<AppColorsBloc, AppColorState>(
                        builder: (context, state2) {
                      print('\n:::: Couleur : ${state2.color}');

                      return AppText(
                        text: '${state.counter}',
                        fontSize: 40,
                        color: state2.color,
                      );
                    });
                  } else if (state is CounterErrorState) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AppText(
                        text: state.errorMessage,
                        //fontSize: 30,
                        overflow: TextOverflow.fade,
                        color: Colors.red,
                        fontWeight: FontWeight.w900,
                      ),
                    );
                  } else {
                    return Container();
                  }
                }),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const StateWithBloc()));
                      },
                      icon: const Icon(Icons.arrow_back_ios)),
                  SizedBox(
                    width: appWidthSize(context) * 0.35,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BlocBuilder<AppColorsBloc, AppColorState>(
                            builder: (context, state) {
                          return AppButton(
                              bordeurRadius: 50,
                              width: 55,
                              height: 55,
                              onTap: () {
                                context
                                    .read<CounterBloc>()
                                    .add(DecrementCounterEvent());
                              },
                              color: state.color,
                              child: const Icon(
                                Icons.remove,
                                color: Colors.white,
                                size: 30,
                              ));
                        }),
                        BlocBuilder<AppColorsBloc, AppColorState>(
                            builder: (context, state) {
                          return AppButton(
                              bordeurRadius: 50,
                              width: 55,
                              height: 55,
                              onTap: () {
                                context
                                    .read<CounterBloc>()
                                    .add(IncrementCounterEvent());
                              },
                              color: state.color,
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 30,
                              ));
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
