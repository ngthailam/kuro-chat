import 'package:injectable/injectable.dart';
import 'package:kuro_chat/data/lastmessage/datasource/last_message_local_datasource.dart';
import 'package:kuro_chat/data/lastmessage/datasource/last_message_remote_datasource.dart';

abstract class LastMessageRepo {
  void setLastRead(String channelId, int lastMessageCreateTimeEpoch);

  int? getByChannelId(String channelId);

  Future persistData();

  Future populdateData();

  Future clear();
}

@Injectable(as: LastMessageRepo)
class LastMessageRepoImpl extends LastMessageRepo {
  final LastMessageLocalDataSource _lastMessageLocalDataSource;
  final LastMessageRemoteDataSource _lastMessageRemoteDataSource;

  LastMessageRepoImpl(
      this._lastMessageLocalDataSource, this._lastMessageRemoteDataSource);

  @override
  int? getByChannelId(String channelId) {
    return _lastMessageLocalDataSource.getByChannelId(channelId);
  }

  @override
  Future persistData() async {
    final localLastMessageData = _lastMessageLocalDataSource.getAll();
    // TODO: optimize by seeting a flag when data change,
    // and only call this line if that flag is true
    await _lastMessageRemoteDataSource.updateUserLastMessage(
        lastMessageRead: localLastMessageData);
    return _lastMessageLocalDataSource.persist();
  }

  @override
  Future populdateData() async {
    final lastMessageData =
        await _lastMessageRemoteDataSource.getUserLastMessage();
    await _lastMessageLocalDataSource.save(
        lastMessageReadData: lastMessageData);
    return _lastMessageLocalDataSource.populateRamCache();
  }

  @override
  void setLastRead(String channelId, int lastMessageCreateTimeEpoch) {
    return _lastMessageLocalDataSource
        .update(lastMessageReadData: {channelId: lastMessageCreateTimeEpoch});
  }

  @override
  Future clear() {
    return _lastMessageLocalDataSource.clear();
  }
}
