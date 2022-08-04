// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChannelEntity _$ChannelEntityFromJson(Map<String, dynamic> json) =>
    ChannelEntity(
      channelId: json['channelId'] as String,
      channelName: json['channelName'] as String? ?? '',
      members: (json['members'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as bool),
          ) ??
          const {},
    );

Map<String, dynamic> _$ChannelEntityToJson(ChannelEntity instance) =>
    <String, dynamic>{
      'channelId': instance.channelId,
      'channelName': instance.channelName,
      'members': instance.members,
    };
