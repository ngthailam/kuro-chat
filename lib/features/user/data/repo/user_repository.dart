import 'package:injectable/injectable.dart';
import 'package:kuro_chat/features/user/data/datasource/user_local_datasource.dart';
import 'package:kuro_chat/features/user/data/datasource/user_remote_datasource.dart';
import 'package:kuro_chat/features/user/data/entity/user_entity.dart';

abstract class UserRepo {
  Future<UserEntity> fetchCurrentUser();

  UserEntity getCurrentUser();
}

@Injectable(as: UserRepo)
class UserRepoImpl extends UserRepo {
  UserRepoImpl(this._localDataSource, this._remoteDataSource);

  final UserRemoteDataSource _remoteDataSource;
  final UserLocalDataSource _localDataSource;

  @override
  Future<UserEntity> fetchCurrentUser() async {
    final user = await _remoteDataSource.fetchCurrentUser();
    await _localDataSource.saveCurrentUser(user);
    return user;
  }

  @override
  UserEntity getCurrentUser() {
    return _localDataSource.getCurrentUser();
  }
}
