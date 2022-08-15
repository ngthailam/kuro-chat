import 'package:injectable/injectable.dart';

abstract class ChatLocalDataSource {
  void setIsTyping(String channelId, bool isTyping);

  bool getIsTyping(String channelId);
}

// One Chat controller should have an instance of chat repo
// in turn have an instance of chat local data source
// so instead of wasting mem on singleton, factory is enough
@Injectable(as: ChatLocalDataSource)
class ChatLocalDataSourceImpl extends ChatLocalDataSource {
  final Map<String, bool> _isTypingMap = {};

  
  @override
  bool getIsTyping(String channelId) {
    return _isTypingMap[channelId] ?? false;
  }

  @override
  void setIsTyping(String channelId, bool isTyping) {
    _isTypingMap[channelId] = isTyping;
  }
}
