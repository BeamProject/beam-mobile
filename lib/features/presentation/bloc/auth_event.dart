import 'package:beam/features/domain/entities/user.dart';
import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AuthenticationStatusChanged extends AuthenticationEvent {
  final User user;

  const AuthenticationStatusChanged(this.user);

  @override
  List<Object> get props => [user];
}

class AuthenticationLogOutRequested extends AuthenticationEvent {}


class AuthenticationAutoLogInRequested extends AuthenticationEvent {}