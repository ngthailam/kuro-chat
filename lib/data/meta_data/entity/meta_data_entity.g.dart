// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meta_data_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MetaDataEntity _$MetaDataEntityFromJson(Map json) => MetaDataEntity(
      userStatus: (json['user_status'] as Map).map(
        (k, e) => MapEntry(k as String, $enumDecode(_$UserStatusEnumMap, e)),
      ),
    );

Map<String, dynamic> _$MetaDataEntityToJson(MetaDataEntity instance) =>
    <String, dynamic>{
      'user_status': instance.userStatus
          .map((k, e) => MapEntry(k, _$UserStatusEnumMap[e]!)),
    };

const _$UserStatusEnumMap = {
  UserStatus.offline: 'offline',
  UserStatus.online: 'online',
};
