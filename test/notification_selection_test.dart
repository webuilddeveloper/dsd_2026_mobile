import 'package:dsd/notification/notification.dart';
import 'package:dsd/notification/notification_preferences.dart';
import 'package:dsd/shared/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({
      'app_locale': 'en',
      'notif_news': true,
      'notif_training': true,
      'notif_testing': false,
      'notif_privilege': false,
    });
    FlutterSecureStorage.setMockInitialValues({'profileCode': 'test-account'});
  });

  Future<void> open(
    WidgetTester tester,
    NotificationPreferences prefs,
    List<String> read, {
    bool fail = false,
  }) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => LocaleProvider(),
        child: MaterialApp(
          builder:
              (context, child) => MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  padding: const EdgeInsets.only(bottom: 34),
                  viewPadding: const EdgeInsets.only(bottom: 34),
                ),
                child: child!,
              ),
          home: Scaffold(
            extendBody: true,
            bottomNavigationBar: const SizedBox(key: Key('nav'), height: 106),
            body: NotificationList(
              preferences: prefs,
              fetch:
                  (_, type) async => [
                    for (var i = 0; i < (type == '2' ? 2 : 1); i++)
                      {
                        'code': '$type-$i',
                        'title': 'Item $type-$i',
                        'isRead': false,
                        'docDate': '20260916',
                      },
                  ],
              read: (item) async {
                if (fail) throw StateError('offline');
                read.add(item['code']);
              },
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'Edit selects items, select all scopes to current category, actions sit above nav',
    (tester) async {
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final prefs = NotificationPreferences();
      final read = <String>[];
      await open(tester, prefs, read);
      await tester.tap(find.text('News'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Edit'));
      await tester.pumpAndSettle();
      expect(find.text('Select all'), findsOneWidget);
      final actions = tester.getRect(
        find.byKey(const Key('notification-selection-actions')),
      );
      expect(
        actions.bottom,
        lessThan(tester.getRect(find.byKey(const Key('nav'))).top),
      );
      expect(
        tester
            .widget<FilledButton>(
              find.byWidgetPredicate((w) => w is FilledButton),
            )
            .onPressed,
        isNull,
      );
      await tester.tap(find.text('Item 2-0'));
      await tester.pumpAndSettle();
      expect(find.text('Read'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
      await tester.tap(find.text('Select all'));
      await tester.pumpAndSettle();
      expect(find.text('Read all'), findsOneWidget);
      expect(find.text('Delete all'), findsOneWidget);
      await tester.tap(find.text('Read all'));
      await tester.pumpAndSettle();
      expect(read, ['2-0', '2-1']);
      expect(find.byTooltip('Edit'), findsOneWidget);
      expect(
        find.byKey(const Key('notification-selection-actions')),
        findsNothing,
      );
      await tester.pumpWidget(const SizedBox());
      prefs.dispose();
    },
  );

  testWidgets(
    'deselect last keeps edit mode and delete persists only selected items',
    (tester) async {
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final prefs = NotificationPreferences();
      await open(tester, prefs, []);
      await tester.tap(find.byTooltip('Edit'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Item 2-0'));
      await tester.pump();
      await tester.tap(find.text('Item 2-0'));
      await tester.pump();
      expect(find.text('Select all'), findsOneWidget);
      await tester.tap(find.text('Item 2-0'));
      await tester.pump();
      await tester.tap(
        find.ancestor(
          of: find.text('Delete'),
          matching: find.byWidgetPredicate((w) => w is FilledButton),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ElevatedButton, 'Delete'));
      await tester.pumpAndSettle();
      expect(find.text('Item 2-0'), findsNothing);
      expect(find.text('Item 2-1'), findsOneWidget);
      expect(
        await const FlutterSecureStorage().read(
          key: 'deletedNotificationCodes',
        ),
        '["2_2-0"]',
      );
      await tester.pumpWidget(const SizedBox());
      prefs.dispose();
    },
  );

  testWidgets('failed read retains selection for retry', (tester) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final prefs = NotificationPreferences();
    await open(tester, prefs, [], fail: true);
    await tester.tap(find.byTooltip('Edit'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Item 2-0'));
    await tester.pump();
    await tester.tap(find.text('Read'));
    await tester.pumpAndSettle();
    expect(
      find.text('Could not mark 1 notification(s) as read. Please retry.'),
      findsOneWidget,
    );
    expect(
      tester
          .widget<OutlinedButton>(
            find.byWidgetPredicate((w) => w is OutlinedButton),
          )
          .onPressed,
      isNotNull,
    );
    await tester.pumpWidget(const SizedBox());
    prefs.dispose();
  });
}
