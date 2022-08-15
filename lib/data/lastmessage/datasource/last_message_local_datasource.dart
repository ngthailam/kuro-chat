import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LastMessageLocalDataSource {
  // @param lastMessageReadData
  // key: channel id
  // int: last message createTimeEpoch
  void update({required Map<String, int> lastMessageReadData});

  int? getByChannelId(String channelId);

  Future persist();

  Future save({required Map<String, int> lastMessageReadData});

  Future populateRamCache();

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
  void update({required Map<String, int> lastMessageReadData}) {
    lastMessageReadData.forEach((key, value) {
      _lastMessageReadMap[key] = value;
    });
  }

  @override
  Future persist() async {
    if (_lastMessageReadMap.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          prefKeyLastReadMap, jsonEncode(_lastMessageReadMap));
    }
  }

  @override
  Future save({required Map<String, int> lastMessageReadData}) async {
    if (lastMessageReadData.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        prefKeyLastReadMap,
        jsonEncode(lastMessageReadData),
      );
    }
  }

  @override
  Future populateRamCache() async {
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
