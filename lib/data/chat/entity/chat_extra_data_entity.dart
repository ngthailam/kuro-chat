import 'package:json_annotation/json_annotation.dart';

part 'chat_extra_data_entity.g.dart';

@JsonSerializable(
  anyMap: true
)
class ChatExtraDataEntity {
  // key: userId
  // value: bool: is user with given userId typing or not
  @JsonKey(name: 'isTyping')
  final Map<String, bool> isUserTyping;

  const ChatExtraDataEntity({this.isUserTyping = const {}});

  factory ChatExtraDataEntity.fromJson(Map json) =>
      _$ChatExtraDataEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ChatExtraDataEntityToJson(this);
}
