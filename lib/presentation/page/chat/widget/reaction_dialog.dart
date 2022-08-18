import 'package:flutter/material.dart';
import 'package:kuro_chat/data/chat/entity/chat_message_entity.dart';
import 'package:kuro_chat/data/user/datasource/user_local_datasource.dart';
import 'package:kuro_chat/presentation/constant/color.dart';

// TODO: use classes and shits for output
typedef ReactionDialogCallback = Function({
  String? reactionText,
  ChatMessageEntity? chatMessage,
  required ChatMessageOptions option,
});

enum ChatMessageOptions {
  reply,
  react,
  copy,
  delete,
}

class ChatMessageOptionDialog extends StatelessWidget {
  const ChatMessageOptionDialog({
    Key? key,
    required this.dimiss,
    required this.position,
    required this.reactions,
    required this.callback,
    required this.chatMessage,
  }) : super(key: key);

  final VoidCallback dimiss;
  final Offset position;
  final List<String> reactions;
  final ChatMessageEntity chatMessage;
  final ReactionDialogCallback callback;

  bool get isSender => chatMessage.senderId == currentUserId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: dimiss,
      child: Material(
        color: Colors.black.withOpacity(0.1),
        child: Stack(
          children: [
            Positioned(
              left: position.dx - 50,
              top: position.dy - 50,
              child: _reactions(),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: _messageOptions(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _reactions() {
    if (isSender) {
      return const SizedBox.shrink();
    }
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      width: 202,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 8,
        ),
        child: Row(
          children: reactions
              .map(
                (e) => _reactionIcon(
                  reactionText: e,
                  messageId: chatMessage.id,
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  // Options like: edit, delete, ... things like that
  Widget _messageOptions() {
    return Container(
      height: 80,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _buildOptions(),
      ),
    );
  }

  List<Widget> _buildOptions() {
    return [
      _optionIconAndName(
          iconData: Icons.reply,
          text: 'Reply',
          onPressed: () {
            dimiss();
            callback(
              option: ChatMessageOptions.reply,
              chatMessage: chatMessage,
            );
          }),
      _optionIconAndName(
          iconData: Icons.copy,
          text: 'Copy',
          onPressed: () {
            dimiss();
            // TODO: maybe copy here immediately ?
            callback(
              option: ChatMessageOptions.copy,
              chatMessage: chatMessage,
            );
          }),
      if (isSender)
        _optionIconAndName(
          iconData: Icons.delete,
          text: 'Delete',
          onPressed: () {
            dimiss();
            callback(
              option: ChatMessageOptions.delete,
              chatMessage: chatMessage,
            );
          },
        ),
    ];
  }

  Widget _optionIconAndName({
    required IconData iconData,
    required String text,
    VoidCallback? onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            iconData,
            color: clrCornFlower,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: const TextStyle(color: clrCornFlower),
          ),
        ],
      ),
    );
  }

  Widget _reactionIcon({
    required String reactionText,
    required String messageId,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        dimiss();
        callback(
          option: ChatMessageOptions.react,
          chatMessage: chatMessage,
          reactionText: reactionText,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Text(
          reactionText,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

mixin ReactionMixin<T extends StatefulWidget> on State<T> {
  OverlayEntry? reactionOverlayEntry;
  bool _isReactionShowing = false;

  List<String> reactions = [
    '😆',
    '😍',
    '😢',
    '😡',
    '🥳',
  ];

  void showOptionsOverlay({
    required BuildContext context,
    required Offset position,
    required ChatMessageEntity chatMessage,
  }) {
    if (_isReactionShowing) {
      dismissReactionOverlay();
    }
    _isReactionShowing = true;
    reactionOverlayEntry = OverlayEntry(builder: (context) {
      return ChatMessageOptionDialog(
        dimiss: () {
          dismissReactionOverlay();
        },
        position: position,
        reactions: reactions,
        chatMessage: chatMessage,
        callback: chatMessageCallback,
      );
    });

    OverlayState? overlayState = Overlay.of(context);
    overlayState!.insert(reactionOverlayEntry!);
  }

  void dismissReactionOverlay() {
    _isReactionShowing = false;
    reactionOverlayEntry?.remove();
  }

  ReactionDialogCallback get chatMessageCallback => ({
        String? reactionText,
        ChatMessageEntity? chatMessage,
        required ChatMessageOptions option,
      }) {};
}
