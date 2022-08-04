import 'package:injectable/injectable.dart';
import 'package:kuro_chat/data/chat/datasource/chat_local_datasource.dart';
import 'package:kuro_chat/data/chat/datasource/chat_remote_datasource.dart';
import 'package:kuro_chat/data/chat/entity/chat_entity.dart';

abstract class ChatRepo {
  Future<ChatEntity> getChat(String channelId);
}

@Injectable(as: ChatRepo)
class ChatRepoImpl extends ChatRepo {
  final ChatLocalDataSource _chatLocalDataSource;
  final ChatRemoteDataSource _chatRemoteDataSource;

  ChatRepoImpl(this._chatLocalDataSource, this._chatRemoteDataSource);

  @override
  Future<ChatEntity> getChat(String channelId) {
    return _chatRemoteDataSource.getChat(channelId);
  }
}
