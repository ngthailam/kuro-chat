import 'package:json_annotation/json_annotation.dart';

part 'channel_entity.g.dart';

@JsonSerializable(explicitToJson: true)
class ChannelEntity {
  final String channelId;

  final String channelName;

  // Channel ids
  final Map<String, bool> members;

  ChannelEntity({
    required this.channelId,
    this.channelName = '',
    this.members = const {},
  });

  factory ChannelEntity.fromJson(Map<String, dynamic> json) =>
      _$ChannelEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ChannelEntityToJson(this);
}
