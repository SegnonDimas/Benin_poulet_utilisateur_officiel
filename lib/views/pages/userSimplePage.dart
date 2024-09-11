import 'package:benin_poulet/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_states.dart';

class UserSimplePage extends StatelessWidget {
  const UserSimplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: AppText(text: 'Default Route'), actions: const [
        Padding(
          padding: EdgeInsets.only(right: 8.0),
          child: Icon(
            Icons.warning_amber,
            color: Colors.amber,
          ),
        ),
      ]),
      body: Center(
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.warning_amber,
                  size: 50,
                  color: Colors.amber,
                ),
                AppText(
                  text:
                      'Default Route\nVeuillez définir une route pour votre page',
                  textAlign: TextAlign.center,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
