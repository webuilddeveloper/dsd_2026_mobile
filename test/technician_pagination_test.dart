import 'package:dsd/technician/technician.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'requires both names, appends pages, retries same offset and resets search',
    (tester) async {
      final requests = <Map<String, dynamic>>[];
      var failMore = true;
      await tester.pumpWidget(
        MaterialApp(
          home: TechnicianPage(
            fetch: (body) async {
              requests.add(Map.of(body));
              final skip = body['skip'] as int;
              if (skip == 10 && failMore) {
                failMore = false;
                throw StateError('offline');
              }
              return {
                'status': 'S',
                'objectData': List.generate(
                  skip == 0 ? 10 : 2,
                  (i) => {'firstName': 'Person${skip + i}', 'lastName': 'Test'},
                ),
              };
            },
          ),
        ),
      );
      final fields = find.byType(TextField);
      final search = find.byWidgetPredicate((w) => w is ElevatedButton);
      await tester.enterText(fields.first, ' First ');
      await tester.pump();
      expect(tester.widget<ElevatedButton>(search).onPressed, isNull);
      await tester.enterText(fields.last, '   ');
      await tester.pump();
      expect(tester.widget<ElevatedButton>(search).onPressed, isNull);
      await tester.enterText(fields.last, ' Last ');
      await tester.pump();
      await tester.tap(search);
      await tester.pumpAndSettle();
      expect(requests.single, {
        'firstName': 'First',
        'lastName': 'Last',
        'skip': 0,
        'limit': 10,
      });
      final more = find.byKey(const Key('technician-load-more'));
      await tester.scrollUntilVisible(
        more,
        400,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(more);
      await tester.pumpAndSettle();
      expect(requests.last['skip'], 10);
      expect(tester.widget<OutlinedButton>(more).onPressed, isNotNull);
      await tester.ensureVisible(more);
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -200));
      await tester.pumpAndSettle();
      await tester.tap(more);
      await tester.pumpAndSettle();
      expect(requests.last['skip'], 10);
      expect(more, findsNothing);
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -600));
      await tester.pumpAndSettle();
      expect(find.text('Person11 Test'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.byWidgetPredicate(
          (w) => w is TextField && w.textInputAction == TextInputAction.next,
        ),
        -500,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Person0 Test'), findsOneWidget);
      await tester.enterText(fields.first, 'New');
      await tester.pump();
      await tester.ensureVisible(search);
      await tester.tap(search);
      await tester.pumpAndSettle();
      expect(requests.last, {
        'firstName': 'New',
        'lastName': 'Last',
        'skip': 0,
        'limit': 10,
      });
    },
  );
}
