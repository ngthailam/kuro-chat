import 'package:firebase_database/firebase_database.dart';
import 'package:injectable/injectable.dart';
import 'package:kuro_chat/data/chat/entity/chat_entity.dart';
import 'package:kuro_chat/data/chat/entity/chat_message_entity.dart';
import 'package:kuro_chat/data/user/datasource/user_local_datasource.dart';

abstract class ChatRemoteDataSource {
  Future<ChatEntity> getChat(String channelId);

  Future<ChatEntity> createChat(String channelId);

  Future<bool> sendMessage(String channelId, String text);

  Future<bool> deleteMessage(String channelId, String messageId);
}

@Injectable(as: ChatRemoteDataSource)
class ChatRemoteDataSourceImpl extends ChatRemoteDataSource {
  final UserLocalDataSource _userLocalDataSource;

  ChatRemoteDataSourceImpl(this._userLocalDataSource);

  String get currentUserId {
    return _userLocalDataSource.getCurrentUserFast().id;
  }

  @override
  Future<ChatEntity> createChat(String channelId) async {
    final ref = FirebaseDatabase.instance.ref('chat/$channelId');

    final isChatExist = (await ref.get()).exists;
    if (isChatExist) {
      return Future.error(Exception('Chat with id=$channelId already exists'));
    }

    final newChatEntity = ChatEntity(
      channelId: channelId,
      messages: [],
    );
    await ref.set(newChatEntity);
    return newChatEntity;
  }

  @override
  Future<ChatEntity> getChat(String channelId) async {
    final ref = FirebaseDatabase.instance.ref('chat/$channelId');
    final refData = (await ref.get()) as Map<String, dynamic>;
    return ChatEntity.fromJson(refData);
  }

  @override
  Future<bool> sendMessage(String channelId, String text) async {
    final nowEpoch = DateTime.now().millisecondsSinceEpoch;
    final ref = FirebaseDatabase.instance.ref(
      'chat/$channelId/messages/$nowEpoch',
    );
    final newChatMessage = ChatMessageEntity(
      senderId: currentUserId,
      text: text,
      createTimeEpoch: nowEpoch,
    );

    // Add try catch
    await ref.update(newChatMessage.toJson());
    return true;
  }

  @override
  Future<bool> deleteMessage(String channelId, String messageId) async {
    final ref =
        FirebaseDatabase.instance.ref('chat/$channelId/messages/$messageId');

    try {
      await ref.remove();
      return true;
    } catch (e) {
      return false;
    }
  }
}
