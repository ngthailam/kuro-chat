import 'package:kuro_chat/data/chat/entity/chat_message_entity.dart';
import 'package:kuro_chat/presentation/page/chat/util/bubble_decoration_builder.dart';

abstract class ChatMessageItem {
  final ChatMessageEntity? messageEntity;

  ChatMessageItem({this.messageEntity});
}

class ChatItemText extends ChatMessageItem {
  final ChatPosition chatPosition;

  ChatItemText({
    required ChatMessageEntity messageEntity,
    this.chatPosition = ChatPosition.standalone,
  }) : super(messageEntity: messageEntity);
}

class ChatItemUnreadCutoff extends ChatMessageItem {}

class ChatItemTyping extends ChatMessageItem {}

class ChatItemDateCutoff extends ChatMessageItem {
  final String displayDate;

  ChatItemDateCutoff({required this.displayDate});
}

class ChatItemBottomSpacing extends ChatMessageItem {}