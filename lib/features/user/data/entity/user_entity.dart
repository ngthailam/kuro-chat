import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_entity.g.dart';

@CopyWith()
@JsonSerializable()
class UserEntity {
  final String id;

  UserEntity({required this.id});
}
