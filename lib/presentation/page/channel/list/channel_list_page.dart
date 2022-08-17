import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:kuro_chat/core/utils/load_state.dart';
import 'package:kuro_chat/data/channel/entity/channel_entity.dart';
import 'package:kuro_chat/presentation/constant/color.dart';
import 'package:kuro_chat/presentation/page/account/account_drawer.dart';
import 'package:kuro_chat/presentation/page/channel/list/channel_list_controller.dart';
import 'package:kuro_chat/presentation/util/app_router.dart';
import 'package:kuro_chat/presentation/util/date_util.dart';
import 'package:kuro_chat/presentation/widget/custom_circle_avatar.dart';

// TODO: add reload data when create success
class ChannelListPage extends GetView<ChannelListController> {
  const ChannelListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const AccountDrawer(),
      drawerEnableOpenDragGesture: false,
      body: SafeArea(
        child: Container(
          color: clrMint,
          height: double.infinity,
          width: double.infinity,
          child: Stack(
            children: [
              _main(),
              _createChannelFab(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _main() {
    return Column(
      children: [
        const SizedBox(height: 16),
        Row(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Messages',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const Expanded(child: SizedBox()),
            LayoutBuilder(
              builder: (context, constraints) => IconButton(
                padding: const EdgeInsets.only(right: 16),
                constraints: const BoxConstraints(),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
                icon: const Icon(
                  Icons.more_vert,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16).copyWith(bottom: 0),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: _channelList(),
          ),
        )
      ],
    );
  }

  Widget _channelList() {
    return Obx(
      () {
        final channels = controller.channels;
        final channelLoadState = controller.channelLoadState.value;
        if (channelLoadState == LoadState.loading && channels.isEmpty) {
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        }

        if (channels.isNotEmpty) {
          return RefreshIndicator(
            onRefresh: () async {
              controller.refreshMyChannels();
            },
            child: ListView.separated(
              itemCount: channels.length,
              physics: const AlwaysScrollableScrollPhysics(),
              separatorBuilder: (context, i) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 64),
                  child: Divider(
                    height: 1,
                    thickness: 1,
                    color: clrMint,
                  ),
                );
              },
              itemBuilder: (context, i) {
                return Padding(
                  key: ValueKey(channels[i].channelId),
                  padding: i == channels.length - 1
                      ? const EdgeInsets.only(bottom: 82)
                      : EdgeInsets.zero,
                  child: _channelItem(channels[i]),
                );
              },
            ),
          );
        }

        return const SizedBox(
          height: double.infinity,
          width: double.infinity,
        );
      },
    );
  }

  Widget _channelItem(ChannelEntity channel) {
    final hasUnreadMsg = controller.hasUnreadMessages(channel);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Get.toNamed(AppRouter.chat,
            parameters: {'channelId': channel.channelId});
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomCircleAvatar(
            name: channel.getChannelName,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _nameAndStatus(channel, hasUnreadMsg),
                const SizedBox(height: 4),
                _lastestMessage(channel, hasUnreadMsg),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _nameAndStatus(ChannelEntity channel, bool hasUnreadMsg) {
    return Row(
      children: [
        Expanded(
          child: Text(
            channel.getChannelName,
            style: TextStyle(
              fontWeight: hasUnreadMsg ? FontWeight.bold : FontWeight.w400,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _lastestMessage(ChannelEntity channel, bool hasUnreadMsg) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Text(
            channel.lastMessage?.text ?? 'Start your conversation',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: hasUnreadMsg
                  ? Colors.black.withOpacity(0.7)
                  : Colors.black.withOpacity(0.4),
              fontWeight: hasUnreadMsg ? FontWeight.bold : FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(width: 16),
        channel.lastMessage?.createTimeEpoch == null
            ? const SizedBox.shrink()
            : Text(
                MyDateUtils.fromMillisEpochToTime(
                  channel.lastMessage!.createTimeEpoch!,
                ),
                style: TextStyle(
                  color: hasUnreadMsg
                      ? Colors.black.withOpacity(0.7)
                      : Colors.black.withOpacity(0.4),
                  fontWeight: hasUnreadMsg ? FontWeight.bold : FontWeight.w400,
                ),
              ),
      ],
    );
  }

  Widget _createChannelFab() {
    return Positioned(
      bottom: 16,
      right: 16,
      child: FloatingActionButton(
        backgroundColor: clrMint,
        onPressed: () {
          _openCreateChannelPage();
        },
        child: const Icon(
          Icons.add,
          size: 24,
        ),
      ),
    );
  }

  void _openCreateChannelPage() {
    Get.toNamed(AppRouter.channelCreate);
  }
}
