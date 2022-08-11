import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_entity.g.dart';

@CopyWith()
@JsonSerializable()
class UserEntity {
  final String id;

  final String name;

  final UserStatus? status;

  const UserEntity({
    required this.id,
    required this.name,
    this.status,
  });

  factory UserEntity.fromJson(Map<String, dynamic> json) =>
      _$UserEntityFromJson(json);

  Map<String, dynamic> toJson() => _$UserEntityToJson(this);
}

@JsonEnum()
enum UserStatus { offline, online }
