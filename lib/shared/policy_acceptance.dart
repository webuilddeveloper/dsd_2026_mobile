import 'package:shared_preferences/shared_preferences.dart';

/// Account-scoped acknowledgement survives logout (secure storage is cleared).
class PolicyAcceptance {
  static String _key(String profileCode) => 'policyAccepted:$profileCode';

  static Future<bool> hasAccepted(String profileCode) async {
    if (profileCode.isEmpty) return false;
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key(profileCode)) ?? false;
  }

  static Future<void> remember(String profileCode) async {
    if (profileCode.isEmpty) throw StateError('Missing profile code');
    final prefs = await SharedPreferences.getInstance();
    if (!await prefs.setBool(_key(profileCode), true)) {
      throw StateError('Unable to save policy acknowledgement');
    }
  }
}
