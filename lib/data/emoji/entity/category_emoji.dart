import 'package:kuro_chat/data/emoji/entity/emoji.dart';

class CategoryEmoji {
  final EmojiCategoryType type;

  final List<Emoji> emojis;

  const CategoryEmoji(
    this.type,
    this.emojis,
  );
}

enum EmojiCategoryType {
  smiley,
  travel,
  animals,
  foods,
  activities,
  objects,
  symbols,
  flags
}
