import 'package:firebase_database/firebase_database.dart';
import 'package:injectable/injectable.dart';
import 'package:kuro_chat/data/channel/entity/channel_entity.dart';
import 'package:kuro_chat/data/chat/datasource/chat_remote_datasource.dart';
import 'package:kuro_chat/data/user/datasource/user_local_datasource.dart';
import 'package:uuid/uuid.dart';

abstract class ChannelRemoteDataSource {
  Future<ChannelEntity> createChannel(String receiverId);

  Future<List<ChannelEntity>> getMyChannels();

  Future<ChannelEntity> getChannel(String channelId);
}

@Injectable(as: ChannelRemoteDataSource)
class ChannelRemoteDataSourceImpl extends ChannelRemoteDataSource {
  final UserLocalDataSource _userLocalDataSource;
  final ChatRemoteDataSource _chatRemoteDataSource;

  ChannelRemoteDataSourceImpl(
    this._userLocalDataSource,
    this._chatRemoteDataSource,
  );

  @override
  Future<ChannelEntity> createChannel(String receiverId) async {
    final generatedChannelId = const Uuid().v4();
    final ref = FirebaseDatabase.instance.ref('channels/$generatedChannelId');

    // TODO: check channel exist here

    final currentUserId = _userLocalDataSource.getCurrentUserFast().id;
    final newChannel = ChannelEntity(
      channelId: generatedChannelId,
      channelName: generatedChannelId,
      members: {receiverId: true, currentUserId: true},
    );
    await ref.set(newChannel.toJson());

    // Add channels to users/channels
    final userChannelValue = {generatedChannelId: true};
    FirebaseDatabase.instance
        .ref('users/channels/$currentUserId')
        .update(userChannelValue);
    FirebaseDatabase.instance
        .ref('users/channels/$receiverId')
        .update(userChannelValue);

    // Create chat
    await _chatRemoteDataSource.createChat(generatedChannelId);

    return newChannel;
  }

  @override
  Future<ChannelEntity> getChannel(String channelId) async {
    final ref = FirebaseDatabase.instance.ref('channels/$channelId');
    final refData = await ref.get() as Map<String, dynamic>;
    return ChannelEntity.fromJson(refData);
  }

  @override
  Future<List<ChannelEntity>> getMyChannels() async {
    final userChannelsRef = FirebaseDatabase.instance.ref('users/channels');
    final userChannelRefData =
        await userChannelsRef.get() as Map<String, dynamic>;
    final channels = <ChannelEntity>[];

    for (var channelId in userChannelRefData.keys) {
      final channel = await getChannel(channelId);
      channels.add(channel);
    }

    return channels;
  }
}
