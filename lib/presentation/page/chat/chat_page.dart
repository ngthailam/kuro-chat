import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:kuro_chat/data/channel/entity/channel_entity.dart';
import 'package:kuro_chat/data/user/datasource/user_local_datasource.dart';
import 'package:kuro_chat/presentation/constant/color.dart';
import 'package:kuro_chat/presentation/page/chat/chat_controller.dart';
import 'package:kuro_chat/presentation/page/chat/util/chat_message_list_item_builder.dart';

class ChatPage extends GetView<ChatController> {
  ChatPage({Key? key}) : super(key: key);

  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _channelHeader(),
            _chat(),
            _chatInput(),
          ],
        ),
      ),
    );
  }

  Widget _channelHeader() {
    return Obx(() {
      final channel = controller.channel.value;

      if (channel != null) {
        return SafeArea(
          top: true,
          child: Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _iconBack(),
                const SizedBox(width: 16),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: clrMint,
                  ),
                  child: const Center(child: Text('GR')),
                ),
                const SizedBox(width: 16),
                _headerName(channel),
                const Icon(Icons.more_vert, size: 20),
              ],
            ),
          ),
        );
      }

      return const SizedBox.shrink();
    });
  }

  Widget _iconBack() {
    return IconButton(
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      icon: const Icon(
        Icons.arrow_back,
        size: 20,
      ),
      onPressed: () {
        Get.back();
      },
    );
  }

  Widget _headerName(ChannelEntity channel) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            channel.channelName ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          _headerNameSubtitle(channel),
        ],
      ),
    );
  }

  Widget _headerNameSubtitle(ChannelEntity channel) {
    if (channel.members?.isNotEmpty != true) {
      return const SizedBox.shrink();
    }

    final isTargetOnline = controller.isTargetOnline();
    if (channel.isOneOneChat) {
      return Row(
        children: [
          Container(
            height: 8,
            width: 8,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isTargetOnline
                    ? const Color(0xff48d86d)
                    : const Color(0xffd40f5f)),
          ),
          const SizedBox(width: 4),
          Text(
            isTargetOnline ? 'Online' : 'Offline',
            style: TextStyle(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
        ],
      );
    }

    return Text(
      channel.members?.isNotEmpty == true
          ? '${channel.members?.keys.length} members'
          : '',
      style: TextStyle(color: Colors.black.withOpacity(0.5)),
    );
  }

  Widget _chat() {
    return Obx(() {
      final messages = controller.messages;
      final isTargetTyping = controller.isTargetTyping.value;
      final itemLength = messages.length + (isTargetTyping ? 1 : 0);

      log("_chat isTargetTyping=$isTargetTyping || _itemLength=$itemLength");

      if (messages.isEmpty) {
        return const Expanded(child: SizedBox.shrink());
      }

      final builder = ChatMessageListItemBuilder(
        messages: messages,
        currentUserId: currentUserId,
        isTargetTyping: isTargetTyping,
      );

      return Expanded(
        child: ListView.separated(
          key: const ValueKey('messages'),
          addAutomaticKeepAlives: false,
          physics: const BouncingScrollPhysics(),
          reverse: true,
          itemCount: itemLength,
          separatorBuilder: (context, i) => const SizedBox(height: 4),
          itemBuilder: (context, i) {
            return builder.build(itemIndex: i);
          },
        ),
      );
    });
  }

  _chatInput() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        // TODO: update border color
        border: Border(
          top: BorderSide(
            color: clrGrayLight.withOpacity(0.3),
          ),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.emoji_emotions,
            color: clrGrayLight,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              decoration: const InputDecoration.collapsed(hintText: 'Message'),
              controller: _textController,
              onChanged: (text) {
                controller.onTypeChat(text);
              },
            ),
          ),
          IconButton(
            constraints: const BoxConstraints(),
            padding: EdgeInsets.zero,
            icon: const Icon(
              Icons.send,
              size: 24,
              color: clrCornFlower,
            ),
            onPressed: () {
              // TODO: typing text dissapear too slow
              // even after message is sent
              final text = _textController.text;
              _textController.text = '';
              controller.onTypeChat('');
              controller.sendMessage(text);
            },
          ),
        ],
      ),
    );
  }
}
