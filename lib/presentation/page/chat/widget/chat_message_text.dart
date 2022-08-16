import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kuro_chat/data/chat/entity/chat_message_entity.dart';
import 'package:kuro_chat/data/user/datasource/user_local_datasource.dart';
import 'package:kuro_chat/presentation/page/chat/util/bubble_decoration_builder.dart';
import 'package:kuro_chat/presentation/util/date_util.dart';
import 'package:kuro_chat/presentation/widget/custom_circle_avatar.dart';

class ChatMessageTextArg {
  final bool isSender;
  final String senderName;
  final String text;
  final int sendTimeEpoch;
  // key: reaction text
  // value: reaction text count
  final Map<String, int> reactions;
  final ChatPosition? position;

  ChatMessageTextArg({
    required this.isSender,
    required this.senderName,
    required this.text,
    required this.sendTimeEpoch,
    required this.reactions,
    this.position,
  });

  factory ChatMessageTextArg.from({
    required ChatMessageEntity message,
    ChatPosition? position,
  }) {
    final Map<String, int> reactionCount = {};
    message.reactions.forEach((key, value) {
      reactionCount[key] = value.length;
    });

    return ChatMessageTextArg(
      text: message.text,
      isSender: message.senderId == currentUserId,
      senderName: message.senderName,
      sendTimeEpoch: message.createTimeEpoch,
      reactions: reactionCount,
      position: position,
    );
  }
}

class ChatMessageText extends StatelessWidget {
  const ChatMessageText({
    Key? key,
    required this.inputArg,
    this.onLongPressEnd,
  }) : super(key: key);

  final ChatMessageTextArg inputArg;
  final GestureLongPressEndCallback? onLongPressEnd;

  @override
  Widget build(BuildContext context) {
    if (inputArg.text == 'Indentity Bond') {
      print("ZZLL ${inputArg.text} - ${inputArg.reactions}");
    }
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
      child: GestureDetector(
        onTap: () {},
        onLongPressEnd: onLongPressEnd,
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
              if (inputArg.reactions.isNotEmpty) const SizedBox(height: 6),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _reactions(),
                  _sendTime(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _reactions() {
    if (inputArg.reactions.isEmpty) return const SizedBox.shrink();
    return Padding(
      // Offset padding with sendTime, only available if reactions is visible
      padding: const EdgeInsets.only(right: 8),
      child: Row(
        children: inputArg.reactions.entries
            .map((e) => _reaction(reactionText: e.key, count: e.value))
            .toList(),
      ),
    );
  }

  Widget _reaction({required String reactionText, required int count}) {
    var text = reactionText;
    if (count > 1) {
      text += ' $count';
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      margin: const EdgeInsets.only(right: 4),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Text(text),
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
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
