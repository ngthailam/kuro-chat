import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:kuro_chat/core/utils/load_state.dart';
import 'package:kuro_chat/data/user/entity/user_entity.dart';
import 'package:kuro_chat/presentation/constant/color.dart';
import 'package:kuro_chat/presentation/page/channel/create/group/channel_create_group_controller.dart';
import 'package:kuro_chat/presentation/widget/custom_circle_avatar.dart';

class ChannelCreateGroupPage extends GetView<ChannelCreateGroupController> {
  const ChannelCreateGroupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Group'),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              _groupName(),
              _searchBox(),
              Expanded(child: _searchResults()),
            ],
          ),
          _createFab(),
        ],
      ),
    );
  }

  Widget _groupName() {
    return Container(
      margin: const EdgeInsets.all(16).copyWith(bottom: 0),
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color.fromARGB(255, 237, 237, 237),
          hintText: 'Group name (Optional)',
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
        controller: controller.groupNameTextCtrl,
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
          hintText: 'Who do you what to add to the group?',
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
    return Obx(
      () => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          controller.onSelectUser(user);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              IgnorePointer(
                child: _avatar(
                  user: user,
                  isSelected: controller.selectedUsers
                      .any((element) => element.id == user.id),
                ),
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
      ),
    );
  }

  Widget _avatar({required bool isSelected, required UserEntity user}) {
    if (isSelected) {
      return Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: clrMint,
        ),
        height: 40,
        width: 40,
        child: const Center(
          child: Icon(
            Icons.check_outlined,
            color: Colors.white,
          ),
        ),
      );
    } else {
      return CustomCircleAvatar(
        name: user.name,
      );
    }
  }

  Widget _createFab() {
    return Positioned(
      bottom: 16,
      right: 16,
      child: Obx(() {
        // TODO: add animation shrink
        final isUserSelected = controller.selectedUsers.isNotEmpty;

        if (!isUserSelected) {
          return const SizedBox.shrink();
        }

        return FloatingActionButton(
          backgroundColor: clrMint,
          onPressed: () {
            controller.confirmCreateGroup();
          },
          child: const Icon(
            Icons.arrow_forward,
            size: 24,
          ),
        );
      }),
    );
  }
}
