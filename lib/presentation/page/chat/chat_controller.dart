import 'dart:async';
import 'dart:developer';

import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:kuro_chat/core/di/get_it_config.dart';
import 'package:kuro_chat/core/utils/debouncer.dart';
import 'package:kuro_chat/data/channel/entity/channel_entity.dart';
import 'package:kuro_chat/data/channel/repository/channel_repository.dart';
import 'package:kuro_chat/data/chat/entity/chat_extra_data_entity.dart';
import 'package:kuro_chat/data/chat/entity/chat_message_entity.dart';
import 'package:kuro_chat/data/chat/repository/chat_repo.dart';
import 'package:kuro_chat/data/lastmessage/repo/last_message_repo.dart';
import 'package:kuro_chat/data/meta_data/entity/meta_data_entity.dart';
import 'package:kuro_chat/data/meta_data/repository/meta_data_repo.dart';
import 'package:kuro_chat/data/user/datasource/user_local_datasource.dart';

class ChatBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(ChatController());
  }
}

class ChatController extends GetxController {
  // TODO: inject using getX
  final ChannelRepo _channelRepo = getIt();
  final ChatRepo _chatRepo = getIt();
  final LastMessageRepo _lastMessageRepo = getIt();

  String _channelId = '';

  // ignore: unnecessary_cast
  final Rx<ChannelEntity?> channel = (null as ChannelEntity?).obs;
  final RxList<ChatMessageEntity> messages = RxList([]);

  final RxBool isTargetTyping = RxBool(false);

  StreamSubscription<List<ChatMessageEntity>>? _streamSubscription;
  StreamSubscription<ChatExtraDataEntity>? _extraDataStreamSubscription;

  final Debouncer _chatTypeDebouncer =
      Debouncer(duration: const Duration(milliseconds: 500));

  int _lastReadMessageCreateTimeEpoch = 0;

  @override
  void onReady() {
    super.onReady();
    _initParams();
    _observeChat();
    _fetchChannelDetail();
    _observeExtraData();
  }

  @override
  void onClose() {
    _chatTypeDebouncer.dispose();
    _streamSubscription?.cancel();
    _extraDataStreamSubscription?.cancel();
    super.onClose();
  }

  void _initParams() {
    _channelId = Get.parameters['channelId'] ?? '';
  }

  bool isTargetOnline() {
    final targetUserId = channel.value?.getUserIdOneOneChat;
    if (targetUserId == null) return false;

    return userStatusMap[targetUserId] == UserStatus.online;
  }

  Future _observeChat() async {
    _streamSubscription =
        _chatRepo.observeMessages(_channelId).listen((chatMessages) {
      if (chatMessages.isNotEmpty) {
        final msgCreateTimeEpoch = chatMessages.first.createTimeEpoch;
        if (_lastReadMessageCreateTimeEpoch != msgCreateTimeEpoch) {
          _lastMessageRepo.setLastRead(_channelId, msgCreateTimeEpoch);
          _lastReadMessageCreateTimeEpoch = msgCreateTimeEpoch;
        }
      }
      messages(chatMessages);
    });
  }

  Future _fetchChannelDetail() async {
    final channel = await _channelRepo.getChannel(_channelId);
    this.channel(channel);
  }

  Future sendMessage(String text) async {
    await _chatRepo.sendMessage(_channelId, text);
  }

  void onTypeChat(String text) {
    _chatTypeDebouncer.run(() {
      _chatRepo.setIsTyping(_channelId, text.isNotEmpty);
    });
  }

  void _observeExtraData() {
    _extraDataStreamSubscription =
        _chatRepo.observeExtraData(_channelId).listen((extraData) {
      final List<String> typingMemberIds = extraData.isUserTyping.entries
          .where((element) =>
              element.value == true && element.key != currentUserId)
          .map((e) => e.key)
          .toList();

      // Set to update UI
      isTargetTyping(typingMemberIds.isNotEmpty);
    });
  }
}
