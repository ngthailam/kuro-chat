import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:kuro_chat/data/channel/entity/channel_entity.dart';
import 'package:kuro_chat/data/chat/datasource/chat_remote_datasource.dart';
import 'package:kuro_chat/data/chat/entity/chat_message_entity.dart';
import 'package:kuro_chat/data/user/datasource/user_local_datasource.dart';
import 'package:kuro_chat/data/user/entity/user_entity.dart';
import 'package:uuid/uuid.dart';

abstract class ChannelRemoteDataSource {
  Future<ChannelEntity> createChannel(UserEntity receiver);

  Future<List<ChannelEntity>> getMyChannels();

  Future<ChannelEntity?> getChannel(String channelId);

  Future<List<ChannelEntity>> findChannel(String channelId);

  Future updateLastMessage({
    required String channelId,
    required String text,
    required int createTimeEpoch,
  });
}

@Injectable(as: ChannelRemoteDataSource)
class ChannelRemoteDataSourceImpl extends ChannelRemoteDataSource {
  final ChatRemoteDataSource _chatRemoteDataSource;

  ChannelRemoteDataSourceImpl(
    this._chatRemoteDataSource,
  );

  @override
  Future<ChannelEntity> createChannel(UserEntity receiver) async {
    final generatedChannelId = const Uuid().v4();
    final existingChannelRef = FirebaseFirestore.instance
        .collection('channels')
        .where('members.${receiver.id}', isEqualTo: true);
    final snapshot = (await existingChannelRef.get()).docs;

    if (snapshot.isNotEmpty) {
      throw Exception('Channel already exist');
    }

    // Save chat in data store
    final newChannel = ChannelEntity(
      channelId: generatedChannelId,
      channelName: receiver.name,
      members: {receiver.id: true, currentUserId: true},
    );
    await FirebaseFirestore.instance
        .collection('channels')
        .doc(generatedChannelId)
        .set(newChannel.toJson());

    // Create chat
    await _chatRemoteDataSource.createChat(generatedChannelId);

    return newChannel;
  }

  @override
  Future<ChannelEntity?> getChannel(String channelId) async {
    final ref =
        FirebaseFirestore.instance.collection('channels').doc(channelId);
    final snapshot = await ref.get();
    if (snapshot.exists) {
      return ChannelEntity.fromJson(snapshot.data()!);
    } else {
      return null;
    }
  }

  @override
  Future<List<ChannelEntity>> getMyChannels() async {
    final userChannelsRef = FirebaseFirestore.instance
        .collection('channels')
        .where('members.$currentUserId', isEqualTo: true);
    final snapshot = await userChannelsRef.get();
    final channels = <ChannelEntity>[];

    for (var doc in snapshot.docs) {
      if (doc.exists) {
        channels.add(ChannelEntity.fromJson(doc.data()));
      }
    }

    return channels;
  }

  @override
  Future<List<ChannelEntity>> findChannel(String channelId) async {
    final ref = FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: channelId);

    final refData = await ref.get();
    if (refData.docs.isEmpty) {
      return [];
    }

    final channels = <ChannelEntity>[];

    final docSnapshotList = refData.docs;
    for (var snapshot in docSnapshotList) {
      if (snapshot.exists) {
        channels.add(ChannelEntity.fromJson(snapshot.data()));
      }
    }

    return channels;
  }

  @override
  Future updateLastMessage({
    required String channelId,
    required String text,
    required int createTimeEpoch,
  }) {
    final lastMessage =
        ChannelLastMessageEntity(createTimeEpoch: createTimeEpoch, text: text);
    return FirebaseFirestore.instance
        .collection('channels')
        .doc(channelId)
        .update({'lastMessage': lastMessage.toJson()});
  }
}
