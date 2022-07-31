import 'package:injectable/injectable.dart';
import 'package:kuro_chat/data/auth/datasource/auth_remote_datasource.dart';
import 'package:kuro_chat/data/user/datasource/user_local_datasource.dart';
import 'package:kuro_chat/data/user/datasource/user_remote_datasource.dart';
import 'package:kuro_chat/data/user/entity/user_entity.dart';

abstract class AuthRepo {
  Future<bool> isLoggedIn();

  Future<bool> logIn(String userId);

  Future<void> logOut();

  Future<void> register(String userId);
}

@Injectable(as: AuthRepo)
class AuthRepoImpl extends AuthRepo {
  final AuthRemoteDataSource _authRemoteDataSource;
  final UserRemoteDataSource _userRemoteDataSource;
  final UserLocalDataSource _userLocalDataSource;

  AuthRepoImpl(
    this._authRemoteDataSource,
    this._userRemoteDataSource,
    this._userLocalDataSource,
  );

  @override
  Future<bool> isLoggedIn() async {
    return (await _userLocalDataSource.getCurrentUser()) != null;
  }

  @override
  Future<bool> logIn(String userId) async {
    final user = UserEntity(id: userId);
    final logInSuccess = await _authRemoteDataSource.logIn(userId);
    if (!logInSuccess) {
      return false;
    }
    await _userLocalDataSource.saveCurrentUser(user);
    return true;
  }

  @override
  Future<void> logOut() async {
    await _userLocalDataSource.deleteCurrentUser();
    return;
  }

  @override
  Future<void> register(String userId) {
    return _userRemoteDataSource.createUser(userId);
  }
}
