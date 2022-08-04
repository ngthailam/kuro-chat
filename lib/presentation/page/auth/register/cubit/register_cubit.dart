import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:kuro_chat/data/auth/repo/auth_repository.dart';
import 'package:kuro_chat/presentation/page/auth/register/cubit/register_state.dart';

@injectable
class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this._authRepo) : super(RegisterInitial());

  final AuthRepo _authRepo;

  Future registerUser(String text) async {
    try {
      await _authRepo.register(text);
      emit(RegisterSuccess());
    } catch (e) {
      log(e.toString());
    }
  }
}
