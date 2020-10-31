import 'dart:async';

import 'package:beam/features/domain/entities/user.dart';
import 'package:beam/features/domain/usecases/auto_log_in.dart';
import 'package:beam/features/domain/usecases/get_current_user.dart';
import 'package:beam/features/domain/usecases/log_out.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

import 'auth_event.dart';
import 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final ObserveUser _observeUser;
  final LogOut _logOut;
  final AutoLogIn _autoLogIn;
  StreamSubscription<User> _authenticationStatusSubscription;

  AuthBloc(this._observeUser, this._logOut, this._autoLogIn)
      : super(const AuthenticationState.unknown()) {
    _authenticationStatusSubscription = _observeUser().listen((user) {
      add(AuthenticationStatusChanged(user));
    });
  }

  @override
  Stream<AuthenticationState> mapEventToState(event) async* {
    if (event is AuthenticationStatusChanged) {
      yield _mapAuthenticationStatusChangedToState(event);
    } else if (event is AuthenticationLogOutRequested) {
      _logOut();
    } else if (event is AuthenticationAutoLogInRequested) {
      _autoLogIn();
    }
  }

  AuthenticationState _mapAuthenticationStatusChangedToState(
      AuthenticationStatusChanged event) {
    if (event.user != null) {
      return AuthenticationState.authenticated(event.user);
    } else {
      return AuthenticationState.unauthenticated();
    }
  }

  @override
  Future<void> close() {
    _authenticationStatusSubscription?.cancel();
    return super.close();
  }
}
