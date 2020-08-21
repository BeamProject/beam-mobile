import 'package:beam/features/domain/entities/user.dart';
import 'package:equatable/equatable.dart';

class AuthenticationState extends Equatable {
  final User user;

  const AuthenticationState._(
      {this.user});

  const AuthenticationState.unknown() : this._();

  const AuthenticationState.unauthenticated()
      : this._(user: null);

  const AuthenticationState.authenticated(User user)
      : this._(user: user);

  @override
  List<Object> get props => [user];
}
