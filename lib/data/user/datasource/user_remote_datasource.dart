import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:kuro_chat/data/user/datasource/user_local_datasource.dart';
import 'package:kuro_chat/data/user/entity/user_entity.dart';
import 'package:uuid/uuid.dart';

abstract class UserRemoteDataSource {
  Future<UserEntity?> fetchUser(String userId);

  Future<UserEntity?> fetchUserByName(String userName);

  Future<void> createUser(String userName);

  Future<List<UserEntity>> fetchByName(String name);

  Future<bool> setUserStatus(UserStatus status);
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
  Future<UserEntity?> fetchUserByName(String userName) async {
    final docRef = firestore.collection('users').where(
          'name',
          isEqualTo: userName,
        );
    final doc = await docRef.get();
    if (doc.docs.isNotEmpty) {
      // TODO: will need to fix this
      final userSnapshot = doc.docs[0];
      return UserEntity.fromJson(userSnapshot.data());
    } else {
      return null;
    }
  }

  @override
  Future<void> createUser(String userName) async {
    try {
      final newUser = UserEntity(
        id: const Uuid().v4(),
        name: userName,
      );
      await firestore.collection('users').doc(newUser.id).set(newUser.toJson());
      log('add user ${newUser.toJson()} success');
    } catch (e) {
      log('create user error $e');
    }
    return;
  }

  @override
  Future<List<UserEntity>> fetchByName(String name) async {
    final docRef = firestore.collection('users').where('name', isEqualTo: name);
    final snapshot = await docRef.get();
    final results = <UserEntity>[];
    for (var snapshot in snapshot.docs) {
      if (snapshot.exists) {
        results.add(UserEntity.fromJson(snapshot.data()));
      }
    }

    return results;
  }

  @override
  Future<bool> setUserStatus(UserStatus status) async {
    try {
      await firestore
          .collection('users')
          .doc(currentUserId)
          .update({'status': status.name});
      log('set status ${status.name} successfulyy');
      return true;
    } catch (e) {
      log('set status error $e');
      return false;
    }
  }
}
