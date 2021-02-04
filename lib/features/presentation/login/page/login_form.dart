import 'package:beam/features/presentation/login/bloc/login_bloc.dart';
import 'package:beam/features/presentation/login/bloc/login_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

TextStyle style = TextStyle(fontSize: 20.0);

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
                SizedBox(
                      height: 100.0,
                      child: Image.asset(
                        "images/beam_logo.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                const Padding(padding: EdgeInsets.all(12)),
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
            style: style,
            onChanged: (username) =>
                context.bloc<LoginCubit>().onUsernameChanged(username),
            decoration: InputDecoration(
              hintText: 'Username',
              labelStyle: new TextStyle(color: Colors.white),
              errorText: state.formStatus == FormStatus.invalid &&
                      !state.username.isValid()
                  ? 'username invalid'
                  : null,
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
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
            style: style,
            obscureText: true,
            onChanged: (password) =>
                context.bloc<LoginCubit>().onPasswordChanged(password),
            decoration: InputDecoration(
              hintText: 'Password',
              labelStyle: new TextStyle(color: Colors.white),
              errorText: state.formStatus == FormStatus.invalid &&
                      !state.password.isValid()
                  ? 'password invalid'
                  : null,
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
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
            : Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(30.0),
                color: Theme.of(context).primaryColor,
                child: MaterialButton(
                  minWidth: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  onPressed: () {
                     context.bloc<LoginCubit>().onLoginDetailsSubmitted();
                  },
                  child: Text("Login",
                      textAlign: TextAlign.center,
                      style: style.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ));
      },
    );
  }
}
