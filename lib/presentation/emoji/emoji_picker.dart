import 'package:flutter/material.dart';
import 'package:kuro_chat/data/emoji/entity/category_emoji.dart';
import 'package:kuro_chat/data/emoji/entity/emoji.dart';
import 'package:kuro_chat/data/emoji/entity/emoji_set.dart';
import 'package:kuro_chat/presentation/constant/color.dart';

// TODO: fit to keyboard
class MyEmojiPicker extends StatefulWidget {
  const MyEmojiPicker({Key? key, required this.onEmojiPicked})
      : super(key: key);

  final Function(Emoji emoji) onEmojiPicked;

  @override
  State<MyEmojiPicker> createState() => _MyEmojiPickerState();
}

class _MyEmojiPickerState extends State<MyEmojiPicker> {
  final PageController _pageController =
      PageController(keepPage: true, initialPage: 0);
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: match with keyboard height
    return SizedBox(
      height: 250,
      child: Column(
        children: [
          SizedBox(
            height: 40,
            child: ListView.builder(
              itemCount: defaultEmojiSet.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, i) => _tabItem(defaultEmojiSet[i], i),
            ),
          ),
          Expanded(
            child: PageView.builder(
              itemCount: defaultEmojiSet.length,
              controller: _pageController,
              onPageChanged: (i) {
                setState(() {
                  _selectedIndex = i;
                });
              },
              itemBuilder: (context, i) {
                return _EmojiGrid(
                  emojis: defaultEmojiSet[i].emojis,
                  onEmojiPicked: widget.onEmojiPicked,
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _tabItem(CategoryEmoji categoryEmoji, int i) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        setState(() {
          if (_selectedIndex != i) {
            _selectedIndex = i;
            _pageController.animateToPage(
              i,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        });
      },
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Icon(
                Icons.abc,
                color: _selectedIndex == i ? Colors.blue : clrGrayLight,
              ),
            ),
          ),
          SizedBox(
            height: 1,
            width: 60,
            child: _selectedIndex == i
                ? const Divider(
                    thickness: 1,
                    height: 1,
                    color: Colors.blue,
                  )
                : const SizedBox.shrink(),
          )
        ],
      ),
    );
  }
}

class _EmojiGrid extends StatelessWidget {
  const _EmojiGrid(
      {Key? key, required this.emojis, required this.onEmojiPicked})
      : super(key: key);

  final List<Emoji> emojis;
  final Function(Emoji emoji) onEmojiPicked;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: emojis.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
        ),
        itemBuilder: (context, i) {
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              onEmojiPicked(emojis[i]);
            },
            child: Center(
              child: Text(
                emojis[i].icon,
                style: const TextStyle(fontSize: 20),
              ),
            ),
          );
        });
  }
}
