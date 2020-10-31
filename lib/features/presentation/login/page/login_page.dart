import 'package:beam/common/di/config.dart';
import 'package:beam/features/presentation/login/bloc/login_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_form.dart';

class LoginPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => getIt<LoginCubit>(),
        child: Scaffold(
            appBar: AppBar(title: const Text('Login')),
            backgroundColor: Color(0xFF2C2D2D),
            body: Padding(
                padding: const EdgeInsets.all(12), child: LoginForm())));
  }
}
