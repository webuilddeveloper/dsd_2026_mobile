import 'package:dsd/training/training_all.dart';
import 'package:dsd/shared/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets(
    'list and category failures retry independently and empty success is not an error',
    (tester) async {
      SharedPreferences.setMockInitialValues({'app_locale': 'en'});
      var listCalls = 0;
      var categoryCalls = 0;
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => LocaleProvider(),
          child: MaterialApp(
            home: TrainingAll(
              request: (url, body) async {
                if (url.endsWith('readAPI')) {
                  if (++listCalls == 1) throw Exception('offline');
                } else {
                  if (++categoryCalls == 1) throw Exception('offline');
                }
                return [];
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('offline'), findsNWidgets(2));
      expect(find.text('No data available'), findsNothing);
      await tester.tap(find.text('offline').first);
      await tester.pumpAndSettle();
      expect(categoryCalls, 2);
      expect(listCalls, 1);
      expect(find.text('offline'), findsOneWidget);
      await tester.tap(find.text('offline'));
      await tester.pumpAndSettle();
      expect(listCalls, 2);
      expect(find.text('No data available'), findsOneWidget);
      expect(find.text('offline'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
}
