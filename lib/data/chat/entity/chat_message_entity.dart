import 'package:json_annotation/json_annotation.dart';
import 'package:kuro_chat/data/user/datasource/user_local_datasource.dart';

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

  final Map<String, dynamic>? data;

  final bool isReply;

  String get id => createTimeEpoch.toString();

  bool get isSender => senderId == currentUserId;

  ChatMessageEntity({
    required this.senderId,
    this.text = '',
    this.senderName = '',
    this.createTimeEpoch = 0,
    this.type = chatTypeMessage,
    this.reactions = const {},
    this.data,
    this.isReply = false,
  });

  ChatMessageEntity copyWith({
    String? senderId,
    String? senderName,
    String? text,
    int? createTimeEpoch,
    String? type,
    Map<String, Map<String, bool>>? reactions,
    Map<String, dynamic>? data,
    bool? isReply,
  }) {
    return ChatMessageEntity(
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      text: text ?? this.text,
      createTimeEpoch: createTimeEpoch ?? this.createTimeEpoch,
      type: type ?? this.type,
      reactions: reactions ?? this.reactions,
      data: data ?? this.data,
      isReply: isReply ?? this.isReply,
    );
  }

  factory ChatMessageEntity.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMessageEntityToJson(this);
}
