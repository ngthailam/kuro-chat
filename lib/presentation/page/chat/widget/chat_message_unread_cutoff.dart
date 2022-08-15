import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:kuro_chat/presentation/constant/color.dart';
import 'package:kuro_chat/presentation/page/chat/chat_controller.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ChatMessageUnreadCutoff extends StatefulWidget {
  const ChatMessageUnreadCutoff({Key? key}) : super(key: key);

  @override
  State<ChatMessageUnreadCutoff> createState() =>
      _ChatMessageUnreadCutoffState();
}

class _ChatMessageUnreadCutoffState extends State<ChatMessageUnreadCutoff> {
  Widget? _animatedWidget;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  // TODO: add animation auto close
  // if do this, on scrolling -> may appear again
  @override
  Widget build(BuildContext context) {
    return _unreadCutoff();
  }

  Widget _unreadCutoff() {
    return VisibilityDetector(
      key: const Key('unread-chat-item'),
      onVisibilityChanged: (visibilityInfo) {
        final visiblePercentage = visibilityInfo.visibleFraction * 100;
        if (visiblePercentage == 100.0 && _animatedWidget is! SizedBox) {
          Get.find<ChatController>().setHasReadAllUnreads();
          Timer(const Duration(seconds: 3), () {
            if (mounted) {
              setState(() {
                _animatedWidget = const SizedBox.shrink();
              });
            }
          });
        }
      },
      child: Row(
        children: [
          _dividerLine(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Unread messages',
              style: TextStyle(color: clrLipStick),
            ),
          ),
          _dividerLine(),
        ],
      ),
    );
  }

  Widget _dividerLine() {
    return const Expanded(
      child: Divider(
        thickness: 1,
        height: 1,
        color: clrLipStick,
      ),
    );
  }
}
