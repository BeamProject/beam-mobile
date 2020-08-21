import 'package:beam/features/presentation/login/bloc/login_bloc.dart';
import 'package:beam/features/presentation/login/bloc/login_event.dart';
import 'package:beam/features/presentation/login/bloc/login_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
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
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.username != current.username,
      builder: (context, state) {
        return TextField(
            style: TextStyle(color: Colors.white),
            onChanged: (username) =>
                context.bloc<LoginBloc>().add(LoginUsernameChanged(username)),
            decoration: InputDecoration(
              labelText: 'Username',
              labelStyle: new TextStyle(color: Colors.white),
              errorText: state.formStatus == FormStatus.invalid
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
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
            style: TextStyle(color: Colors.white),
            obscureText: true,
            onChanged: (password) =>
                context.bloc<LoginBloc>().add(LoginPasswordChanged(password)),
            decoration: InputDecoration(
              labelText: 'Password',
              labelStyle: new TextStyle(color: Colors.white),
              errorText: state.formStatus == FormStatus.invalid
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
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) =>
          previous.formStatus != current.formStatus,
      builder: (context, state) {
        return state.formStatus == FormStatus.submissionInProgress
            ? CircularProgressIndicator()
            : RaisedButton(
                child: const Text('Login'),
                onPressed: (state.formStatus == FormStatus.valid)
                    ? () {
                        print('state valid');
                        context.bloc<LoginBloc>().add(LoginDetailsSubmitted());
                      }
                    : () {
                        print('state invalid: ' + state.formStatus.toString());
                        return null;
                      });
      },
    );
  }
}
