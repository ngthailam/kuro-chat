import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:kuro_chat/core/utils/load_state.dart';
import 'package:kuro_chat/presentation/page/channel/list/channel_list_controller.dart';
import 'package:kuro_chat/presentation/util/app_router.dart';

// TODO: add reload data when create success
class ChannelListPage extends GetView<ChannelListController> {
  const ChannelListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          children: [
            _channelList(),
            _createChannelFab(),
          ],
        ),
      ),
    );
  }

  Widget _channelList() {
    return Obx(() {
      final channels = controller.channels;
      final channelLoadState = controller.channelLoadState.value;

      if (channelLoadState == LoadState.loading && channels.isEmpty) {
        return const Center(
          child: CupertinoActivityIndicator(),
        );
      }

      if (channels.isNotEmpty) {
        return ListView.builder(
          itemCount: channels.length,
          itemBuilder: (context, i) {
            return GestureDetector(
              onTap: () {
                Get.toNamed(AppRouter.chat,
                    parameters: {'channelId': channels[i].channelId});
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(channels[i].channelName ?? 'No name'),
              ),
            );
          },
        );
      }

      return const SizedBox.shrink();
    });
  }

  Widget _createChannelFab() {
    return Positioned(
      bottom: 16,
      right: 16,
      child: FloatingActionButton(
        backgroundColor: Colors.amberAccent,
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
