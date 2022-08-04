import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:kuro_chat/data/auth/repo/auth_repository.dart';
import 'package:kuro_chat/presentation/page/auth/login/cubit/login_state.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authRepo) : super(LoginInitial());

  final AuthRepo _authRepo;

  Future login(String text) async {
    await _authRepo.logIn(text);
    emit(LoginSuccess());
  }
}
