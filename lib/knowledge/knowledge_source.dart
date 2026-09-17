import 'dart:convert';

import 'package:html/parser.dart' as html;
import 'package:http/http.dart' as http;

class KnowledgeCategory {
  final String title;
  final String titleEN;
  final Uri uri;
  const KnowledgeCategory(this.title, this.titleEN, this.uri);
}

/// Reads the public DSD bookshelf, like CalendarSource. No CMS API or DB.
class KnowledgeSource {
  static final baseUri = Uri.parse(
    'https://gcloud.dsd.go.th/~dsd-e-bookshelf/',
  );
  final http.Client _client;
  final _cache = <Uri, List<Map<String, dynamic>>>{};
  KnowledgeSource({http.Client? client}) : _client = client ?? http.Client();
  void close() => _client.close();

  static String decodeThai(List<int> bytes) {
    // The bookshelf declares TIS-620, not UTF-8.
    return String.fromCharCodes(
      bytes.map((b) => b >= 0xa1 && b <= 0xfb ? 0x0e01 + b - 0xa1 : b),
    );
  }

  static String encodeThaiQuery(String text) =>
      text.runes.map((r) {
        final b = r >= 0x0e01 && r <= 0x0e5b ? r - 0x0e01 + 0xa1 : r;
        if (b > 255) {
          throw const FormatException('Unsupported bookshelf category');
        }
        return '%${b.toRadixString(16).padLeft(2, '0').toUpperCase()}';
      }).join();

  Future<String> _get(Uri uri) async {
    if (uri.origin != baseUri.origin || !uri.path.startsWith(baseUri.path)) {
      throw const FormatException('Unexpected bookshelf URL');
    }
    final response = await _client
        .get(uri)
        .timeout(const Duration(seconds: 30));
    if (response.statusCode != 200) {
      throw StateError('DSD bookshelf HTTP ${response.statusCode}');
    }
    return decodeThai(response.bodyBytes);
  }

  Future<List<KnowledgeCategory>> readCategories() async {
    final home = html.parse(await _get(baseUri.resolve('index.php')));
    final shelves = <KnowledgeCategory>[];
    for (final title in ['หนังสือใหม่', 'หนังสือยอดนิยม']) {
      final headings = home
          .querySelectorAll('h4')
          .where((h) => h.text.trim() == title);
      final href =
          headings.isEmpty
              ? null
              : headings.first.parent
                  ?.querySelector('a[href]')
                  ?.attributes['href'];
      if (href == null) {
        throw const FormatException('DSD bookshelf sections changed');
      }
      shelves.add(
        KnowledgeCategory(
          title,
          title == 'หนังสือใหม่' ? 'New books' : 'Popular books',
          baseUri.resolve(href),
        ),
      );
    }
    return [
      ...shelves,
      ...parseCategories(await _get(baseUri.resolve('category.php'))),
    ];
  }

  static List<KnowledgeCategory> parseCategories(String source) {
    final names = html
        .parse(source)
        .querySelectorAll('.bookcard [id="catname"]');
    if (names.isEmpty) {
      throw const FormatException('DSD bookshelf categories changed');
    }
    return names.map((n) {
      final title = n.text.trim();
      if (title.isEmpty) throw const FormatException('Missing category title');
      return KnowledgeCategory(
        title,
        title,
        baseUri.resolve('search.php?search=${encodeThaiQuery(title)}'),
      );
    }).toList();
  }

  static List<Map<String, dynamic>> parseBooks(String source) {
    final document = html.parse(source);
    final books = <String, Map<String, dynamic>>{};
    for (final card in document.querySelectorAll('.bookcard')) {
      String value(String selector) =>
          card.querySelector(selector)?.attributes['value']?.trim() ?? '';
      final id = value('.bid');
      if (id.isEmpty) continue;
      final title = card.querySelector('.card-title')?.text.trim() ?? '';
      if (!RegExp(r'^\d+$').hasMatch(id) || title.isEmpty) {
        throw const FormatException('Invalid DSD book');
      }
      final cover = card.querySelector('img')?.attributes['src'] ?? '';
      books[id] = {
        'code': id,
        'title': title,
        'titleEN': title,
        'author': value('.cauthor'),
        'authorEN': value('.cauthor'),
        'description': const HtmlEscape().convert(value('.ctitle')),
        'descriptionEN': const HtmlEscape().convert(value('.ctitle')),
        'imageUrl':
            cover.startsWith('data:') || cover.isEmpty
                ? cover
                : baseUri.resolve(cover).toString(),
        'linkUrl': baseUri.resolve('read.php?rbid=$id').toString(),
        'bookType': 'PDF',
      };
    }
    if (books.isEmpty && !document.body!.text.contains('ไม่พบหนังสือ')) {
      throw const FormatException('DSD bookshelf listing changed');
    }
    return books.values.toList();
  }

  Future<List<Map<String, dynamic>>> readBooks(
    KnowledgeCategory category, {
    bool refresh = false,
  }) async {
    if (!refresh && _cache.containsKey(category.uri)) {
      return _cache[category.uri]!;
    }
    final pending = [category.uri];
    final visited = <Uri>{};
    final books = <String, Map<String, dynamic>>{};
    while (pending.isNotEmpty) {
      final uri = pending.removeAt(0);
      if (!visited.add(uri)) continue;
      if (visited.length > 1000) {
        throw const FormatException('Too many bookshelf pages');
      }
      final source = await _get(uri);
      for (final book in parseBooks(source)) {
        books[book['code'] as String] = book;
      }
      for (final a in html.parse(source).querySelectorAll('a[href]')) {
        final next = uri.resolve(a.attributes['href']!);
        if (next.path == category.uri.path &&
            RegExp(r'^\d+$').hasMatch(next.queryParameters['page'] ?? '')) {
          pending.add(next);
        }
      }
    }
    return _cache[category.uri] = books.values.toList();
  }

  Future<Map<String, dynamic>> readDetail(Map<String, dynamic> book) async {
    final id = book['code'] as String;
    if (!RegExp(r'^\d+$').hasMatch(id)) {
      throw const FormatException('Invalid book ID');
    }
    final page = await _get(baseUri.resolve('read.php?rbid=$id'));
    final path = RegExp(
      r'''\b(?:const|let|var)\s+pdfPath\s*=\s*['"]([^'"]+)['"]''',
    ).firstMatch(page)?.group(1);
    if (path == null) throw const FormatException('Missing book PDF');
    final pdf = baseUri.resolve(path);
    if (!['https', 'http'].contains(pdf.scheme)) {
      throw const FormatException('Invalid PDF link');
    }
    final rows = jsonDecode(await _get(baseUri.resolve('getcat.php?bid=$id')));
    if (rows is! List ||
        rows.any((r) => r is! Map || r['CATNAME'] is! String)) {
      throw const FormatException('Invalid book categories');
    }
    return {
      ...book,
      'fileUrl': pdf.toString(),
      'categoryList':
          rows
              .map((r) => {'title': r['CATNAME'], 'titleEN': r['CATNAME']})
              .toList(),
    };
  }
}
