import 'package:dsd/policy.dart';
import 'package:dsd/shared/policy_acceptance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    FlutterSecureStorage.setMockInitialValues({
      'profileCode': 'account-a',
      'profileFirstName': 'Test',
    });
  });
  Future<void> open(
    WidgetTester tester,
    Future<dynamic> Function(String, dynamic) request,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: PolicyPage(
          nextPage: const Scaffold(body: Text('Destination')),
          request: request,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Map<String, dynamic> policy({bool short = false}) => {
    'status': 'S',
    'objectData': [
      {
        'code': 'policy-1',
        'title': 'เงื่อนไขการใช้งาน',
        'description':
            short
                ? '<p>ข้อกำหนด</p>'
                : List.generate(
                  80,
                  (i) =>
                      '<p>ข้อกำหนดข้อที่ $i โปรดอ่านรายละเอียดก่อนยอมรับ</p>',
                ).join(),
      },
    ],
  };

  testWidgets(
    'jump scrolls to bottom but does not check consent automatically',
    (tester) async {
      dynamic posted;
      await open(tester, (url, body) async {
        if (url.endsWith('read')) {
          expect(body['username'], 'account-a');
          return policy();
        }
        posted = body;
        return {'status': 'S'};
      });
      expect(
        tester.widget<CheckboxListTile>(find.byType(CheckboxListTile)).enabled,
        false,
      );
      await tester.tap(find.text('เลื่อนไปท้ายเงื่อนไข'));
      await tester.pumpAndSettle();
      final tile = tester.widget<CheckboxListTile>(
        find.byType(CheckboxListTile),
      );
      expect(tile.enabled, true);
      expect(tile.value, false);
      final scroll = tester.widget<SingleChildScrollView>(
        find.byType(SingleChildScrollView),
      );
      expect(scroll.controller!.position.extentAfter, lessThanOrEqualTo(10));
      await tester.tap(find.byType(CheckboxListTile));
      await tester.pump();
      await tester.tap(find.widgetWithText(ElevatedButton, 'ยอมรับ'));
      await tester.pumpAndSettle();
      expect(posted['username'], 'account-a');
      expect(posted['reference'], 'policy-1');
      expect(posted['isActive'], true);
      expect(await PolicyAcceptance.hasAccepted('account-a'), true);
      expect(find.text('Destination'), findsOneWidget);
    },
  );

  testWidgets('same account skips after logout; different account does not', (
    tester,
  ) async {
    await PolicyAcceptance.remember('account-a');
    await const FlutterSecureStorage().deleteAll();
    FlutterSecureStorage.setMockInitialValues({'profileCode': 'account-a'});
    await open(
      tester,
      (_, __) async => throw StateError('Should not request policy'),
    );
    expect(find.text('Destination'), findsOneWidget);
    expect(await PolicyAcceptance.hasAccepted('account-b'), false);
  });

  testWidgets('short policy enables checkbox without unnecessary scrolling', (
    tester,
  ) async {
    await open(tester, (_, __) async => policy(short: true));
    expect(
      tester.widget<CheckboxListTile>(find.byType(CheckboxListTile)).enabled,
      true,
    );
    expect(
      tester.widget<CheckboxListTile>(find.byType(CheckboxListTile)).value,
      false,
    );
  });

  testWidgets('failed acceptance does not mark the account as accepted', (
    tester,
  ) async {
    await open(
      tester,
      (url, _) async =>
          url.endsWith('read')
              ? policy(short: true)
              : {'status': 'E', 'message': 'บันทึกไม่สำเร็จ'},
    );
    await tester.tap(find.byType(CheckboxListTile));
    await tester.pump();
    await tester.tap(find.widgetWithText(ElevatedButton, 'ยอมรับ'));
    await tester.pumpAndSettle();
    expect(await PolicyAcceptance.hasAccepted('account-a'), false);
    expect(find.text('Destination'), findsNothing);
  });

  testWidgets(
    'server returning no pending policy proceeds without consent write',
    (tester) async {
      await open(tester, (url, _) async {
        expect(url.endsWith('read'), true);
        return {'status': 'S', 'objectData': []};
      });
      expect(find.text('Destination'), findsOneWidget);
      expect(await PolicyAcceptance.hasAccepted('account-a'), false);
    },
  );
}
