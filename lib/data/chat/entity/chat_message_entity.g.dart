// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessageEntity _$ChatMessageEntityFromJson(Map<String, dynamic> json) =>
    ChatMessageEntity(
      senderId: json['senderId'] as String,
      text: json['text'] as String? ?? '',
      senderName: json['senderName'] as String? ?? '',
      createTimeEpoch: json['createTimeEpoch'] as int? ?? 0,
      type: json['type'] as String? ?? chatTypeMessage,
    );

Map<String, dynamic> _$ChatMessageEntityToJson(ChatMessageEntity instance) =>
    <String, dynamic>{
      'senderId': instance.senderId,
      'senderName': instance.senderName,
      'text': instance.text,
      'createTimeEpoch': instance.createTimeEpoch,
      'type': instance.type,
    };
