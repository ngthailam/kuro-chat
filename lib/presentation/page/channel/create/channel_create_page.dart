import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kuro_chat/core/utils/load_state.dart';
import 'package:kuro_chat/data/user/entity/user_entity.dart';
import 'package:kuro_chat/presentation/constant/color.dart';
import 'package:kuro_chat/presentation/page/channel/create/channel_create_controller.dart';
import 'package:kuro_chat/presentation/util/app_router.dart';
import 'package:kuro_chat/presentation/widget/custom_circle_avatar.dart';

class ChannelCreatePage extends GetView<ChannelCreateController> {
  const ChannelCreatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create channel'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            _searchBox(),
            _createGroup(),
            const SizedBox(height: 8),
            Expanded(child: _searchResults()),
          ],
        ),
      ),
    );
  }

  Widget _searchBox() {
    return Container(
      margin: const EdgeInsets.all(16).copyWith(bottom: 8),
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color.fromARGB(255, 237, 237, 237),
          hintText: 'User name',
          hintStyle: const TextStyle(
            color: Colors.black38,
          ),
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
        ),
        cursorColor: clrMint,
        onChanged: (text) {
          controller.searchUser(text);
        },
      ),
    );
  }

  Widget _createGroup() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Get.toNamed(AppRouter.channelCreateGroup);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: clrCornFlower.withOpacity(0.6),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: const [
            Icon(
              Icons.group,
              size: 24,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text('Create group chat'),
            )
          ],
        ),
      ),
    );
  }

  Widget _searchResults() {
    return Obx(() {
      final searchLoadState = controller.searchLoadState.value;
      final searchResults = controller.userSearchResults;

      if (searchLoadState == LoadState.loading && searchResults.isEmpty) {
        return const Center(
          child: CupertinoActivityIndicator(),
        );
      }

      if (searchLoadState == LoadState.success) {
        if (searchResults.isEmpty) {
          return const Center(
            child: Text('No results found'),
          );
        }

        return ListView.separated(
          itemCount: searchResults.length,
          physics: const BouncingScrollPhysics(),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
            return _searchResultItem(searchResults[i]);
          },
        );
      }

      if (searchLoadState == LoadState.none) {
        return const Center(
          child: Text('Search for a channel to chat'),
        );
      }

      return const SizedBox.shrink();
    });
  }

  Widget _searchResultItem(UserEntity user) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        controller.createChannel(user);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            CustomCircleAvatar(
              name: user.name,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(user.name),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
