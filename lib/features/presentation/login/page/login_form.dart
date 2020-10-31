import 'package:beam/features/presentation/login/bloc/login_bloc.dart';
import 'package:beam/features/presentation/login/bloc/login_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
        listenWhen: (previous, current) =>
            previous.formStatus != current.formStatus,
        listener: (context, state) {
          if (state.formStatus == FormStatus.submissionFailure) {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                  const SnackBar(content: Text('Authentication failure')));
          }
        },
        child: Align(
            alignment: const Alignment(0, -1 / 3),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _UsernameInput(),
                const Padding(padding: EdgeInsets.all(12)),
                _PasswordInput(),
                const Padding(padding: EdgeInsets.all(12)),
                _LoginButton()
              ],
            )));
  }
}

class _UsernameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) =>
          previous.username != current.username ||
          previous.formStatus != current.formStatus,
      builder: (context, state) {
        return TextField(
            style: TextStyle(color: Colors.white),
            onChanged: (username) =>
                context.bloc<LoginCubit>().onUsernameChanged(username),
            decoration: InputDecoration(
              labelText: 'Username',
              labelStyle: new TextStyle(color: Colors.white),
              errorText: state.formStatus == FormStatus.invalid &&
                      !state.username.isValid()
                  ? 'username invalid'
                  : null,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ));
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) =>
          previous.password != current.password ||
          previous.formStatus != current.formStatus,
      builder: (context, state) {
        return TextField(
            style: TextStyle(color: Colors.white),
            obscureText: true,
            onChanged: (password) =>
                context.bloc<LoginCubit>().onPasswordChanged(password),
            decoration: InputDecoration(
              labelText: 'Password',
              labelStyle: new TextStyle(color: Colors.white),
              errorText: state.formStatus == FormStatus.invalid &&
                      !state.password.isValid()
                  ? 'password invalid'
                  : null,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ));
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) =>
          previous.formStatus != current.formStatus,
      builder: (context, state) {
        return state.formStatus == FormStatus.submissionInProgress
            ? CircularProgressIndicator()
            : RaisedButton(
                child: const Text('Login'),
                onPressed: () {
                  context.bloc<LoginCubit>().onLoginDetailsSubmitted();
                });
      },
    );
  }
}
