import 'package:injectable/injectable.dart';
import 'package:kuro_chat/data/auth/datasource/auth_remote_datasource.dart';
import 'package:kuro_chat/data/lastmessage/datasource/last_message_local_datasource.dart';
import 'package:kuro_chat/data/user/datasource/user_local_datasource.dart';
import 'package:kuro_chat/data/user/datasource/user_remote_datasource.dart';

abstract class AuthRepo {
  Future<bool> isLoggedIn();

  Future<bool> logIn(String userName);

  Future<void> logOut();

  Future<void> register(String userName);
}

@Injectable(as: AuthRepo)
class AuthRepoImpl extends AuthRepo {
  final AuthRemoteDataSource _authRemoteDataSource;
  final UserRemoteDataSource _userRemoteDataSource;
  final UserLocalDataSource _userLocalDataSource;
  final LastMessageLocalDataSource _lastMessageLocalDataSource;

  AuthRepoImpl(
    this._authRemoteDataSource,
    this._userRemoteDataSource,
    this._userLocalDataSource,
    this._lastMessageLocalDataSource,
  );

  @override
  Future<bool> isLoggedIn() async {
    return (await _userLocalDataSource.getCurrentUser()) != null;
  }

  @override
  Future<bool> logIn(String userName) async {
    final user = await _authRemoteDataSource.logIn(userName);
    if (user == null) {
      return false;
    }
    await _userLocalDataSource.saveCurrentUser(user);
    return true;
  }

  @override
  Future<void> logOut() async {
    await _userLocalDataSource.deleteCurrentUser();
    await _lastMessageLocalDataSource.clear();
    return;
  }

  @override
  Future<void> register(String userName) {
    return _userRemoteDataSource.createUser(userName);
  }
}
