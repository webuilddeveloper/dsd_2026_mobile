import 'package:dsd/notification/notification.dart';
import 'package:dsd/notification/notification_settings.dart';
import 'package:dsd/notification/notification_preferences.dart';
import 'package:dsd/shared/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => FlutterSecureStorage.setMockInitialValues({}));
  testWidgets('type switches work with a stored disabled master setting', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'app_locale': 'en',
      'notif_all': false,
    });
    final prefs = NotificationPreferences();
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => LocaleProvider(),
        child: MaterialApp(home: NotificationSettings(preferences: prefs)),
      ),
    );
    await tester.pumpAndSettle();
    final row =
        find
            .ancestor(
              of: find.text('Skill standard tests'),
              matching: find.byType(Row),
            )
            .first;
    final control = find.descendant(of: row, matching: find.byType(Switch));
    expect(tester.widget<Switch>(control).onChanged, isNotNull);
    expect(tester.widget<Switch>(control).value, false);
    await tester.ensureVisible(control);
    await tester.tap(control);
    await tester.pumpAndSettle();
    expect(tester.widget<Switch>(control).value, true);
    expect(prefs.enabledSignature, '4');
    await tester.tap(control);
    await tester.pumpAndSettle();
    expect(tester.widget<Switch>(control).value, false);
    expect(prefs.enabledSignature, isEmpty);
    await tester.pumpWidget(const SizedBox());
    prefs.dispose();
  });

  testWidgets(
    'settings change updates retained notification tab and hides disabled categories and items',
    (tester) async {
      SharedPreferences.setMockInitialValues({
        'app_locale': 'en',
        'notif_news': true,
      });
      final prefs = NotificationPreferences();
      final requests = <String>[];
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => LocaleProvider(),
          child: MaterialApp(
            home: NotificationList(
              preferences: prefs,
              fetch: (api, type) async {
                requests.add(type);
                return [
                  {
                    'code': type,
                    'title': 'Item $type',
                    'docDate': '20260916',
                    'isRead': false,
                  },
                ];
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(requests.toSet(), {'2', '3', '4', '5'});
      await tester.ensureVisible(find.text('Skill standard tests'));
      await tester.tap(find.text('Skill standard tests'));
      await tester.pumpAndSettle();
      expect(find.text('Item 4'), findsOneWidget);

      final navigator = tester.state<NavigatorState>(find.byType(Navigator));
      navigator.push(
        MaterialPageRoute(
          builder: (_) => NotificationSettings(preferences: prefs),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Skill standard tests'), findsOneWidget);
      final testingRow =
          find
              .ancestor(
                of: find.text('Skill standard tests'),
                matching: find.byType(Row),
              )
              .first;
      final testingSwitch = find.descendant(
        of: testingRow,
        matching: find.byType(Switch),
      );
      await tester.ensureVisible(testingSwitch);
      requests.clear();
      await tester.tap(testingSwitch);
      await tester.pumpAndSettle();
      navigator.pop();
      await tester.pumpAndSettle();
      expect(find.text('Skill standard tests'), findsNothing);
      expect(find.text('Item 4'), findsNothing);
      expect(find.text('Item 2'), findsOneWidget); // selection resets to All
      expect(requests, isNot(contains('4')));
      expect(
        (await SharedPreferences.getInstance()).getBool('notif_testing'),
        false,
      );

      requests.clear();
      await prefs.setValue('notif_all', false);
      await tester.pumpAndSettle();
      expect(
        find.text('All notification types are turned off'),
        findsOneWidget,
      );
      expect(find.text('News'), findsNothing);
      expect(find.text('Item 2'), findsNothing);
      expect(requests, isEmpty);
      await tester.pumpWidget(const SizedBox());
      prefs.dispose();
    },
  );
}
