import 'dart:convert';

import 'package:html/parser.dart' as html;
import 'package:http/http.dart' as http;

class CalendarCategory {
  final int id;
  final String title;
  final String titleEN;
  const CalendarCategory(this.id, this.title, this.titleEN);
}

const calendarCategories = [
  CalendarCategory(2, 'ตารางฝึกอบรม', 'Training schedule'),
  CalendarCategory(3, 'ตารางทดสอบมาตรฐานฝีมือแรงงาน', 'Skill standard tests'),
  CalendarCategory(4, 'ตารางการแข่งขันฝีมือแรงงาน', 'Skills competitions'),
];

class CalendarEvent {
  final String id;
  final int category;
  final String title;
  final DateTime start;
  final DateTime? end;
  final String description;
  final String department;

  const CalendarEvent({
    required this.id,
    required this.category,
    required this.title,
    required this.start,
    this.end,
    this.description = '',
    this.department = '',
  });
}

/// Reads the event data embedded in the public DSD calendar pages.
/// No JavaScript is executed and no mobile calendar API is used.
class CalendarSource {
  static final baseUri = Uri.parse('https://www.dsd.go.th/DSD/Calendar/');
  final http.Client _client;
  CalendarSource({http.Client? client}) : _client = client ?? http.Client();

  void close() => _client.close();

  Future<String> _get(String path) async {
    final response = await _client
        .get(baseUri.resolve(path))
        .timeout(const Duration(seconds: 30));
    if (response.statusCode != 200) {
      throw StateError('DSD calendar HTTP ${response.statusCode}');
    }
    return utf8.decode(response.bodyBytes);
  }

  Future<List<CalendarEvent>> readEvents() async {
    final groups = await Future.wait(
      calendarCategories.map((category) async {
        return parseEvents(await _get('calendar_${category.id}'), category.id);
      }),
    );
    return groups.expand((group) => group).toList()
      ..sort((a, b) => a.start.compareTo(b.start));
  }

  static String _text(String value) => html.parseFragment(value).text ?? '';

  static List<CalendarEvent> parseEvents(String source, int category) {
    // The site's FullCalendar successCallback contains single-quoted JS
    // literals, not JSON. Restrict parsing to that array and never eval it.
    final array = RegExp(
      r'successCallback\s*\(\s*\[([\s\S]*?)\]\s*\)',
    ).firstMatch(source)?.group(1);
    if (array == null) {
      throw const FormatException('DSD calendar markup changed');
    }
    final pattern = RegExp(
      r"\{\s*id:\s*'([0-9]+)',\s*title:\s*'((?:\\.|[^'\\])*)',\s*start:\s*'([0-9]{4}-[0-9]{2}-[0-9]{2})',?\s*\}",
    );
    final events = <CalendarEvent>[];
    final seen = <String>{};
    for (final match in pattern.allMatches(array)) {
      final id = match.group(1)!;
      final title = match
          .group(2)!
          .replaceAllMapped(
            RegExp(r"\\(['\\nrt])"),
            (m) => switch (m.group(1)) {
              'n' => '\n',
              'r' => '\r',
              't' => '\t',
              _ => m.group(1)!,
            },
          );
      if (seen.add(id)) {
        events.add(
          CalendarEvent(
            id: id,
            category: category,
            title: _text(title),
            start: DateTime.parse(match.group(3)!),
          ),
        );
      }
    }
    // Do not silently report empty/partial data after a website format change.
    if (array
        .replaceAll(pattern, '')
        .replaceAll(RegExp(r'[\s,]'), '')
        .isNotEmpty) {
      throw const FormatException('Unrecognized DSD calendar event');
    }
    return events;
  }

  Future<CalendarEvent> readDetail(CalendarEvent event) async {
    return parseDetail(await _get('getShowCalendar/${event.id}'), event);
  }

  static CalendarEvent parseDetail(String source, CalendarEvent event) {
    dynamic data = jsonDecode(source);
    if (data is String) data = jsonDecode(data);
    final row = (data as List).first['Table'][0] as Map<String, dynamic>;
    if (row['ID'].toString() != event.id) {
      throw const FormatException('Unexpected DSD calendar detail');
    }
    return CalendarEvent(
      id: event.id,
      category: event.category,
      title: _text(row['CALENDAR_NAME'] as String? ?? event.title),
      start: DateTime.parse(row['CALENDAR_DATE_START'] as String),
      end: DateTime.tryParse(row['CALENDAR_DATE_END'] as String? ?? ''),
      department: _text(row['DEPT_NAME'] as String? ?? ''),
      description: (row['CALENDAR_DETAILS'] as String? ?? '')
          .replaceAll(r'\r\n', '\n')
          .replaceAll(r'\t', '\t'),
    );
  }
}

String calendarDate(DateTime date, bool thai, {bool monthOnly = false}) {
  const th = [
    'มกราคม',
    'กุมภาพันธ์',
    'มีนาคม',
    'เมษายน',
    'พฤษภาคม',
    'มิถุนายน',
    'กรกฎาคม',
    'สิงหาคม',
    'กันยายน',
    'ตุลาคม',
    'พฤศจิกายน',
    'ธันวาคม',
  ];
  const en = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  return '${monthOnly ? '' : '${date.day} '}${(thai ? th : en)[date.month - 1]} ${date.year + (thai ? 543 : 0)}';
}
