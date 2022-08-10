import 'package:injectable/injectable.dart';
import 'package:kuro_chat/data/user/datasource/user_local_datasource.dart';
import 'package:kuro_chat/data/user/datasource/user_remote_datasource.dart';
import 'package:kuro_chat/data/user/entity/user_entity.dart';

abstract class UserRepo {
  Future<UserEntity?> fetchUser(String userId);
}

@Injectable(as: UserRepo)
class UserRepoImpl extends UserRepo {
  UserRepoImpl(this._localDataSource, this._remoteDataSource);

  final UserRemoteDataSource _remoteDataSource;
  final UserLocalDataSource _localDataSource;

  @override
  Future<UserEntity?> fetchUser(String userId) async {
    final user = await _remoteDataSource.fetchUser(userId);
    if (user == null) return null;
    await _localDataSource.saveCurrentUser(user);
    return user;
  }
}
