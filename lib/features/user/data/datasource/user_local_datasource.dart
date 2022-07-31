import 'package:injectable/injectable.dart';
import 'package:kuro_chat/features/user/data/entity/user_entity.dart';

abstract class UserLocalDataSource {
  Future saveCurrentUser(user);

  UserEntity getCurrentUser();
}

@Injectable(as: UserLocalDataSource)
class UserLocalDataSourceImpl extends UserLocalDataSource {
  @override
  UserEntity getCurrentUser() {
    throw UnimplementedError();
  }

  @override
  saveCurrentUser(user) {
    throw UnimplementedError();
  }
}
