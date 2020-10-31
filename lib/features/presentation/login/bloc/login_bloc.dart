import 'package:beam/features/domain/entities/login_result.dart';
import 'package:beam/features/domain/usecases/log_in.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

import 'login_state.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  final LogIn _logIn;

  LoginCubit(this._logIn) : super(LoginState());

  void onUsernameChanged(String username) {
    emit(state.copy(username: Username(username)));
  }

  void onPasswordChanged(String password) {
    emit(state.copy(password: Password(password)));
  }

  void onLoginDetailsSubmitted() async {
    if (!state.username.isValid() || !state.password.isValid()) {
      emit(state.copy(formStatus: FormStatus.invalid));
      return;
    }
    try {
      emit(state.copy(formStatus: FormStatus.submissionInProgress));
      final loginResult = await _logIn(state.username.value, state.password.value);
      if (loginResult == LoginResult.SUCCESS) {
        emit(state.copy(formStatus: FormStatus.submissionSuccess));
      } else {
        emit(state.copy(formStatus: FormStatus.submissionFailure));
      }
    } on Exception {
      emit(state.copy(formStatus: FormStatus.submissionFailure));
    }
  }
}
