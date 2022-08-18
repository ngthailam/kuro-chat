import 'package:injectable/injectable.dart';
import 'package:kuro_chat/data/chat/datasource/chat_local_datasource.dart';
import 'package:kuro_chat/data/chat/datasource/chat_remote_datasource.dart';
import 'package:kuro_chat/data/chat/entity/chat_entity.dart';
import 'package:kuro_chat/data/chat/entity/chat_extra_data_entity.dart';
import 'package:kuro_chat/data/chat/entity/chat_message_entity.dart';
import 'package:kuro_chat/data/lastmessage/datasource/last_message_remote_datasource.dart';
import 'package:kuro_chat/data/user/datasource/user_local_datasource.dart';

abstract class ChatRepo {
  Future<ChatEntity> getChat(String channelId);

  Future sendMessage(String channelId, String text);

  Stream<List<ChatMessageEntity>> observeMessages(String channelId);

  Stream<ChatExtraDataEntity> observeExtraData(String channelId);

  Future<bool> setIsTyping(String channelId, bool isTyping);

  Future updateReaction({
    required String channelId,
    required String messageId,
    required String reactionText,
    required bool isAdd,
  });

  Future deleteMessage({
    required String channelId,
    required String messageId,
  });

  Future<List<ChatMessageEntity>> getMessages({
    required String channelId,
    required String oldestMessageId,
  });
}

@Injectable(as: ChatRepo)
class ChatRepoImpl extends ChatRepo {
  final ChatLocalDataSource _chatLocalDataSource;
  final ChatRemoteDataSource _chatRemoteDataSource;
  final LastMessageRemoteDataSource _lastMessageRemoteDataSource;

  ChatRepoImpl(
    this._chatLocalDataSource,
    this._chatRemoteDataSource,
    this._lastMessageRemoteDataSource,
  );

  @override
  Future<List<ChatMessageEntity>> getMessages(
      {required String channelId, required String oldestMessageId}) {
    return _chatRemoteDataSource.getMessages(
        channelId: channelId, oldestMessageId: oldestMessageId);
  }

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
      _lastMessageRemoteDataSource.updateChannelLastMessage(
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

  @override
  Future updateReaction({
    required String channelId,
    required String messageId,
    required String reactionText,
    required bool isAdd,
  }) {
    return _chatRemoteDataSource.updateReaction(
      channelId: channelId,
      messageId: messageId,
      reactionText: reactionText,
      isAdd: isAdd,
    );
  }

  @override
  Future deleteMessage({required String channelId, required String messageId}) {
    return _chatRemoteDataSource.deleteMessage(
        channelId: channelId, messageId: messageId);
  }
}
