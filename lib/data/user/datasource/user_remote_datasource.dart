import 'package:firebase_database/firebase_database.dart';
import 'package:injectable/injectable.dart';
import 'package:kuro_chat/data/user/entity/user_entity.dart';

abstract class UserRemoteDataSource {
  Future<UserEntity?> fetchUser(String userId);

  Future<void> createUser(String userId);
}

@Injectable(as: UserRemoteDataSource)
class UserRemoteDataSourceImpl extends UserRemoteDataSource {
  @override
  Future<UserEntity?> fetchUser(String userId) async {
    final ref = FirebaseDatabase.instance.ref('/users/$userId');
    final data = await ref.get();
    if (data.exists) {
      return UserEntity.fromJson(data.value as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  @override
  Future<void> createUser(String userId) async {
    final ref = FirebaseDatabase.instance.ref('/users/$userId');
    await ref.set(UserEntity(id: userId).toJson());
    return;
  }
}
