import 'package:flutter/material.dart';
import 'package:kuro_chat/data/chat/entity/chat_message_entity.dart';
import 'package:kuro_chat/presentation/page/chat/util/bubble_decoration_builder.dart';
import 'package:kuro_chat/presentation/page/chat/widget/chat_message_text.dart';

class ChatMessageListItemBuilder {
  final List<ChatMessageEntity> messages;
  final String currentUserId;

  ChatMessageListItemBuilder({
    required this.messages,
    required this.currentUserId,
  });

  Widget build(int index) {
    final messageItem = messages[index];
    switch (messageItem.type) {
      case chatTypeMessage:
        final inputArg = ChatMessageTextArg.from(
          message: messageItem,
          position: _resolvePosition(index),
        );
        return ChatMessageText(
          key: ValueKey(messageItem.createTimeEpoch),
          inputArg: inputArg,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  ChatPosition _resolvePosition(int index) {
    if (index == 0) {
      return ChatPosition.last;
    }

    if (index == messages.length - 1) {
      return ChatPosition.first;
    }

    final item = messages[index];
    final prevItem = messages[index - 1];
    final nextItem = messages[index + 1];

    ChatPosition position = ChatPosition.standalone;

    // TODO: add cache or add a variable to object to improve performance
    if (prevItem.senderId != item.senderId &&
        nextItem.senderId != item.senderId) {
      position = ChatPosition.standalone;
    } else if (prevItem.senderId == item.senderId &&
        nextItem.senderId == item.senderId) {
      position = ChatPosition.middle;
    } else if (prevItem.senderId != item.senderId) {
      // Since the list is layout top down
      // But real data is inserted bottom up
      position = ChatPosition.last;
    } else if (nextItem.senderId != item.senderId) {
      position = ChatPosition.first;
    }

    return position;
  }
}
