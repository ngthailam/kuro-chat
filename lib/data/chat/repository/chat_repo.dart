import 'package:injectable/injectable.dart';
import 'package:kuro_chat/data/channel/datasource/channel_remote_datasource.dart';
import 'package:kuro_chat/data/chat/datasource/chat_local_datasource.dart';
import 'package:kuro_chat/data/chat/datasource/chat_remote_datasource.dart';
import 'package:kuro_chat/data/chat/entity/chat_entity.dart';
import 'package:kuro_chat/data/chat/entity/chat_extra_data_entity.dart';
import 'package:kuro_chat/data/chat/entity/chat_message_entity.dart';
import 'package:kuro_chat/data/user/datasource/user_local_datasource.dart';

abstract class ChatRepo {
  Future<ChatEntity> getChat(String channelId);

  Future sendMessage(String channelId, String text);

  Stream<List<ChatMessageEntity>> observeMessages(String channelId);

  Stream<ChatExtraDataEntity> observeExtraData(String channelId);

  Future<bool> setIsTyping(String channelId, bool isTyping);
}

@Injectable(as: ChatRepo)
class ChatRepoImpl extends ChatRepo {
  final ChatLocalDataSource _chatLocalDataSource;
  final ChatRemoteDataSource _chatRemoteDataSource;
  final ChannelRemoteDataSource _channelRemoteDataSource;

  ChatRepoImpl(
    this._chatLocalDataSource,
    this._chatRemoteDataSource,
    this._channelRemoteDataSource,
  );

  @override
  Future<ChatEntity> getChat(String channelId) {
    return _chatRemoteDataSource.getChat(channelId);
  }

  @override
  Future sendMessage(String channelId, String text) async {
    try {
      final message = await _chatRemoteDataSource.sendMessage(
        channelId: channelId,
        text: text,
        senderId: currentUser!.id,
        senderName: currentUser!.name,
      );
      _channelRemoteDataSource.updateLastMessage(
        channelId: channelId,
        text: text,
        createTimeEpoch: message.createTimeEpoch,
      );
    } catch (e) {
      return;
    }
  }

  @override
  Stream<List<ChatMessageEntity>> observeMessages(String channelId) {
    return _chatRemoteDataSource.observeMessages(channelId);
  }

  @override
  Stream<ChatExtraDataEntity> observeExtraData(String channelId) {
    return _chatRemoteDataSource.observeExtraData(channelId);
  }

  @override
  Future<bool> setIsTyping(String channelId, bool isTyping) async {
    final isTypingLocal = _chatLocalDataSource.getIsTyping(channelId);
    if (isTyping == isTypingLocal) {
      return true;
    }

    await _chatRemoteDataSource.setIsTyping(channelId, isTyping);
    _chatLocalDataSource.setIsTyping(channelId, isTyping);

    return true;
  }
}
