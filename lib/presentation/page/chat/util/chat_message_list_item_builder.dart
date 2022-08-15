import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kuro_chat/data/chat/entity/chat_message_entity.dart';
import 'package:kuro_chat/presentation/constant/color.dart';
import 'package:kuro_chat/presentation/page/chat/util/bubble_decoration_builder.dart';
import 'package:kuro_chat/presentation/page/chat/widget/chat_message_text.dart';

class ChatMessageListItemBuilder {
  final List<ChatMessageEntity> messages;
  final String currentUserId;
  final bool isTargetTyping;

  ChatMessageListItemBuilder({
    required this.messages,
    required this.currentUserId,
    required this.isTargetTyping,
  });

  late int messageIndexOffset = isTargetTyping ? -1 : 0;

  Widget build({required int itemIndex}) {
    if (isTargetTyping && itemIndex == 0) {
      return _isTypingBox();
    }

    final messageIndex = itemIndex + messageIndexOffset;
    final messageItem = messages[messageIndex];

    switch (messageItem.type) {
      case chatTypeMessage:
        final inputArg = ChatMessageTextArg.from(
          message: messageItem,
          position: _resolvePosition(messageIndex),
        );
        return ChatMessageText(
          key: ValueKey(messageItem.createTimeEpoch),
          inputArg: inputArg,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _isTypingBox() {
    // TODO: add animation
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        height: 28,
        width: 56,
        decoration: BoxDecoration(
            color: clrGrayLighter, borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        margin: const EdgeInsets.only(left: 58),
        child: const Center(child: Icon(Icons.more_horiz, size: 24)),
      ),
    );
  }

  ChatPosition _resolvePosition(int index) {
    final item = messages[index];

    if (index == 0) {
      if (messages.length == 1) {
        return ChatPosition.standalone;
      }

      if (messages[index + 1].senderId == item.senderId) {
        return ChatPosition.last;
      } else {
        return ChatPosition.standalone;
      }
    }

    if (index == messages.length - 1) {
      if (messages[index - 1].senderId == item.senderId) {
        return ChatPosition.first;
      } else {
        return ChatPosition.standalone;
      }
    }

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
