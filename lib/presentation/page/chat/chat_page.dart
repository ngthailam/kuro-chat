import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:kuro_chat/data/channel/entity/channel_entity.dart';
import 'package:kuro_chat/presentation/constant/color.dart';
import 'package:kuro_chat/presentation/emoji/emoji_picker.dart';
import 'package:kuro_chat/presentation/page/chat/chat_controller.dart';
import 'package:kuro_chat/presentation/page/chat/widget/reaction_dialog.dart';

// ignore: must_be_immutable
class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>
    with ReactionMixin, TickerProviderStateMixin {
  final ChatController _controller = Get.find<ChatController>();
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFocusNode = FocusNode();

  AnimationController? _pickerAnimationController;
  Animation<double>? _sizeFactor;

  @override
  void initState() {
    super.initState();
    _pickerAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    _sizeFactor = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _pickerAnimationController!,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _pickerAnimationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _channelHeader(),
            _chat(),
            _chatInput(),
            _picker(),
          ],
        ),
      ),
    );
  }

  Widget _channelHeader() {
    return Obx(() {
      final channel = _controller.channel.value;

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
            channel.getChannelName,
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

    final isTargetOnline = _controller.isTargetOnline();
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
      final messages = _controller.messages;

      // log("_chat isTargetTyping=$isTargetTyping || _itemLength=$itemLength");

      if (messages.isEmpty) {
        return const Expanded(child: SizedBox.shrink());
      }

      final chatItems = _controller.builder.generateItems();

      return Expanded(
        child: GestureDetector(
          onTap: () {
            if (_pickerAnimationController?.status ==
                AnimationStatus.completed) {
              _pickerAnimationController?.reverse();
            }
          },
          child: ListView.separated(
            key: const ValueKey('messages'),
            addAutomaticKeepAlives: false,
            physics: const BouncingScrollPhysics(),
            reverse: true,
            itemCount: chatItems.length,
            separatorBuilder: (context, i) => const SizedBox(height: 4),
            itemBuilder: (context, i) {
              final chatItem = chatItems[i];
              return _controller.builder.buildItem(
                item: chatItem,
                onLongPressEnd: (details) {
                  showOptionsOverlay(
                      context: context,
                      position: details.globalPosition,
                      chatMessage: chatItem.messageEntity!);
                },
              );
            },
          ),
        ),
      );
    });
  }

  @override
  ReactionDialogCallback get chatMessageCallback => ({
        String? reactionText,
        String? chatText,
        required String messageId,
        required ChatMessageOptions option,
      }) {
        if (option == ChatMessageOptions.react) {
          _controller.onReactionPress(
              messageId: messageId, reactionText: reactionText!);
          return;
        }

        if (option == ChatMessageOptions.copy) {
          Clipboard.setData(ClipboardData(text: chatText)).then((_) {
            ScaffoldMessenger.of(Get.context!).showSnackBar(
                const SnackBar(content: Text("Copied to clipboard")));
          });
          return;
        }

        if (option == ChatMessageOptions.delete) {
          _controller.deleteMessage(messageId: messageId);
          return;
        }
      };

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
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () {
              if (_pickerAnimationController == null) return;
              switch (_pickerAnimationController!.status) {
                case AnimationStatus.dismissed:
                  _pickerAnimationController?.forward();
                  break;
                case AnimationStatus.completed:
                  _pickerAnimationController?.reverse();
                  break;
                default:
                  return;
              }
            },
            icon: const Icon(
              Icons.emoji_emotions,
              color: clrGrayLight,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              decoration: const InputDecoration.collapsed(hintText: 'Message'),
              controller: _textController,
              onChanged: (text) {
                _controller.onTypeChat(text);
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
              _controller.onTypeChat('');
              _controller.sendMessage(text);
              _textFocusNode.requestFocus();
            },
          ),
        ],
      ),
    );
  }

  Widget _picker() {
    return SizeTransition(
      sizeFactor: _sizeFactor!,
      child: MyEmojiPicker(
        onEmojiPicked: (emoji) {
          final newText = _textController.text + emoji.icon;
          _textController.text = newText;
          _textController.selection =
              TextSelection.collapsed(offset: newText.length);
        },
      ),
    );
  }
}
