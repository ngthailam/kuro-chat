import 'package:flutter/material.dart';
import 'package:kuro_chat/presentation/constant/color.dart';

class BubbleDecorationBuilder {
  final bool isSender;
  final ChatPosition position;

  BubbleDecorationBuilder({
    required this.isSender,
    required this.position,
  });

  BoxDecoration build() {
    // TODO: add cache to improve performance
    final boxDecoration = BoxDecoration(
      borderRadius: getBorderRadius(),
      color: isSender ? clrCornFlower : clrGrayLighter,
    );

    return boxDecoration;
  }

  Radius radius16 = const Radius.circular(16);
  Radius radius4 = const Radius.circular(8);

  BorderRadiusGeometry getBorderRadius() {
    // TODO: check const usage
    switch (position) {
      case ChatPosition.standalone:
        return BorderRadius.all(radius16);
      case ChatPosition.first:
        return isSender
            ? BorderRadius.all(radius16).copyWith(bottomRight: radius4)
            : BorderRadius.all(radius16).copyWith(bottomLeft: radius4);
      case ChatPosition.middle:
        return isSender
            ? BorderRadius.all(radius16)
                .copyWith(bottomRight: radius4, topRight: radius4)
            : BorderRadius.all(radius16)
                .copyWith(bottomLeft: radius4, topLeft: radius4);
      case ChatPosition.last:
        return isSender
            ? BorderRadius.all(radius16).copyWith(topRight: radius4)
            : BorderRadius.all(radius16).copyWith(topLeft: radius4);
    }
  }
}

enum ChatPosition { first, middle, last, standalone }
