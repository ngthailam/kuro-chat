import 'package:json_annotation/json_annotation.dart';
import 'package:kuro_chat/data/user/datasource/user_local_datasource.dart';
import 'package:kuro_chat/data/user/entity/user_entity.dart';

part 'channel_entity.g.dart';

@JsonSerializable(explicitToJson: true)
class ChannelEntity {
  @JsonKey(name: 'id')
  final String channelId;

  @JsonKey(name: 'name')
  final String? channelName;

  // Channel ids
  @JsonKey(name: 'members', defaultValue: {})
  final Map<String, UserEntity>? members;

  @JsonKey(name: 'lastMessage')
  final LastMessageEntity? lastMessage;

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

  String get getChannelName {
    if (isOneOneChat) {
      final otherUserId =
          members!.keys.firstWhere((element) => element != currentUserId);
      return members![otherUserId]?.name ?? '(No name)';
    }

    // Channel name for groups
    if (channelName?.isNotEmpty == true) {
      return channelName!;
    } else {
      var memberNamesAsChannelName = '';
      for (var element in members!.values) {
        memberNamesAsChannelName += "${element.name}, ";
      }
      return memberNamesAsChannelName;
    }
  }

  factory ChannelEntity.fromJson(Map<String, dynamic> json) =>
      _$ChannelEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ChannelEntityToJson(this);
}

@JsonSerializable()
class LastMessageEntity {
  final String? text;

  final int? createTimeEpoch;

  LastMessageEntity({
    required this.text,
    required this.createTimeEpoch,
  });

  factory LastMessageEntity.fromJson(Map<String, dynamic> json) =>
      _$LastMessageEntityFromJson(json);

  Map<String, dynamic> toJson() => _$LastMessageEntityToJson(this);
}
