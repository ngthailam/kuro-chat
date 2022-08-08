abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginResult extends LoginState {
  final bool isSuccess;

  LoginResult({required this.isSuccess});
}
