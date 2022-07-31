import 'package:injectable/injectable.dart';

abstract class AuthRemoteDataSource {
  Future<bool> logIn(String userId);
}

@Injectable(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl extends AuthRemoteDataSource {
  @override
  Future<bool> logIn(String userId) async {
    return true;
  }
}
