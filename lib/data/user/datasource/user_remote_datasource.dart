import 'package:injectable/injectable.dart';
import 'package:kuro_chat/data/user/entity/user_entity.dart';

abstract class UserRemoteDataSource {
  Future<UserEntity> fetchUser(String id);

  Future<void> createUser(String userId);
}

@Injectable(as: UserRemoteDataSource)
class UserRemoteDataSourceImpl extends UserRemoteDataSource {
  @override
  Future<UserEntity> fetchUser(String userId) {
    throw UnimplementedError();
  }
  
  @override
  Future<void> createUser(String userId) {
    throw UnimplementedError();
  }
}
