import 'package:dsd/news/news_html.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:html/parser.dart';

void main() {
  test(
    'removes broken markers in spans and anchor labels without altering href',
    () {
      final doc = parseFragment(
        normalizeNewsHtml(
          '<p>ข่าว ??? <span>ทดสอบ??</span><a href="https://example.com/?q=??">สมัคร???</a></p>',
        ),
      );
      expect(doc.text, isNot(contains('??')));
      expect(
        doc.querySelector('a')!.attributes['href'],
        'https://example.com/?q=??',
      );
    },
  );
  test(
    'preserves plain text line breaks and removes desktop paragraph constraints',
    () {
      final plain = parseFragment(
        normalizeNewsHtml('หัวข้อ\nรายละเอียด\nสมัคร'),
      );
      expect(plain.querySelectorAll('br'), hasLength(2));
      final doc = parseFragment(
        normalizeNewsHtml(
          '<p style="width:900px;height:20px;white-space:nowrap;color:red">ข่าว</p>',
        ),
      );
      expect(doc.querySelector('p')!.attributes['style'], 'color:red');
    },
  );
  test('removes damaged leading markers but keeps questions and URL queries', () {
    expect(
      cleanNewsText(
        '??? เปิดรับสมัคร\n?? เรียนฟรี\nสมัครได้ไหม?\nทำไม???\nhttps://example.com/?q=1',
      ),
      ' เปิดรับสมัคร\n เรียนฟรี\nสมัครได้ไหม?\nทำไม\nhttps://example.com/?q=1',
    );
  });
  test('decodes UTF16 emoji pairs and nested entities', () {
    expect(
      decodeNewsEntities('&#55357;&#56832; &amp;#xD83D;&amp;#xDE00;'),
      '😀 😀',
    );
    expect(cleanNewsText('&amp;nbsp;ข้อความ'), ' ข้อความ');
  });
  test('decodes nested entities without losing literal special characters', () {
    final doc = parseFragment(
      normalizeNewsHtml(
        '<p>&amp;nbsp; A &amp;amp; B &amp;#128512; &lt;ข้อความ&gt; &lt;&lt; &gt;&gt;</p>',
      ),
    );
    expect(doc.text, contains('A & B 😀 <ข้อความ> << >>'));
    expect(doc.querySelector('ข้อความ'), isNull);
  });
  test('does not linkify image attributes or nest existing anchors', () {
    final doc = parseFragment(
      normalizeNewsHtml(
        '<img src="https://example.com/a.png"><a href="https://example.com/?a=1&amp;b=2">www.example.com</a>',
      ),
    );
    expect(
      doc.querySelector('img')!.attributes['src'],
      'https://example.com/a.png',
    );
    expect(doc.querySelectorAll('a').length, 1);
    expect(
      doc.querySelector('a')!.attributes['href'],
      'https://example.com/?a=1&b=2',
    );
  });
  test('preserves balanced parentheses and converts markdown and www links', () {
    final doc = parseFragment(
      normalizeNewsHtml(
        'https://example.com/test_(one). [เปิด](https://example.com/a_(b)) www.example.com',
      ),
    );
    expect(
      doc.querySelectorAll('a').map((a) => a.attributes['href']).toList(),
      [
        'https://example.com/test_(one)',
        'https://example.com/a_(b)',
        'https://www.example.com',
      ],
    );
  });
  test('supports escaped markup and valid comments', () {
    final doc = parseFragment(
      normalizeNewsHtml('&lt;p&gt;ข่าว &amp;amp; ข้อมูล&lt;/p&gt;'),
    );
    expect(doc.querySelector('p')!.text, 'ข่าว & ข้อมูล');
    expect(
      parseFragment(normalizeNewsHtml('ก่อน<!-- hidden -->หลัง')).text,
      'ก่อนหลัง',
    );
  });
  test(
    'normalizes protocol relative URLs and preserves encoded query values',
    () {
      expect(
        newsLinkUri(' //example.com/?a=1&amp;amp;b=2 ')!.toString(),
        'https://example.com/?a=1&b=2',
      );
      expect(
        newsLinkUri('https://example.com/?next=a%26b')!.query,
        'next=a%26b',
      );
      expect(newsLinkUri('mailto:test@example.com')!.scheme, 'mailto');
      expect(newsLinkUri('javascript:alert(1)'), isNull);
      expect(newsLinkUri('/file.pdf'), isNull);
      expect(
        newsLinkUri(
          '/file.pdf',
          baseUri: Uri.parse('https://example.com/news/1'),
        )!.toString(),
        'https://example.com/file.pdf',
      );
    },
  );
}
