import 'package:flutter/material.dart';
import 'package:kuro_chat/data/chat/entity/chat_message_entity.dart';
import 'package:kuro_chat/presentation/page/chat/model/chat_message_item.dart';
import 'package:kuro_chat/presentation/page/chat/util/bubble_decoration_builder.dart';
import 'package:kuro_chat/presentation/page/chat/widget/chat_message_is_typing.dart';
import 'package:kuro_chat/presentation/page/chat/widget/chat_message_text.dart';
import 'package:kuro_chat/presentation/page/chat/widget/chat_message_unread_cutoff.dart';

// Should be a single instance inside the ChatPage scope
class ChatMessageListItemBuilder {
  final String currentUserId;

  List<ChatMessageEntity> messages = [];
  bool isTargetTyping = false;
  int? lastMessageReadTimeEpoch = 0;
  // TODO: use smt to keep the animation if posible
  int loadCount = 0;

  ChatMessageListItemBuilder({
    required this.currentUserId,
  });

  void setMessages(List<ChatMessageEntity> messages) {
    this.messages = messages;
    loadCount++;
  }

  void setIsTargetTyping(bool isTargetTyping) {
    this.isTargetTyping = isTargetTyping;
  }

  void setLastMessageReadTimeEpoch(int? lastMessageReadTimeEpoch) {
    this.lastMessageReadTimeEpoch = lastMessageReadTimeEpoch;
  }

  List<ChatMessageItem> generateItems() {
    final List<ChatMessageItem> items = [];

    if (isTargetTyping) {
      items.add(ChatItemTyping());
    }

    bool addedUnreadItem = false;
    for (var i = 0; i < messages.length; i++) {
      final messageEntity = messages[i];

      // Adding unread cut off
      if (lastMessageReadTimeEpoch != null && loadCount < 2) {
        final isRead =
            messageEntity.createTimeEpoch <= lastMessageReadTimeEpoch!;
        if (!addedUnreadItem && !isRead && i != messages.length - 1) {
          final isPreviousItemRead =
              messages[i + 1].createTimeEpoch <= lastMessageReadTimeEpoch!;
          if (isPreviousItemRead) {
            items.add(ChatItemUnreadCutoff());
            addedUnreadItem = true;
          }
        }
      }

      // Add message text item
      items.add(
        ChatItemText(
          messageEntity: messageEntity,
          chatPosition: _resolvePosition(i),
        ),
      );
    }

    return items;
  }

  Widget buildItem({ChatMessageItem? item}) {
    if (item is ChatItemTyping) {
      return const ChatMessageTyping(
        key: ValueKey('typing-chat-item'),
      );
    }

    if (item is ChatItemText) {
      if (item.messageEntity == null) return const SizedBox.shrink();
      return ChatMessageText(
        key: ValueKey(item.messageEntity!.createTimeEpoch),
        inputArg: ChatMessageTextArg.from(
          message: item.messageEntity!,
          position: item.chatPosition,
        ),
      );
    }

    if (item is ChatItemUnreadCutoff) {
      return const ChatMessageUnreadCutoff();
    }

    return const SizedBox.shrink();
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
