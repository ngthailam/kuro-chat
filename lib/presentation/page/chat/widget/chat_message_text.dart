import 'package:flutter/material.dart';
import 'package:kuro_chat/data/chat/entity/chat_message_entity.dart';
import 'package:kuro_chat/data/user/datasource/user_local_datasource.dart';
import 'package:kuro_chat/presentation/page/chat/util/bubble_decoration_builder.dart';
import 'package:kuro_chat/presentation/util/date_util.dart';
import 'package:kuro_chat/presentation/widget/custom_circle_avatar.dart';

class ChatMessageTextArg {
  final ChatMessageEntity chatMessage;
  final bool isSender;
  // key: reaction text
  // value: reaction text count
  final Map<String, int> reactions;
  final ChatPosition? position;

  ChatMessageTextArg({
    required this.chatMessage,
    required this.isSender,
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
      chatMessage: message,
      isSender: message.senderId == currentUserId,
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

  ChatMessageEntity get message => inputArg.chatMessage;

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
          name: message.senderName,
        ),
      );
    }

    return const SizedBox(width: 56);
  }

  Widget _main() {
    final boxDecoration = BubbleDecorationBuilder(
      isSender: inputArg.isSender,
      position: inputArg.position ?? ChatPosition.standalone,
    ).build();

    return Align(
      alignment:
          inputArg.isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: message.isReply
          ? Stack(
              alignment:
                  inputArg.isSender ? Alignment.topRight : Alignment.topLeft,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: _replyBubble(boxDecoration),
                ),
                Positioned(
                  bottom: 0,
                  child: _mainBubble(boxDecoration),
                ),
              ],
            )
          : _mainBubble(boxDecoration),
    );
  }

  Widget _replyBubble(BoxDecoration boxDecoration) {
    // TODO: opacity is a performance hit, take note to try to improve this
    return Opacity(
      opacity: 0.4,
      child: Container(
        decoration: boxDecoration,
        margin: EdgeInsets.only(
          left: inputArg.isSender ? 56 : 0,
          right: inputArg.isSender ? 0 : 56,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6)
            .copyWith(
                left: inputArg.isSender ? 28 : 14,
                right: inputArg.isSender ? 14 : 28),
        child: Column(
          crossAxisAlignment: inputArg.isSender
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            _senderName(),
            const SizedBox(height: 2),
            // TODO: add if text too short, then text + time is in 1 line
            Text(
              message.data?['text'] ?? '',
              style: const TextStyle(color: Colors.white),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '',
              textAlign: TextAlign.end,
              style:
                  TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _mainBubble(BoxDecoration boxDecoration) {
    return GestureDetector(
      onTap: () {
        // TODO: impl if needed
      },
      onLongPressEnd: onLongPressEnd,
      child: Container(
        decoration: boxDecoration,
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
              message.text,
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
      MyDateUtils.fromMillisEpochToTime(message.createTimeEpoch),
      textAlign: TextAlign.end,
      style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12),
    );
  }

  Widget _senderName() {
    final isPositionShowSender = inputArg.position == ChatPosition.first ||
        inputArg.position == ChatPosition.standalone;
    final shouldShowSenderName =
        !inputArg.isSender && message.senderName.isNotEmpty;
    if (shouldShowSenderName && isPositionShowSender) {
      return Text(
        message.senderName,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
