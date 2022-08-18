import 'package:flutter/material.dart';

class ChatMessageDateCutoffState extends StatelessWidget {
  const ChatMessageDateCutoffState({Key? key, required this.displayDate})
      : super(key: key);

  final String displayDate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 8),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          displayDate,
          style: const TextStyle(color: Colors.black54),
        ),
      ),
    );
  }
}
