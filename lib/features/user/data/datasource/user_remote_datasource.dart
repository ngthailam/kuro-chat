import 'package:injectable/injectable.dart';
import 'package:kuro_chat/features/user/data/entity/user_entity.dart';

abstract class UserRemoteDataSource {
  Future<UserEntity> fetchCurrentUser();
}

@Injectable(as: UserRemoteDataSource)
class UserRemoteDataSourceImpl extends UserRemoteDataSource {
  @override
  Future<UserEntity> fetchCurrentUser() {
    throw UnimplementedError();
  }
}
