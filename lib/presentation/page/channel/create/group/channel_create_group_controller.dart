import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:kuro_chat/core/di/get_it_config.dart';
import 'package:kuro_chat/core/utils/debouncer.dart';
import 'package:kuro_chat/core/utils/load_state.dart';
import 'package:kuro_chat/data/channel/repository/channel_repository.dart';
import 'package:kuro_chat/data/user/entity/user_entity.dart';
import 'package:kuro_chat/data/user/repo/user_repository.dart';
import 'package:kuro_chat/presentation/util/app_router.dart';

class ChannelCreateGroupBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(ChannelCreateGroupController());
  }
}

class ChannelCreateGroupController extends GetxController {
  // TODO: inject with GetX
  final ChannelRepo _channelRepo = getIt();
  final UserRepo _userRepo = getIt();

  TextEditingController? groupNameTextCtrl;

  RxList<UserEntity> selectedUsers = <UserEntity>[].obs;
  RxList<UserEntity> userSearchResults = <UserEntity>[].obs;
  Rx<LoadState> searchLoadState = Rx<LoadState>(LoadState.none);
  Rx<LoadState> createLoadState = Rx<LoadState>(LoadState.none);

  final Debouncer _searchDebouncer = Debouncer();

  @override
  void onReady() {
    groupNameTextCtrl ??= TextEditingController();
    super.onReady();
  }

  @override
  void onClose() {
    groupNameTextCtrl?.dispose();
    _searchDebouncer.dispose();
    super.onClose();
  }

  void searchUser(String text) {
    _searchDebouncer.run(() async {
      if (text.isEmpty) {
        searchLoadState(LoadState.success);
        userSearchResults([]);
        return;
      }

      searchLoadState(LoadState.loading);

      try {
        final searchResults = await _userRepo.searchByName(text);
        searchLoadState(LoadState.success);
        userSearchResults(searchResults);
      } catch (e) {
        searchLoadState(LoadState.error);
      }
    });
  }

  void onSelectUser(UserEntity user) {
    final List<UserEntity> modifiedSelectedUsers = List.from(selectedUsers);

    final userEntityIndex =
        modifiedSelectedUsers.indexWhere((element) => element.id == user.id);
    if (userEntityIndex != -1) {
      modifiedSelectedUsers.removeAt(userEntityIndex);
    } else {
      modifiedSelectedUsers.add(user);
    }

    selectedUsers(modifiedSelectedUsers);
  }

  void confirmCreateGroup() async {
    createLoadState(LoadState.loading);
    try {
      await _channelRepo.createChannel(
        users: selectedUsers,
        channelName: groupNameTextCtrl?.text,
      );
      createLoadState(LoadState.success);
      // TODO: fix this
      Get.until((route) => route.settings.name == AppRouter.channelList);
    } catch (e) {
      Get.snackbar('Create group', '$e');
      createLoadState(LoadState.error);
    }
  }

  bool isUserSelected(String userId) {
    return selectedUsers.any((element) => element.id == userId);
  }
}
