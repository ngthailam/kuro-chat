import 'package:json_annotation/json_annotation.dart';
import 'package:kuro_chat/data/chat/entity/chat_message_entity.dart';

part 'chat_entity.g.dart';

@JsonSerializable(explicitToJson: true)
class ChatEntity {

  // Channel id is also chat id
  final String channelId;

  final List<ChatMessageEntity> messages;

  ChatEntity({
    required this.channelId,
    this.messages = const [],
  });

    factory ChatEntity.fromJson(Map<String, dynamic> json) =>
      _$ChatEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ChatEntityToJson(this);
}
