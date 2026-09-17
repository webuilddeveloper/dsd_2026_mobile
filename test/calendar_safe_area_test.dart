import 'package:dsd/calendar/calendar_page.dart';
import 'package:dsd/shared/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  for (final bottomInset in [0.0, 34.0]) {
    testWidgets(
      'calendar stays above navigation with bottom inset $bottomInset',
      (tester) async {
        SharedPreferences.setMockInitialValues({'app_locale': 'en'});
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        const navKey = Key('bottom-nav');
        await tester.pumpWidget(
          ChangeNotifierProvider(
            create: (_) => LocaleProvider(),
            child: MaterialApp(
              builder:
                  (context, child) => MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                      padding: EdgeInsets.only(bottom: bottomInset),
                      viewPadding: EdgeInsets.only(bottom: bottomInset),
                    ),
                    child: child!,
                  ),
              home: Scaffold(
                extendBody: true,
                body: const CalendarPage(),
                bottomNavigationBar: SizedBox(
                  key: navKey,
                  height: 72 + bottomInset,
                ),
              ),
            ),
          ),
        );
        await tester.pump();
        final safeArea = tester.widget<SafeArea>(
          find.descendant(
            of: find.byType(CalendarPage),
            matching: find.byWidgetPredicate(
              (w) => w is SafeArea && !w.top && w.bottom,
            ),
          ),
        );
        final content = tester.getRect(find.byWidget(safeArea.child));
        final nav = tester.getRect(find.byKey(navKey));
        expect(content.bottom, lessThanOrEqualTo(nav.top));
        expect(nav.top - content.bottom, lessThan(1));
        await tester.pumpWidget(const SizedBox());
        await tester.pump();
      },
    );
  }
}
