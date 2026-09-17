import 'dart:async';
import 'package:dsd/knowledge/Knowledge.dart';
import 'package:dsd/knowledge/knowledge_cover.dart';
import 'package:dsd/knowledge/knowledge_source.dart';
import 'package:dsd/shared/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeSource extends KnowledgeSource {
  final newBooks = Completer<List<Map<String, dynamic>>>();
  bool fail = false;
  @override
  Future<List<KnowledgeCategory>> readCategories() async => [
    KnowledgeCategory(
      'หนังสือใหม่',
      'New books',
      Uri.parse('https://example.org/new'),
    ),
    KnowledgeCategory(
      'หนังสือยอดนิยม',
      'Popular books',
      Uri.parse('https://example.org/popular'),
    ),
  ];
  @override
  Future<List<Map<String, dynamic>>> readBooks(
    KnowledgeCategory category, {
    bool refresh = false,
  }) async {
    if (fail) throw StateError('offline');
    if (category.titleEN == 'New books') return newBooks.future;
    return [
      {'code': '2', 'title': 'Popular', 'imageUrl': ''},
    ];
  }
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({'app_locale': 'en'}));
  Future<void> open(WidgetTester tester, FakeSource source) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => LocaleProvider(),
        child: MaterialApp(home: KnowledgePage(source: source)),
      ),
    );
    await tester.pump();
    await tester.pump();
  }

  testWidgets('switching shelves ignores a stale response', (tester) async {
    final source = FakeSource();
    await open(tester, source);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.tap(find.text('Popular books'));
    await tester.pumpAndSettle();
    expect(find.byType(KnowledgeCover), findsOneWidget);
    source.newBooks.complete([]);
    await tester.pumpAndSettle();
    expect(find.byType(KnowledgeCover), findsOneWidget);
    expect(find.text('No books found'), findsNothing);
  });

  testWidgets('failed load offers retry and supports an empty result', (
    tester,
  ) async {
    final source = FakeSource()..fail = true;
    await open(tester, source);
    await tester.pumpAndSettle();
    expect(find.text('Unable to load books'), findsOneWidget);
    source.fail = false;
    source.newBooks.complete([]);
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(find.text('No books found'), findsOneWidget);
  });

  testWidgets('base64 covers use MemoryImage', (tester) async {
    const cover =
        'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVQIHWP4z8DwHwAFgAI/ScLbtAAAAABJRU5ErkJggg==';
    await tester.pumpWidget(
      const MaterialApp(home: KnowledgeCover(source: cover)),
    );
    expect(tester.widget<Image>(find.byType(Image)).image, isA<MemoryImage>());
    await tester.pumpAndSettle();
  });
}
