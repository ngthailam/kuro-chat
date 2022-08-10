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
    );

Map<String, dynamic> _$ChannelEntityToJson(ChannelEntity instance) =>
    <String, dynamic>{
      'id': instance.channelId,
      'name': instance.channelName,
      'members': instance.members,
    };
