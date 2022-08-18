import 'package:flutter/material.dart';
import 'package:kuro_chat/data/chat/entity/chat_message_entity.dart';
import 'package:kuro_chat/presentation/page/chat/model/chat_message_item.dart';
import 'package:kuro_chat/presentation/page/chat/util/bubble_decoration_builder.dart';
import 'package:kuro_chat/presentation/page/chat/widget/chat_message_date_cutoff.dart';
import 'package:kuro_chat/presentation/page/chat/widget/chat_message_is_typing.dart';
import 'package:kuro_chat/presentation/page/chat/widget/chat_message_text.dart';
import 'package:kuro_chat/presentation/page/chat/widget/chat_message_unread_cutoff.dart';
import 'package:kuro_chat/presentation/util/date_util.dart';

// Should be a single instance inside the ChatPage scope
class ChatMessageListItemBuilder {
  final String currentUserId;

  List<ChatMessageEntity> messages = [];
  bool isTargetTyping = false;
  int? lastMessageReadTimeEpoch = 0;
  // TODO: use smt to keep the animation if posible
  // find other solution for this adhoc
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

    // [SECTION] TYPING
    if (isTargetTyping) {
      items.add(ChatItemTyping());
    }

    // Messages is from bottom up
    // -> index == 0 -> latest message (bottom)
    bool addedUnreadItem = false;
    for (var i = 0; i < messages.length; i++) {
      final ChatMessageEntity currentMessage = messages[i];

      // [SECTION] MESSAGE
      items.add(
        ChatItemText(
          messageEntity: currentMessage,
          chatPosition: _resolvePosition(i),
        ),
      );

      // [SECTION] DATE CUT-OFF
      final messageOnTop = i == messages.length - 1 ? null : messages[i + 1];
      // First message in chat (on top)
      // print(
      //     "ZZLL i=$i, text=${currentMessage.text}, isTopMost=${i == messages.length - 1}");
      if (i == messages.length - 1) {
        items.add(ChatItemDateCutoff(
          displayDate: MyDateUtils.toDayEEEE(currentMessage.createTimeEpoch),
        ));
      } else {
        final isNewDay = !MyDateUtils.isSameDate(
          messageOnTop!.createTimeEpoch,
          currentMessage.createTimeEpoch,
        );

        if (isNewDay) {
          items.add(
            ChatItemDateCutoff(
              displayDate:
                  MyDateUtils.toDayEEEE(currentMessage.createTimeEpoch),
            ),
          );
        }
      }

      // [SECTION] UNREAD CUT-OFF
      if (!addedUnreadItem &&
          lastMessageReadTimeEpoch != null &&
          loadCount < 2) {
        final isRead =
            currentMessage.createTimeEpoch <= lastMessageReadTimeEpoch!;
        if (!isRead && i != messages.length - 1) {
          final isNextItemRead =
              messages[i + 1].createTimeEpoch <= lastMessageReadTimeEpoch!;
          if (isNextItemRead) {
            items.add(ChatItemUnreadCutoff());
            addedUnreadItem = true;
          }
        }
      }
    }

    return items;
  }

  Widget buildItem({
    ChatMessageItem? item,
    GestureLongPressEndCallback? onLongPressEnd,
  }) {
    if (item is ChatItemTyping) {
      return const ChatMessageTyping(
        key: ValueKey('typing-chat-item'),
      );
    }

    if (item is ChatItemText) {
      if (item.messageEntity == null) return const SizedBox.shrink();
      return ChatMessageText(
        key: ValueKey(item.messageEntity!.createTimeEpoch),
        onLongPressEnd: onLongPressEnd,
        inputArg: ChatMessageTextArg.from(
          message: item.messageEntity!,
          position: item.chatPosition,
        ),
      );
    }

    if (item is ChatItemUnreadCutoff) {
      return const ChatMessageUnreadCutoff();
    }

    if (item is ChatItemDateCutoff) {
      return ChatMessageDateCutoffState(displayDate: item.displayDate);
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
