import 'package:injectable/injectable.dart';
import 'package:kuro_chat/data/lastmessage/datasource/last_message_local_datasource.dart';
import 'package:kuro_chat/data/lastmessage/datasource/last_message_remote_datasource.dart';

abstract class LastMessageRepo {
  Future setLastRead(String channelId, int lastMessageCreateTimeEpoch);

  int? getByChannelId(String channelId);

  Future persistData();

  Future populdateData();

  Future clear();
}

bool _isPopulated = false;

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
    return _lastMessageRemoteDataSource.updateUserLastMessage(
      lastMessageRead: localLastMessageData,
    );
  }

  @override
  Future populdateData() async {
    if (_isPopulated) return;
    _isPopulated = true;
    final lastMessageData =
        await _lastMessageRemoteDataSource.getUserLastMessage();
    await _lastMessageLocalDataSource.save(
        lastMessageReadData: lastMessageData);
    return _lastMessageLocalDataSource.populateRamFromDb();
  }

  @override
  Future setLastRead(String channelId, int lastMessageCreateTimeEpoch) {
    return _lastMessageLocalDataSource.save(
      lastMessageReadData: {channelId: lastMessageCreateTimeEpoch},
    );
  }

  @override
  Future clear() {
    return _lastMessageLocalDataSource.clear();
  }
}
