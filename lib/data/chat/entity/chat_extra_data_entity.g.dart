// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_extra_data_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatExtraDataEntity _$ChatExtraDataEntityFromJson(Map json) =>
    ChatExtraDataEntity(
      isUserTyping: (json['isTyping'] as Map?)?.map(
            (k, e) => MapEntry(k as String, e as bool),
          ) ??
          const {},
    );

Map<String, dynamic> _$ChatExtraDataEntityToJson(
        ChatExtraDataEntity instance) =>
    <String, dynamic>{
      'isTyping': instance.isUserTyping,
    };
