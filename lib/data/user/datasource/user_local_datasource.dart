import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:kuro_chat/core/constant/shared_pref_constants.dart';
import 'package:kuro_chat/data/user/entity/user_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class UserLocalDataSource {
  Future<bool> saveCurrentUser(UserEntity user);

  Future<UserEntity?> getCurrentUser();

  Future<bool> deleteCurrentUser();

  UserEntity getCurrentUserFast();
}

UserEntity? _user;

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
    return UserEntity.fromJson(jsonDecode(userJsonString!));
  }

  @override
  Future<bool> saveCurrentUser(UserEntity user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJsonString = jsonEncode(user.toJson());
    return prefs.setString(prefKeyCurrentUser, userJsonString);
  }

  @override
  UserEntity getCurrentUserFast() {
    return _user!;
  }
}
