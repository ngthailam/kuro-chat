// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatEntity _$ChatEntityFromJson(Map<String, dynamic> json) => ChatEntity(
      channelId: json['channelId'] as String,
      messages: (json['messages'] as List<dynamic>?)
              ?.map(
                  (e) => ChatMessageEntity.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ChatEntityToJson(ChatEntity instance) =>
    <String, dynamic>{
      'channelId': instance.channelId,
      'messages': instance.messages.map((e) => e.toJson()).toList(),
    };
