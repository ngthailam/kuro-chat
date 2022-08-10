import 'package:firebase_database/firebase_database.dart';
import 'package:injectable/injectable.dart';
import 'package:kuro_chat/data/user/datasource/user_remote_datasource.dart';

abstract class AuthRemoteDataSource {
  Future<bool> logIn(String userId);
}

@Injectable(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl extends AuthRemoteDataSource {
  final UserRemoteDataSource _userRemoteDataSource;

  AuthRemoteDataSourceImpl(this._userRemoteDataSource);

  @override
  Future<bool> logIn(String userId) async {
    final user = await _userRemoteDataSource.fetchUser(userId);
    // TODO: implement real later
    return user != null;
  }
}
