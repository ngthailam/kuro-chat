import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:injectable/injectable.dart';
import 'package:kuro_chat/data/meta_data/entity/meta_data_entity.dart';
import 'package:kuro_chat/data/user/datasource/user_local_datasource.dart';

final Map<String, UserStatus> userStatusMap = {};

abstract class MetaDataRepo {
  Future<bool> setUserStatus(UserStatus status);

  Stream<MetaDataEntity> observeMetaData();
}

// For optimizations
UserStatus? currentUserStatus;

@Injectable(as: MetaDataRepo)
class MetaDataRepoImpl extends MetaDataRepo {
  @override
  Stream<MetaDataEntity> observeMetaData() {
    final ref = FirebaseDatabase.instance.ref('meta');
    return ref.onValue.map((event) {
      final snapshot = event.snapshot;

      final metaData = MetaDataEntity.fromJson(
        Map<String, dynamic>.from(snapshot.value as Map),
      );

      // Update user status map
      userStatusMap.clear();
      userStatusMap.addAll(metaData.userStatus);

      return metaData;
    });
  }

  @override
  Future<bool> setUserStatus(UserStatus status) async {
    if (currentUser == null) return false;
    if (currentUserStatus == status) return true;
    final ref = FirebaseDatabase.instance.ref('meta/user_status');
    try {
      await ref.update({currentUserId: status.name});
      currentUserStatus = status;
      return true;
    } catch (e) {
      log('ERROR setUserStatus cannot set-$currentUserId as $status');
      return false;
    }
  }
}
