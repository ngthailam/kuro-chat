import 'package:json_annotation/json_annotation.dart';

part 'chat_message_entity.g.dart';

@JsonSerializable()
class ChatMessageEntity {
  final String senderId;

  final String senderName;

  final String text;

  final int createTimeEpoch;

  final String type;

  ChatMessageEntity({
    required this.senderId,
    this.text = '',
    this.senderName = '',
    this.createTimeEpoch = 0,
    this.type = chatTypeMessage,
  });

  factory ChatMessageEntity.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMessageEntityToJson(this);
}

const String chatTypeMessage = 'message';
