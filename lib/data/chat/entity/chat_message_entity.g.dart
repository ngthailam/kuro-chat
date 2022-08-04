// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessageEntity _$ChatMessageEntityFromJson(Map<String, dynamic> json) =>
    ChatMessageEntity(
      senderId: json['senderId'] as String,
      text: json['text'] as String? ?? '',
      createTimeEpoch: json['createTimeEpoch'] as int? ?? 0,
    );

Map<String, dynamic> _$ChatMessageEntityToJson(ChatMessageEntity instance) =>
    <String, dynamic>{
      'senderId': instance.senderId,
      'text': instance.text,
      'createTimeEpoch': instance.createTimeEpoch,
    };
