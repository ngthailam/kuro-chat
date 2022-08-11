import 'package:flutter/material.dart';
import 'package:kuro_chat/data/chat/entity/chat_message_entity.dart';
import 'package:kuro_chat/data/user/datasource/user_local_datasource.dart';
import 'package:kuro_chat/presentation/constant/color.dart';
import 'package:kuro_chat/presentation/page/chat/util/bubble_decoration_builder.dart';
import 'package:kuro_chat/presentation/util/date_util.dart';
import 'package:kuro_chat/presentation/widget/custom_circle_avatar.dart';

class ChatMessageTextArg {
  final bool isSender;
  final String senderName;
  final String text;
  final int sendTimeEpoch;
  final ChatPosition? position;

  ChatMessageTextArg({
    required this.isSender,
    required this.senderName,
    required this.text,
    required this.sendTimeEpoch,
    this.position,
  });

  factory ChatMessageTextArg.from({
    required ChatMessageEntity message,
    ChatPosition? position,
  }) {
    return ChatMessageTextArg(
      text: message.text,
      isSender: message.senderId == currentUserId,
      senderName: message.senderName,
      sendTimeEpoch: message.createTimeEpoch,
      position: position,
    );
  }
}

// TODO: change color sender name + chat background for chat target
class ChatMessageText extends StatelessWidget {
  const ChatMessageText({Key? key, required this.inputArg}) : super(key: key);

  final ChatMessageTextArg inputArg;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _prefix(),
        Expanded(child: _main()),
        inputArg.isSender
            ? const SizedBox(width: 16)
            : const SizedBox(width: 48),
      ],
    );
  }

  Widget _prefix() {
    if (inputArg.isSender) {
      return const SizedBox(width: 56);
    }

    if (inputArg.position == ChatPosition.standalone ||
        inputArg.position == ChatPosition.last) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: CustomCircleAvatar(
          imageUrl: null,
          name: inputArg.senderName,
        ),
      );
    }

    return const SizedBox(width: 56);
  }

  Widget _main() {
    return Align(
      alignment:
          inputArg.isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        decoration: BubbleDecorationBuilder(
          isSender: inputArg.isSender,
          position: inputArg.position ?? ChatPosition.standalone,
        ).build(),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        child: Column(
          crossAxisAlignment: inputArg.isSender
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            _senderName(),
            const SizedBox(height: 2),
            // TODO: add if text too short, then text + time is in 1 line
            Text(
              inputArg.text,
              style: const TextStyle(color: Colors.white),
            ),
            _sendTime()
          ],
        ),
      ),
    );
  }

  Widget _sendTime() {
    return Text(
      MyDateUtils.fromMillisEpochToTime(inputArg.sendTimeEpoch),
      textAlign: TextAlign.end,
      style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12),
    );
  }

  Widget _senderName() {
    final isPositionShowSender = inputArg.position == ChatPosition.first ||
        inputArg.position == ChatPosition.standalone;
    final shouldShowSenderName =
        !inputArg.isSender && inputArg.senderName.isNotEmpty;
    if (shouldShowSenderName && isPositionShowSender) {
      return Text(
        inputArg.senderName,
        style: const TextStyle(color: clrBlessHighList),
      );
    }
    return const SizedBox.shrink();
  }
}
