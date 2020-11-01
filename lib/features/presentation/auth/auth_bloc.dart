import 'dart:async';

import 'package:beam/features/domain/entities/user.dart';
import 'package:beam/features/domain/usecases/auto_log_in.dart';
import 'package:beam/features/domain/usecases/get_current_user.dart';
import 'package:beam/features/domain/usecases/log_out.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

import 'auth_state.dart';

@injectable
class AuthCubit extends Cubit<AuthenticationState> {
  final ObserveUser _observeUser;
  final LogOut _logOut;
  final AutoLogIn _autoLogIn;
  StreamSubscription<User> _authenticationStatusSubscription;

  AuthCubit(this._observeUser, this._logOut, this._autoLogIn)
      : super(const AuthenticationState.unknown()) {
    _authenticationStatusSubscription = _observeUser().listen((user) {
      _onAuthenticationStatusChanged(user);
    });
  }

  void onLogout() {
    _logOut();
  }

  void onAutoLogIn() {
    _autoLogIn();
  }

  void _onAuthenticationStatusChanged(User user) {
    if (user != null) {
      emit(AuthenticationState.authenticated(user));
    } else {
      emit(AuthenticationState.unauthenticated());
    }
  }

  @override
  Future<void> close() {
    _authenticationStatusSubscription?.cancel();
    return super.close();
  }
}
