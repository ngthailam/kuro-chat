// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChannelEntity _$ChannelEntityFromJson(Map<String, dynamic> json) =>
    ChannelEntity(
      channelId: json['id'] as String,
      channelName: json['name'] as String?,
      members: (json['members'] as Map<String, dynamic>?)?.map(
            (k, e) =>
                MapEntry(k, UserEntity.fromJson(e as Map<String, dynamic>)),
          ) ??
          {},
      lastMessage: json['lastMessage'] == null
          ? null
          : LastMessageEntity.fromJson(
              json['lastMessage'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ChannelEntityToJson(ChannelEntity instance) =>
    <String, dynamic>{
      'id': instance.channelId,
      'name': instance.channelName,
      'members': instance.members?.map((k, e) => MapEntry(k, e.toJson())),
      'lastMessage': instance.lastMessage?.toJson(),
    };

LastMessageEntity _$LastMessageEntityFromJson(Map<String, dynamic> json) =>
    LastMessageEntity(
      text: json['text'] as String?,
      createTimeEpoch: json['createTimeEpoch'] as int?,
    );

Map<String, dynamic> _$LastMessageEntityToJson(LastMessageEntity instance) =>
    <String, dynamic>{
      'text': instance.text,
      'createTimeEpoch': instance.createTimeEpoch,
    };
