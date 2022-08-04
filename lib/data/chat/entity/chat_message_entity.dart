import 'package:json_annotation/json_annotation.dart';

part 'chat_message_entity.g.dart';

@JsonSerializable()
class ChatMessageEntity {
  final String senderId;

  final String text;

  final int createTimeEpoch;

  ChatMessageEntity({
    required this.senderId,
    this.text = '',
    this.createTimeEpoch = 0,
  });

  factory ChatMessageEntity.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMessageEntityToJson(this);
}
