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
      body: Column(
        children: [
          _channelHeader(),
          _chat(),
          _chatInput(),
        ],
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
                _headerNameAndMember(channel),
                const Icon(Icons.menu, size: 20),
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

  Widget _headerNameAndMember(ChannelEntity channel) {
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
          Text(
            channel.members?.isNotEmpty == true
                ? '${channel.members?.keys.length} members'
                : '',
            style: TextStyle(color: Colors.black.withOpacity(0.5)),
          )
        ],
      ),
    );
  }

  Widget _chat() {
    return Obx(() {
      final messages = controller.messages;

      if (messages.isEmpty) return const SizedBox.shrink();

      final builder = ChatMessageListItemBuilder(
        messages: messages,
        currentUserId: currentUserId,
      );

      return Expanded(
        child: ListView.separated(
          key: const ValueKey('messages'),
          addAutomaticKeepAlives: false,
          physics: const BouncingScrollPhysics(),
          reverse: true,
          itemCount: messages.length,
          separatorBuilder: (context, i) => const SizedBox(height: 4),
          itemBuilder: (context, i) {
            return builder.build(i);
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
              controller.sendMessage(_textController.text);
              _textController.text = '';
            },
          ),
        ],
      ),
    );
  }
}
