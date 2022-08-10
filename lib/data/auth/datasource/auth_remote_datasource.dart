import 'package:injectable/injectable.dart';
import 'package:kuro_chat/data/user/datasource/user_remote_datasource.dart';
import 'package:kuro_chat/data/user/entity/user_entity.dart';

abstract class AuthRemoteDataSource {
  Future<UserEntity?> logIn(String userName);
}

@Injectable(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl extends AuthRemoteDataSource {
  final UserRemoteDataSource _userRemoteDataSource;

  AuthRemoteDataSourceImpl(this._userRemoteDataSource);

  @override
  Future<UserEntity?> logIn(String userName) async {
    final user = await _userRemoteDataSource.fetchUserByName(userName);
    return user;
  }
}
