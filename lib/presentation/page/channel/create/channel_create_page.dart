import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kuro_chat/core/utils/load_state.dart';
import 'package:kuro_chat/presentation/page/channel/create/channel_create_controller.dart';

class ChannelCreatePage extends GetView<ChannelCreateController> {
  const ChannelCreatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _searchBox(),
          Expanded(child: _searchResults()),
        ],
      ),
    );
  }

  Widget _searchBox() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        onChanged: (text) {
          controller.searchChannel(text);
        },
      ),
    );
  }

  Widget _searchResults() {
    return Obx(() {
      final searchLoadState = controller.searchLoadState.value;
      final searchResults = controller.searchResults;

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

        return ListView.builder(
          itemCount: searchResults.length,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          itemBuilder: (context, i) {
            return GestureDetector(
              onTap: () {
                controller.createChannel(searchResults[i]);
              },
              child: Container(
                  color: Colors.red,
                  child: Text(searchResults[i].channelName ?? 'No name')),
            );
          },
        );
      }

      return const SizedBox.shrink();
    });
  }
}
