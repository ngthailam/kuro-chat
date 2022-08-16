import 'package:flutter/material.dart';

class ReactionDialog extends StatelessWidget {
  const ReactionDialog({
    Key? key,
    required this.dX,
    required this.dY,
  }) : super(key: key);

  final double dX, dY;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      color: Colors.red,
    );
  }
}

mixin ReactionMixin on StatelessWidget {
  OverlayEntry? reactionOverlayEntry;
  bool _isReactionShowing = false;

  List<String> reactions = [
    '😆',
    '😍',
    '😢',
    '😡',
    '🥳',
  ];

  void showReactionOverlay({
    required BuildContext context,
    required Offset position,
    required String chatId,
  }) {
    if (_isReactionShowing) {
      dismissReactionOverlay();
    }
    _isReactionShowing = true;
    reactionOverlayEntry = OverlayEntry(builder: (context) {
      return GestureDetector(
          onTap: () {
            dismissReactionOverlay();
          },
          child: Material(
            color: Colors.black.withOpacity(0.1),
            child: Stack(
              children: [
                Positioned(
                  left: position.dx - 50,
                  top: position.dy - 50,
                  child: Container(
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
                            .map((e) => _reactionIcon(
                                  reactionText: e,
                                  chatId: chatId,
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ));
    });

    OverlayState? overlayState = Overlay.of(context);
    overlayState!.insert(reactionOverlayEntry!);
  }

  Widget _reactionIcon({
    required String reactionText,
    required String chatId,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        dismissReactionOverlay();
        onReactionPress(
          reactionText: reactionText,
          chatId: chatId,
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

  void dismissReactionOverlay() {
    _isReactionShowing = false;
    reactionOverlayEntry?.remove();
  }

  void onReactionPress({required String reactionText, required String chatId}) {
    // override to implement
  }
}
