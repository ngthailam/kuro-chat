import 'package:firebase_database/firebase_database.dart';
import 'package:injectable/injectable.dart';
import 'package:kuro_chat/data/chat/entity/chat_entity.dart';
import 'package:kuro_chat/data/chat/entity/chat_extra_data_entity.dart';
import 'package:kuro_chat/data/chat/entity/chat_message_entity.dart';
import 'package:kuro_chat/data/user/datasource/user_local_datasource.dart';

abstract class ChatRemoteDataSource {
  Stream<List<ChatMessageEntity>> observeMessages(String channelId);

  Stream<ChatExtraDataEntity> observeExtraData(String channelId);

  Future<ChatEntity> getChat(String channelId);

  Future<ChatEntity> createChat(String channelId);

  Future<ChatMessageEntity> sendMessage({
    required String channelId,
    required String text,
    required String senderId,
    required String senderName,
  });

  Future<bool> deleteMessage(String channelId, String messageId);

  Future<bool> setIsTyping(String channelId, bool isTyping);
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
  Stream<ChatExtraDataEntity> observeExtraData(String channelId) {
    final ref = FirebaseDatabase.instance.ref('chat/$channelId/extra');
    return ref.onValue.map((event) {
      final snapshot = event.snapshot;
      if (!snapshot.exists) {
        return const ChatExtraDataEntity();
      }
      final extraData = ChatExtraDataEntity.fromJson(
        Map<String, dynamic>.from(snapshot.value as Map),
      );

      return extraData;
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
  Future<ChatMessageEntity> sendMessage({
    required String channelId,
    required String text,
    required String senderId,
    required String senderName,
  }) async {
    if (channelId.isEmpty ||
        text.isEmpty ||
        senderId.isEmpty ||
        senderName.isEmpty) {
      throw Exception('Invalid arguments');
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
    return newChatMessage;
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

  @override
  Future<bool> setIsTyping(String channelId, bool isTyping) async {
    final ref = FirebaseDatabase.instance.ref('chat/$channelId/extra/isTyping');
    try {
      await ref.update({currentUserId: isTyping});
      return true;
    } catch (e) {
      return false;
    }
  }
}
