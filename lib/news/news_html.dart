import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

// Decode entities without interpreting the decoded text as HTML tags.
String decodeNewsEntities(String value) {
  for (var i = 0; i < 4; i++) {
    // Some CMS exports encode emoji as two UTF-16 surrogate entities.
    value = value.replaceAllMapped(
      RegExp(
        r'&#(x[0-9a-f]+|[0-9]+);&#(x[0-9a-f]+|[0-9]+);',
        caseSensitive: false,
      ),
      (match) {
        int number(String raw) =>
            raw.toLowerCase().startsWith('x')
                ? int.parse(raw.substring(1), radix: 16)
                : int.parse(raw);
        final high = number(match[1]!);
        final low = number(match[2]!);
        if (high >= 0xD800 &&
            high <= 0xDBFF &&
            low >= 0xDC00 &&
            low <= 0xDFFF) {
          return String.fromCharCode(
            0x10000 + ((high - 0xD800) << 10) + low - 0xDC00,
          );
        }
        return match[0]!;
      },
    );
    final decoded = value.replaceAllMapped(
      RegExp(r'&(?:#[xX][0-9a-fA-F]+|#\d+|[a-zA-Z][a-zA-Z0-9]+);'),
      (match) => parser.parseFragment(match[0]!).text ?? match[0]!,
    );
    if (decoded == value) break;
    value = decoded;
  }
  return value;
}

/// Clean display text only; URL attributes are handled separately.
String cleanNewsText(String text) => decodeNewsEntities(text)
    .replaceAll('\uFEFF', '')
    .replaceAll('\u00A0', ' ')
    .replaceAll(RegExp(r'\?{2,}|\uFFFD+'), '')
    .replaceAll(RegExp(r'[ \t]{2,}'), ' ');

Uri? newsLinkUri(String? value, {Uri? baseUri}) {
  var link =
      decodeNewsEntities(
        value ?? '',
      ).replaceAll(RegExp('[\u200B\uFEFF]'), '').trim();
  if (link.isEmpty || link.startsWith('#')) return null;
  if (link.startsWith('//')) link = 'https:$link';
  if (link.toLowerCase().startsWith('www.')) link = 'https://$link';
  var uri = Uri.tryParse(link);
  if (uri == null) return null;
  if (!uri.hasScheme) {
    if (RegExp(r'^[^/\s]+\.[a-zA-Z]{2,}(?:[/:?#]|$)').hasMatch(link)) {
      uri = Uri.tryParse('https://$link');
    } else {
      uri = baseUri?.resolveUri(uri);
    }
  }
  if (uri == null ||
      ![
        'https',
        'http',
        'mailto',
        'tel',
        'sms',
      ].contains(uri.scheme.toLowerCase())) {
    return null;
  }
  if (['https', 'http'].contains(uri.scheme.toLowerCase()) &&
      uri.host.isEmpty) {
    return null;
  }
  return uri;
}

String normalizeNewsHtml(String source, {Uri? baseUri}) {
  // Some CMS records contain an escaped HTML document instead of HTML.
  if (!RegExp(r'<\s*[a-zA-Z][^>]*>').hasMatch(source) &&
      RegExp(
        r'&(?:amp;)*lt;/?(?:p|div|a|br|span|strong|ul|ol|h[1-6])(?:\s|&|/)',
        caseSensitive: false,
      ).hasMatch(source)) {
    source = decodeNewsEntities(source);
  }
  final fragment = parser.parseFragment(source);
  // Plain-text API records need explicit line breaks: HTML collapses newlines.
  final plainText = fragment.children.isEmpty;
  if (plainText) {
    final lines = (fragment.text ?? '').replaceAll('\r\n', '\n').split('\n');
    fragment.nodes.clear();
    for (var i = 0; i < lines.length; i++) {
      if (i > 0) fragment.append(dom.Element.tag('br'));
      fragment.append(dom.Text(lines[i]));
    }
  }
  final linkPattern = RegExp(
    r'''\[([^\]]+)\]\(((?:https?://|www\.)[^\s<>]*?(?:\([^\s<>]*?\)[^\s<>]*?)?)\)|(?:https?://|www\.)[^\s<>"']+''',
    caseSensitive: false,
  );
  void visit(dom.Node node, {bool linkify = true}) {
    if (node is dom.Comment) {
      node.remove();
      return;
    }
    if (node is dom.Element) {
      if (['script', 'style'].contains(node.localName)) {
        node.remove();
        return;
      }
      // CMS desktop dimensions/fonts can clip or stretch mobile paragraphs.
      if (['p', 'div', 'span', 'font'].contains(node.localName)) {
        node.attributes.remove('width');
        node.attributes.remove('height');
        node.attributes.remove('face');
        final style = node.attributes['style'];
        if (style != null) {
          node.attributes['style'] = style
              .split(';')
              .where(
                (rule) =>
                    !RegExp(
                      r'^\s*(width|min-width|max-width|height|min-height|max-height|white-space|text-indent|font-family|font-size|line-height|text-align|overflow)\s*:',
                      caseSensitive: false,
                    ).hasMatch(rule),
              )
              .join(';');
        }
      }
      if (node.localName == 'a') {
        final uri = newsLinkUri(node.attributes['href'], baseUri: baseUri);
        if (uri != null) node.attributes['href'] = uri.toString();
        linkify = false;
      }
      if (['code', 'pre'].contains(node.localName)) linkify = false;
    }
    if (node is dom.Text) {
      final text = decodeNewsEntities(node.data);
      if (!linkify) {
        node.data = cleanNewsText(text);
        return;
      }
      final replacements = <dom.Node>[];
      var end = 0;
      for (final match in linkPattern.allMatches(text)) {
        replacements.add(
          dom.Text(cleanNewsText(text.substring(end, match.start))),
        );
        final markdown = match[1] != null;
        var url = match[2] ?? match[0]!;
        var trailing = '';
        if (!markdown) {
          while (url.isNotEmpty) {
            final last = url[url.length - 1];
            final opening = {')': '(', ']': '[', '}': '{'}[last];
            final unbalanced =
                opening != null &&
                last.allMatches(url).length > opening.allMatches(url).length;
            if (!'.,!;'.contains(last) && !unbalanced) break;
            trailing = last + trailing;
            url = url.substring(0, url.length - 1);
          }
        }
        final uri = newsLinkUri(url, baseUri: baseUri);
        if (uri == null) {
          replacements.add(dom.Text(match[0]!));
        } else {
          replacements.add(
            dom.Element.tag('a')
              ..attributes['href'] = uri.toString()
              ..text = match[1] != null ? cleanNewsText(match[1]!) : url,
          );
          replacements.add(dom.Text(trailing));
        }
        end = match.end;
      }
      if (replacements.isEmpty) {
        node.data = cleanNewsText(text);
        return;
      }
      replacements.add(dom.Text(cleanNewsText(text.substring(end))));
      final parent = node.parentNode!;
      for (final replacement in replacements) {
        parent.insertBefore(replacement, node);
      }
      node.remove();
      return;
    }
    for (final child in node.nodes.toList()) {
      visit(child, linkify: linkify);
    }
  }

  visit(fragment);
  return fragment.outerHtml;
}
