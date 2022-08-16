import 'package:injectable/injectable.dart';
import 'package:kuro_chat/data/user/datasource/user_local_datasource.dart';
import 'package:kuro_chat/data/user/datasource/user_remote_datasource.dart';
import 'package:kuro_chat/data/user/entity/user_entity.dart';

abstract class UserRepo {
  Future<UserEntity?> fetchUser(String userId);

  Future<UserEntity?> refreshCurrentUser();

  Future<List<UserEntity>> fetchByName(String name);

  Future<List<UserEntity>> searchByName(String name);
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

  @override
  Future<List<UserEntity>> fetchByName(String name) {
    return _remoteDataSource.fetchByName(name);
  }

  @override
  Future<List<UserEntity>> searchByName(String name) {
    return _remoteDataSource.searchByName(name);
  }

  @override
  Future<UserEntity?> refreshCurrentUser() {
    return fetchUser(currentUserId);
  }
}
