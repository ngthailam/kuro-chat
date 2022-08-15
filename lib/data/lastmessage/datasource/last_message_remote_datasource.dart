import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:injectable/injectable.dart';
import 'package:kuro_chat/data/channel/entity/channel_entity.dart';
import 'package:kuro_chat/data/meta_data/repository/meta_data_repo.dart';
import 'package:kuro_chat/data/user/datasource/user_local_datasource.dart';

abstract class LastMessageRemoteDataSource {
  // Update for Channel object
  Future updateChannelLastMessage({
    required String channelId,
    required String text,
    required int createTimeEpoch,
  });

  // key: channelId
  // int: last message createTimeEpoch
  Future<Map<String, int>> getUserLastMessage();

  Future<Map<String, int>> updateUserLastMessage({
    required Map<String, int> lastMessageRead,
  });
}

@Injectable(as: LastMessageRemoteDataSource)
class LastMessageRemoteDataSourceImpl extends LastMessageRemoteDataSource {
  @override
  Future updateChannelLastMessage({
    required String channelId,
    required String text,
    required int createTimeEpoch,
  }) {
    final lastMessage =
        LastMessageEntity(createTimeEpoch: createTimeEpoch, text: text);
    return FirebaseFirestore.instance
        .collection('channels')
        .doc(channelId)
        .update({'lastMessage': lastMessage.toJson()});
  }

  @override
  Future<Map<String, int>> getUserLastMessage() async {
    final ref =
        FirebaseDatabase.instance.ref('users/$currentUserId/lastMessage');
    final snapshot = await ref.get();
    if (!snapshot.exists) {
      return {};
    }

    final Map<String, int> resultMap = {};
    for (var data in snapshot.children) {
      if (data.exists) {
        resultMap.addAll(Map<String, int>.from(data.value as Map));
      }
    }

    return resultMap;
  }

  @override
  Future<Map<String, int>> updateUserLastMessage({
    required Map<String, int> lastMessageRead,
  }) async {
    final ref =
        FirebaseDatabase.instance.ref('users/$currentUserId/lastMessage');
    await ref.update(lastMessageRead);

    return lastMessageRead;
  }
}
