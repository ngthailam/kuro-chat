import 'package:json_annotation/json_annotation.dart';

part 'chat_message_entity.g.dart';

const String chatTypeMessage = 'message';

@JsonSerializable(explicitToJson: true, anyMap: true)
class ChatMessageEntity {
  final String senderId;

  final String senderName;

  final String text;

  // Also considered as the chat id
  final int createTimeEpoch;

  final String type;

  // key: reaction text
  // value: map: with key: userId, value: always true
  final Map<String, Map<String, bool>> reactions;

  String get id => createTimeEpoch.toString();

  ChatMessageEntity({
    required this.senderId,
    this.text = '',
    this.senderName = '',
    this.createTimeEpoch = 0,
    this.type = chatTypeMessage,
    this.reactions = const {},
  });

  ChatMessageEntity copyWith({
    String? senderId,
    String? senderName,
    String? text,
    int? createTimeEpoch,
    String? type,
    Map<String, Map<String, bool>>? reactions,
  }) {
    return ChatMessageEntity(
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      text: text ?? this.text,
      createTimeEpoch: createTimeEpoch ?? this.createTimeEpoch,
      type: type ?? this.type,
      reactions: reactions ?? this.reactions,
    );
  }

  factory ChatMessageEntity.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMessageEntityToJson(this);
}
