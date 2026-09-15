import 'package:dsd/blank_page/pdf_viewer_page.dart';
import 'package:dsd/knowledge/knowledge_detail.dart';
import 'package:dsd/shared/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({'app_locale': 'en'}));

  Future<void> showDetail(WidgetTester tester, String? url) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => LocaleProvider(),
        child: MaterialApp(
          home: KnowledgeDetail(
            code: 'test',
            model: {
              'title': 'เอกสารทดสอบ',
              'titleEN': 'Test document',
              'fileUrl': url,
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'Read opens a PDF reader, including uppercase extension and query',
    (tester) async {
      const url = 'https://example.com/document.PDF?download=1';
      await showDetail(tester, url);
      await Scrollable.ensureVisible(
        tester.element(find.text('Read')),
        alignment: 0.5,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Read'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.byType(PdfViewerPage), findsOneWidget);
      expect(tester.widget<PdfViewerPage>(find.byType(PdfViewerPage)).url, url);
      // Widget tests return HTTP 400: exercise the real load-failure callback.
      await tester.pumpAndSettle();
      expect(find.text('Unable to load PDF'), findsOneWidget);
      await tester.tap(find.text('Retry'));
      await tester.pump();
      expect(find.byType(SfPdfViewer), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
    },
  );

  testWidgets('Read with a missing URL shows a message without navigating', (
    tester,
  ) async {
    await showDetail(tester, null);
    await Scrollable.ensureVisible(
      tester.element(find.text('Read')),
      alignment: 0.5,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Read'));
    await tester.pump();
    expect(find.text('No valid document link available'), findsOneWidget);
    expect(find.byType(PdfViewerPage), findsNothing);
  });
}
