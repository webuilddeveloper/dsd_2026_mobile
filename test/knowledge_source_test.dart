import 'dart:convert';
import 'package:dsd/knowledge/knowledge_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

List<int> thai(String text) =>
    text.runes
        .map((r) => r >= 0xe01 && r <= 0xe5b ? r - 0xe01 + 0xa1 : r)
        .toList();
String card(String id, String title) =>
    '<div class="bookcard"><input class="bid" value="$id"><input class="cauthor" value="กรมพัฒนาฝีมือแรงงาน"><input class="ctitle" value="คำอธิบาย"><h5 class="card-title">$title</h5><img src="data:image/png;base64,AA=="></div>';

void main() {
  test('TIS-620 decoding and query encoding preserve Thai', () {
    expect(
      KnowledgeSource.decodeThai(thai('เทคโนโลยียานยนต์')),
      'เทคโนโลยียานยนต์',
    );
    final category =
        KnowledgeSource.parseCategories(
          '<div class="bookcard"><span id="catname">ช่างยนต์</span> (0)</div>',
        ).single;
    expect(
      category.uri.toString(),
      contains('search=%AA%E8%D2%A7%C2%B9%B5%EC'),
    );
  });

  test('shelves first, paginated books deduplicated and cache refreshable', () async {
    var listingRequests = 0;
    final source = KnowledgeSource(
      client: MockClient((request) async {
        final path = request.url.path.split('/').last;
        String body;
        switch (path) {
          case 'index.php':
            body =
                '<div><h4>หนังสือใหม่</h4><a href="new.php">ดูทั้งหมด</a></div><div><h4>หนังสือยอดนิยม</h4><a href="recommended.php">ดูทั้งหมด</a></div>';
          case 'category.php':
            body =
                '<div class="bookcard"><span id="catname">ช่างยนต์</span> (2)</div>';
          default:
            listingRequests++;
            body =
                request.url.queryParameters['page'] == '2'
                    ? card('1', 'เล่มหนึ่ง') + card('2', 'เล่มสอง')
                    : '${card('1', 'เล่มหนึ่ง')}<a href="new.php?page=2">2</a>';
        }
        return http.Response.bytes(thai(body), 200);
      }),
    );
    addTearDown(source.close);
    final categories = await source.readCategories();
    expect(categories.map((c) => c.title), [
      'หนังสือใหม่',
      'หนังสือยอดนิยม',
      'ช่างยนต์',
    ]);
    expect((await source.readBooks(categories.first)).map((b) => b['code']), [
      '1',
      '2',
    ]);
    await source.readBooks(categories.first);
    expect(listingRequests, 2);
    await source.readBooks(categories.first, refresh: true);
    expect(listingRequests, 4);
  });

  test(
    'detail resolves PDF and category names without count endpoints',
    () async {
      final requested = <String>[];
      final source = KnowledgeSource(
        client: MockClient((r) async {
          requested.add(r.url.path.split('/').last);
          return http.Response(
            r.url.path.endsWith('read.php')
                ? "const pdfPath = 'book/test.pdf';"
                : '[{"CATNAME":"\\u0e01"}]',
            200,
          );
        }),
      );
      addTearDown(source.close);
      final result = await source.readDetail(
        KnowledgeSource.parseBooks(card('201', 'ทดสอบ')).single,
      );
      expect(result['fileUrl'], '${KnowledgeSource.baseUri}book/test.pdf');
      expect(result['categoryList'], [
        {'title': 'ก', 'titleEN': 'ก'},
      ]);
      expect(requested, ['read.php', 'getcat.php']);
    },
  );

  test('empty category is distinct from broken markup', () {
    expect(KnowledgeSource.parseBooks('<div>ไม่พบหนังสือ</div>'), isEmpty);
    expect(
      () => KnowledgeSource.parseBooks('<html>Unavailable</html>'),
      throwsFormatException,
    );
    expect(
      () => KnowledgeSource.parseCategories('<html>Unavailable</html>'),
      throwsFormatException,
    );
  });

  test('listing retains base64 cover and escapes plain text description', () {
    final book = KnowledgeSource.parseBooks(card('1', 'หนังสือ')).single;
    expect(book['imageUrl'], startsWith('data:image/'));
    expect(book['titleEN'], 'หนังสือ');
    expect(book['description'], 'คำอธิบาย');
  });

  test('HTTP failures are surfaced', () async {
    final source = KnowledgeSource(
      client: MockClient((r) async => http.Response(utf8.decode([101]), 503)),
    );
    addTearDown(source.close);
    await expectLater(source.readCategories(), throwsStateError);
  });
}
