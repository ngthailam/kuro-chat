import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:kuro_chat/data/auth/repo/auth_repository.dart';
import 'package:kuro_chat/presentation/page/home/cubit/home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._authRepo) : super(HomeInitial());

  final AuthRepo _authRepo;

  initialze() async {
    final isLoggedIn = await _authRepo.isLoggedIn();
    if (isLoggedIn) {
      emit(HomeLoggedIn());
    } else {
      emit(HomeNotLoggedIn());
    }
  }
}
