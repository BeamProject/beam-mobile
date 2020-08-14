import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  List<Object> get props => [];
}

class LoginUsernameChanged extends LoginEvent {
  
  final String username;

  const LoginUsernameChanged(this.username);
  
  List<Object> get props => [username];
}

class LoginPasswordChanged extends LoginEvent {
  final String password;

  const LoginPasswordChanged(this.password);

  List<Object> get props => [password];
}

class LoginDetailsSubmitted extends LoginEvent {
  const LoginDetailsSubmitted();
}