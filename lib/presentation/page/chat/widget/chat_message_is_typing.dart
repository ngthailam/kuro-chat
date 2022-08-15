import 'package:flutter/material.dart';
import 'package:kuro_chat/presentation/constant/color.dart';

class ChatMessageTyping extends StatelessWidget {
  const ChatMessageTyping({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        height: 28,
        width: 56,
        decoration: BoxDecoration(
          color: clrGrayLighter,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        margin: const EdgeInsets.only(left: 58),
        child: const Center(
          child: Icon(Icons.more_horiz, size: 24),
        ),
      ),
    );
  }
}
