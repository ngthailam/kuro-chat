import 'package:firebase_database/firebase_database.dart';
import 'package:injectable/injectable.dart';
import 'package:kuro_chat/data/chat/entity/chat_entity.dart';
import 'package:kuro_chat/data/chat/entity/chat_message_entity.dart';

abstract class ChatRemoteDataSource {
  Stream<List<ChatMessageEntity>> observeMessages(String channelId);

  Future<ChatEntity> getChat(String channelId);

  Future<ChatEntity> createChat(String channelId);

  Future<bool> sendMessage({
    required String channelId,
    required String text,
    required String senderId,
    required String senderName,
  });

  Future<bool> deleteMessage(String channelId, String messageId);
}

@Injectable(as: ChatRemoteDataSource)
class ChatRemoteDataSourceImpl extends ChatRemoteDataSource {
  @override
  Stream<List<ChatMessageEntity>> observeMessages(String channelId) {
    final ref = FirebaseDatabase.instance.ref('chat/$channelId/messages');
    return ref.onValue.map((event) {
      final snapshotList = event.snapshot.children;
      final List<ChatMessageEntity> messages = [];
      for (var data in snapshotList) {
        if (data.exists) {
          final msg = ChatMessageEntity.fromJson(
            Map<String, dynamic>.from(data.value as Map),
          );
          messages.add(msg);
        }
      }

      return messages
        ..sort((a, b) => b.createTimeEpoch.compareTo(a.createTimeEpoch));
    });
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
    await ref.set(newChatEntity.toJson());
    return newChatEntity;
  }

  @override
  Future<ChatEntity> getChat(String channelId) async {
    final ref = FirebaseDatabase.instance.ref('chat/$channelId');
    final refData = (await ref.get()) as Map<String, dynamic>;
    return ChatEntity.fromJson(refData);
  }

  @override
  Future<bool> sendMessage({
    required String channelId,
    required String text,
    required String senderId,
    required String senderName,
  }) async {
    if (channelId.isEmpty ||
        text.isEmpty ||
        senderId.isEmpty ||
        senderName.isEmpty) {
      return false;
    }

    final nowEpoch = DateTime.now().millisecondsSinceEpoch;
    final ref = FirebaseDatabase.instance.ref(
      'chat/$channelId/messages/$nowEpoch',
    );
    final newChatMessage = ChatMessageEntity(
        senderId: senderId,
        senderName: senderName,
        text: text,
        createTimeEpoch: nowEpoch,
        type: chatTypeMessage);

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
