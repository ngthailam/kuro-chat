import 'package:firebase_database/firebase_database.dart';
import 'package:injectable/injectable.dart';

abstract class AuthRemoteDataSource {
  Future<bool> logIn(String userId);
}

@Injectable(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl extends AuthRemoteDataSource {
  @override
  Future<bool> logIn(String userId) async {
    final userRef = FirebaseDatabase.instance.ref('users/$userId');
    final user = await userRef.get();
    return user.exists;
  }
}
