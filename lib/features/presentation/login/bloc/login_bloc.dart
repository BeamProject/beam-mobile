
import 'package:beam/features/domain/usecases/log_in.dart';
import 'package:bloc/bloc.dart';

import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LogIn _logIn;

  LoginBloc(this._logIn) : super(LoginState());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginUsernameChanged) {
      yield _mapLoginUsernameChangedToState(event);
    } else if (event is LoginPasswordChanged) {
      yield _mapPasswordChangedToState(event);
    } else if (event is LoginDetailsSubmitted) {
      try {
        yield state.copy(formStatus: FormStatus.submissionInProgress);
        await _logIn(state.username, state.password);
        yield state.copy(formStatus: FormStatus.submissionSuccess);
      } on Exception {
        yield state.copy(formStatus: FormStatus.submissionFailure);
      }
    }
  }

  LoginState _mapLoginUsernameChangedToState(LoginUsernameChanged event) {
    final username = event.username;
    if (username.isEmpty) {
      return state.copy(username: username, formStatus: FormStatus.invalid);
    }
    return state.copy(username: username, formStatus: FormStatus.valid);
  }

  LoginState _mapPasswordChangedToState(LoginPasswordChanged event) {
    final password = event.password;
    if (password.isEmpty) {
      return state.copy(password: password, formStatus: FormStatus.invalid);
    }
    return state.copy(password: password, formStatus: FormStatus.valid);
  }
}