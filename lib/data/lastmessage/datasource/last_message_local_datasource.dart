import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LastMessageLocalDataSource {
  int? getByChannelId(String channelId);

  // @param lastMessageReadData
  // key: channel id
  // int: last message createTimeEpoch
  Future save({required Map<String, int> lastMessageReadData});

  Future populateRamFromDb();

  Map<String, int> getAll();

  Future clear();
}

// key: channelId
// value: last Read message create time epoch
final Map<String, int> _lastMessageReadMap = {};

const String prefKeyLastReadMap = 'lastReadMap';

@Injectable(as: LastMessageLocalDataSource)
class LastMessageLocalDataSourceImpl extends LastMessageLocalDataSource {
  @override
  Map<String, int> getAll() {
    return _lastMessageReadMap;
  }

  @override
  int? getByChannelId(String channelId) {
    return _lastMessageReadMap[channelId];
  }

  @override
  Future save({required Map<String, int> lastMessageReadData}) async {
    if (lastMessageReadData.isNotEmpty) {
      lastMessageReadData.forEach((key, value) {
        _lastMessageReadMap[key] = value;
      });

      final prefs = await SharedPreferences.getInstance();
      prefs.setString(
        prefKeyLastReadMap,
        jsonEncode(lastMessageReadData),
      );
    }
  }

  @override
  Future populateRamFromDb() async {
    if (_lastMessageReadMap.isEmpty) {
      final prefs = await SharedPreferences.getInstance();
      final lastReadJsonString = prefs.getString(prefKeyLastReadMap);
      if (lastReadJsonString?.isNotEmpty != true) return null;
      _lastMessageReadMap.clear();
      _lastMessageReadMap
          .addAll(Map<String, int>.from(jsonDecode(lastReadJsonString!)));
    }
  }

  @override
  Future clear() async {
    _lastMessageReadMap.clear();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(prefKeyLastReadMap);
  }
}
