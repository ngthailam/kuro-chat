import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:kuro_chat/data/user/entity/user_entity.dart';

abstract class UserRemoteDataSource {
  Future<UserEntity?> fetchUser(String userId);

  Future<void> createUser(String userId);
}

@Injectable(as: UserRemoteDataSource)
class UserRemoteDataSourceImpl extends UserRemoteDataSource {
  FirebaseFirestore get firestore => FirebaseFirestore.instance;

  @override
  Future<UserEntity?> fetchUser(String userId) async {
    final docRef = firestore.collection('users').doc(userId);
    final doc = await docRef.get();
    if (doc.exists) {
      return UserEntity.fromJson(doc.data() as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  @override
  Future<void> createUser(String userId) async {
    try {
      final newUser = UserEntity(id: userId).toJson();
      await firestore.collection('users').doc(userId).set(newUser);
      log('add user $userId success');
    } catch (e) {
      log('create user error $e');
    }
    return;
  }
}
