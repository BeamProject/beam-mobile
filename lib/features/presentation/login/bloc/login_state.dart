import 'package:equatable/equatable.dart';

enum FormStatus {
  pure,
  valid,
  invalid,
  submissionInProgress,
  submissionSuccess,
  submissionFailure
}

abstract class InputField extends Equatable {
  final String value;

  const InputField(this.value);

  @override
  List<Object> get props => [value];
}

class Username extends InputField {
  const Username(String value) : super(value);

  bool isValid() {
    return value.isNotEmpty;
  }
}

class Password extends InputField {
  const Password(String value) : super(value);

  bool isValid() {
    return value.isNotEmpty;
  }
}

class LoginState {
  final Username username;
  final Password password;
  final FormStatus formStatus;

  const LoginState(
      {this.username = const Username(''),
      this.password = const Password(''),
      this.formStatus = FormStatus.pure});

  LoginState copy(
      {Username? username, Password? password, FormStatus? formStatus}) {
    return LoginState(
        username: username ?? this.username,
        password: password ?? this.password,
        formStatus: formStatus ?? this.formStatus);
  }
}
