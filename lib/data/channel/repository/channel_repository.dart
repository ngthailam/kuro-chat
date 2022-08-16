import 'package:injectable/injectable.dart';
import 'package:kuro_chat/data/channel/datasource/channel_local_datasource.dart';
import 'package:kuro_chat/data/channel/datasource/channel_remote_datasource.dart';
import 'package:kuro_chat/data/channel/entity/channel_entity.dart';
import 'package:kuro_chat/data/user/entity/user_entity.dart';

abstract class ChannelRepo {
  Future<ChannelEntity> createChannel({
    required List<UserEntity> users,
    String? channelName,
  });

  Future<List<ChannelEntity>> getMyChannels();

  Future<ChannelEntity?> getChannel(String channelId);

  Future<List<ChannelEntity>> findChannel(String channelId);
}

@Injectable(as: ChannelRepo)
class ChannelRepoImpl extends ChannelRepo {
  // ignore: unused_field
  final ChannelLocalDataSource _channelLocalDataSource;
  final ChannelRemoteDataSource _channelRemoteDataSource;

  ChannelRepoImpl(
    this._channelLocalDataSource,
    this._channelRemoteDataSource,
  );

  @override
  Future<ChannelEntity> createChannel({
    required List<UserEntity> users,
    String? channelName,
  }) {
    return _channelRemoteDataSource.createChannel(
      users: users,
      channelName: channelName,
    );
  }

  @override
  Future<ChannelEntity?> getChannel(String channelId) {
    return _channelRemoteDataSource.getChannel(channelId);
  }

  @override
  Future<List<ChannelEntity>> getMyChannels() {
    return _channelRemoteDataSource.getMyChannels();
  }

  @override
  Future<List<ChannelEntity>> findChannel(String channelId) {
    return _channelRemoteDataSource.findChannel(channelId);
  }
}
