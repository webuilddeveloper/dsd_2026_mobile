import 'package:dsd/notification/notification_preferences.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test(
    'a type can be enabled when legacy master is off without enabling others',
    () async {
      SharedPreferences.setMockInitialValues({
        'notif_all': false,
        'notif_training': true,
        'notif_testing': true,
        'notif_privilege': true,
      });
      final prefs = NotificationPreferences();
      await prefs.load();
      expect(prefs.enabledSignature, isEmpty);
      await prefs.setValue('notif_testing', true);
      expect(prefs.enabledSignature, '4');
      await prefs.setValue('notif_testing', false);
      expect(prefs.enabledSignature, isEmpty);
      final reloaded = NotificationPreferences();
      await reloaded.load();
      expect(reloaded.enabledSignature, isEmpty);
      prefs.dispose();
      reloaded.dispose();
    },
  );

  test('keeps existing flags and defaults new types to enabled', () async {
    SharedPreferences.setMockInitialValues({
      'notif_news': false,
      'notif_training': false,
    });
    final prefs = NotificationPreferences();
    await prefs.load();
    expect(prefs.typeEnabled('2'), false);
    expect(prefs.typeEnabled('3'), false);
    expect(prefs.typeEnabled('4'), true);
    expect(prefs.typeEnabled('5'), true);
    prefs.dispose();
  });

  test('master switch hides everything without losing type choices', () async {
    SharedPreferences.setMockInitialValues({'notif_news': true});
    final prefs = NotificationPreferences();
    await prefs.load();
    await prefs.setValue('notif_testing', false);
    await prefs.setValue('notif_all', false);
    expect(prefs.enabledSignature, isEmpty);
    await prefs.setValue('notif_all', true);
    expect(prefs.enabledSignature, '2,3,5');
    final reloaded = NotificationPreferences();
    await reloaded.load();
    expect(reloaded.enabledSignature, '2,3,5');
    prefs.dispose();
    reloaded.dispose();
  });
}
