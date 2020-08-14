enum FieldValidationStatus { init, valid, invalid }

enum FormStatus {
  pure,
  valid,
  invalid,
  submissionInProgress,
  submissionSuccess,
  submissionFailure
}

class LoginState {
  final String username;
  final String password;
  final FormStatus formStatus;

  const LoginState(
      {this.username = '',
      this.password = '',
      this.formStatus = FormStatus.pure});

  LoginState copy({String username, String password, FormStatus formStatus}) {
    return LoginState(
        username: username ?? this.username,
        password: password ?? this.password,
        formStatus: formStatus ?? this.formStatus);
  }
}
