import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:kuro_chat/core/di/get_it_config.dart';
import 'package:kuro_chat/core/utils/load_state.dart';
import 'package:kuro_chat/data/channel/entity/channel_entity.dart';
import 'package:kuro_chat/data/channel/repository/channel_repository.dart';
import 'package:kuro_chat/data/lastmessage/repo/last_message_repo.dart';
import 'package:kuro_chat/data/meta_data/entity/meta_data_entity.dart';
import 'package:kuro_chat/data/meta_data/repository/meta_data_repo.dart';

class ChannelListBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(ChannelListController());
  }
}

class ChannelListController extends GetxController {
  final ChannelRepo _channelRepo = getIt();
  final LastMessageRepo _lastMessageRepo = getIt();

  final RxList<ChannelEntity> channels = RxList([]);
  final Rx<LoadState> channelLoadState = Rx<LoadState>(LoadState.none);

  @override
  void onReady() {
    super.onReady();
    getIt<LastMessageRepo>().populdateData();
    _updateUserStatus();
    _fetchMyChannels();
  }

  // For cases when open app first time, whether logged in or not, they will
  // navigate to this screen
  // When app is in background -> to foreground, MyApp already handle this
  void _updateUserStatus() {
    getIt<MetaDataRepo>().setUserStatus(UserStatus.online);
  }

  void _fetchMyChannels() async {
    channelLoadState(LoadState.loading);
    try {
      final myChannels = await _channelRepo.getMyChannels();
      channels(myChannels);
      channelLoadState(LoadState.success);
    } catch (e) {
      channelLoadState(LoadState.error);
    }
  }

  bool hasUnreadMessages(ChannelEntity channel) {
    if (channel.lastMessage?.createTimeEpoch == null) return true;
    final lastMsgReadEpoch = _lastMessageRepo.getByChannelId(channel.channelId);
    // TODO: update to call to get data from remote
    // to avoid casses relogin, then everything is unread
    if (lastMsgReadEpoch == null) return false;
    return lastMsgReadEpoch < channel.lastMessage!.createTimeEpoch!;
  }

  void refreshMyChannels() {
    _fetchMyChannels();
  }
}
