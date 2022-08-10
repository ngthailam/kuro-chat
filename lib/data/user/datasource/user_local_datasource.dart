import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:kuro_chat/core/constant/shared_pref_constants.dart';
import 'package:kuro_chat/data/user/entity/user_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class UserLocalDataSource {
  Future<bool> saveCurrentUser(UserEntity user);

  Future<UserEntity?> getCurrentUser();

  Future<bool> deleteCurrentUser();
}

UserEntity? _user;
// Careful on usage
UserEntity? get currentUser => _user;
String get currentUserId => _user!.id;

@Injectable(as: UserLocalDataSource)
class UserLocalDataSourceImpl extends UserLocalDataSource {
  @override
  Future<bool> deleteCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(prefKeyCurrentUser);
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJsonString = prefs.getString(prefKeyCurrentUser);
    if (userJsonString?.isNotEmpty != true) return null;
    final userEntity = UserEntity.fromJson(jsonDecode(userJsonString!));
    // Save for RAM cache when opened app already logged in
    _user ??= userEntity;
    return userEntity;
  }

  @override
  Future<bool> saveCurrentUser(UserEntity user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJsonString = jsonEncode(user.toJson());
    return prefs.setString(prefKeyCurrentUser, userJsonString);
  }
}
