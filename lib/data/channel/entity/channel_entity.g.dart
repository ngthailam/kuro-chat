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
            (k, e) => MapEntry(k, e as bool),
          ) ??
          {},
      lastMessage: json['lastMessage'] == null
          ? null
          : ChannelLastMessageEntity.fromJson(
              json['lastMessage'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ChannelEntityToJson(ChannelEntity instance) =>
    <String, dynamic>{
      'id': instance.channelId,
      'name': instance.channelName,
      'members': instance.members,
      'lastMessage': instance.lastMessage?.toJson(),
    };

ChannelLastMessageEntity _$ChannelLastMessageEntityFromJson(
        Map<String, dynamic> json) =>
    ChannelLastMessageEntity(
      text: json['text'] as String?,
      createTimeEpoch: json['createTimeEpoch'] as int?,
    );

Map<String, dynamic> _$ChannelLastMessageEntityToJson(
        ChannelLastMessageEntity instance) =>
    <String, dynamic>{
      'text': instance.text,
      'createTimeEpoch': instance.createTimeEpoch,
    };
