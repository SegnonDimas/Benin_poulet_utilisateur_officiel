import 'package:benin_poulet/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/auth/auth_bloc.dart';

class CHomePage extends StatefulWidget {
  const CHomePage({super.key});

  @override
  State<CHomePage> createState() => _CHomePageState();
}

class _CHomePageState extends State<CHomePage> {
  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state as AuthAuthenticated;
    return Scaffold(
      appBar: AppBar(
        title: AppText(text: authState.userId.replaceAll(' ', '')),
        centerTitle: true,
        actions: const [Icon(Icons.account_circle)],
      ),
      body: Container(),
    );
  }
}
