import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const notificationTypes = [
  {
    'type': '2',
    'name': 'ข่าวสาร',
    'nameEN': 'News',
    'key': 'notif_news',
    'icon': 'assets/DSD/icon/icon news.png',
    'color': '0xffEFCD03',
  },
  {
    'type': '3',
    'name': 'หลักสูตรอบรม',
    'nameEN': 'Training courses',
    'key': 'notif_training',
    'icon': 'assets/DSD/icon/icon_training.png',
    'color': '0xFF956A08',
  },
  {
    'type': '4',
    'name': 'ทดสอบมาตรฐาน',
    'nameEN': 'Skill standard tests',
    'key': 'notif_testing',
    'icon': 'assets/DSD/icon/icons_skill.png',
    'color': '0xFFF18135',
  },
  {
    'type': '5',
    'name': 'สิทธิประโยชน์',
    'nameEN': 'Privileges',
    'key': 'notif_privilege',
    'icon': 'assets/DSD/icon/icons_privilege.png',
    'color': '0xFF4F1964',
  },
];

/// Shared by settings and the notification tab, including while in IndexedStack.
class NotificationPreferences extends ChangeNotifier {
  static final shared = NotificationPreferences();
  SharedPreferences? _prefs;
  Future<void>? _loading;
  final _values = <String, bool>{};
  bool get ready => _prefs != null;
  bool get all => value('notif_all');
  bool value(String key) =>
      _values[key] ?? (key != 'notif_news' && key != 'notif_vibration');
  bool typeEnabled(String type) =>
      all &&
      notificationTypes.any((t) => t['type'] == type && value(t['key']!));
  String get enabledSignature => notificationTypes
      .where((t) => typeEnabled(t['type']!))
      .map((t) => t['type'])
      .join(',');

  Future<void> load() => _loading ??= _load();
  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    for (final key in [
      'notif_all',
      'notif_sound',
      'notif_vibration',
      ...notificationTypes.map((t) => t['key']!),
    ]) {
      final stored = prefs.getBool(key);
      if (stored != null) _values[key] = stored;
    }
    _prefs = prefs;
    notifyListeners();
  }

  Future<void> setValue(String key, bool enabled) async {
    await load();
    // The old master switch is no longer shown in settings. When changing an
    // individual type, preserve the currently hidden state of the other types.
    if (!all && notificationTypes.any((type) => type['key'] == key)) {
      for (final type in notificationTypes) {
        final typeKey = type['key']!;
        if (!await _prefs!.setBool(typeKey, false)) {
          throw StateError('Unable to save notification preference');
        }
        _values[typeKey] = false;
      }
      if (!await _prefs!.setBool('notif_all', true)) {
        throw StateError('Unable to save notification preference');
      }
      _values['notif_all'] = true;
    }
    // SharedPreferences updates its in-memory cache synchronously before awaiting disk.
    final saved = _prefs!.setBool(key, enabled);
    _values[key] = enabled;
    notifyListeners();
    if (!await saved) {
      throw StateError('Unable to save notification preference');
    }
  }
}
