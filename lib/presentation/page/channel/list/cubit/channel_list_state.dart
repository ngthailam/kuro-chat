import 'package:kuro_chat/data/channel/entity/channel_entity.dart';

abstract class ChannelListState {}

class ChannelListInitial extends ChannelListState {}

class ChannelListPrimary extends ChannelListState {
  final List<ChannelEntity>? channels;

  ChannelListPrimary({this.channels});
}
