import 'package:json_annotation/json_annotation.dart';

part 'channel_entity.g.dart';

@JsonSerializable(explicitToJson: true)
class ChannelEntity {
  @JsonKey(name: 'id')
  final String channelId;

  @JsonKey(name: 'name')
  final String? channelName;

  // Channel ids
  @JsonKey(name: 'members', defaultValue: {})
  final Map<String, bool>? members;

  ChannelEntity({
    required this.channelId,
    this.channelName,
    this.members,
  });

  factory ChannelEntity.fromJson(Map<String, dynamic> json) =>
      _$ChannelEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ChannelEntityToJson(this);
}
