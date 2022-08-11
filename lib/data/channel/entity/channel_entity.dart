import 'package:json_annotation/json_annotation.dart';
import 'package:kuro_chat/data/user/datasource/user_local_datasource.dart';

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

  @JsonKey(name: 'lastMessage')
  final ChannelLastMessageEntity? lastMessage;

  ChannelEntity({
    required this.channelId,
    this.channelName,
    this.members,
    this.lastMessage,
  });

  bool get isOneOneChat => members?.length == 2;

  String? get getUserIdOneOneChat {
    if (!isOneOneChat) return null;
    return members?.keys.firstWhere((element) => element != currentUserId);
  }

  factory ChannelEntity.fromJson(Map<String, dynamic> json) =>
      _$ChannelEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ChannelEntityToJson(this);
}

@JsonSerializable()
class ChannelLastMessageEntity {
  final String? text;

  final int? createTimeEpoch;

  ChannelLastMessageEntity({
    required this.text,
    required this.createTimeEpoch,
  });

  factory ChannelLastMessageEntity.fromJson(Map<String, dynamic> json) =>
      _$ChannelLastMessageEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ChannelLastMessageEntityToJson(this);
}
