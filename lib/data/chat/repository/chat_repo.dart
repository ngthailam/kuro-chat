import 'package:injectable/injectable.dart';
import 'package:kuro_chat/data/chat/datasource/chat_local_datasource.dart';
import 'package:kuro_chat/data/chat/datasource/chat_remote_datasource.dart';
import 'package:kuro_chat/data/chat/entity/chat_entity.dart';
import 'package:kuro_chat/data/chat/entity/chat_message_entity.dart';
import 'package:kuro_chat/data/user/datasource/user_local_datasource.dart';

abstract class ChatRepo {
  Future<ChatEntity> getChat(String channelId);

  Future sendMessage(String channelId, String text);

  Stream<List<ChatMessageEntity>> observeMessages(String channelId);
}

@Injectable(as: ChatRepo)
class ChatRepoImpl extends ChatRepo {
  final ChatLocalDataSource _chatLocalDataSource;
  final ChatRemoteDataSource _chatRemoteDataSource;

  ChatRepoImpl(
    this._chatLocalDataSource,
    this._chatRemoteDataSource,
  );

  @override
  Future<ChatEntity> getChat(String channelId) {
    return _chatRemoteDataSource.getChat(channelId);
  }

  @override
  Future sendMessage(String channelId, String text) {
    return _chatRemoteDataSource.sendMessage(
      channelId: channelId,
      text: text,
      senderId: currentUser!.id,
      senderName: currentUser!.id // TODO: update to user name when has name
    );
  }

  @override
  Stream<List<ChatMessageEntity>> observeMessages(String channelId) {
    return _chatRemoteDataSource.observeMessages(channelId);
  }
}
