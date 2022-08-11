import 'package:json_annotation/json_annotation.dart';

part 'meta_data_entity.g.dart';

@JsonSerializable(anyMap: true)
class MetaDataEntity {
  // key: userId
  // value: UserStatus
  @JsonKey(name: 'user_status')
  final Map<String, UserStatus> userStatus;

  const MetaDataEntity({required this.userStatus});

  factory MetaDataEntity.fromJson(Map json) => _$MetaDataEntityFromJson(json);

  Map<String, dynamic> toJson() => _$MetaDataEntityToJson(this);
}

@JsonEnum()
enum UserStatus { offline, online }
