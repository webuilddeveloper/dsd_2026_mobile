import 'dart:convert';
import 'dart:io';

import 'package:dsd/calendar/calendar_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

String fixture(String name) =>
    File('test/fixtures/calendar/$name').readAsStringSync();

void main() {
  test(
    'reads all three website categories, keeps ids, dates and Thai text',
    () async {
      final paths = <String>[];
      final source = CalendarSource(
        client: MockClient((request) async {
          paths.add(request.url.path);
          return http.Response.bytes(
            utf8.encode(fixture('${request.url.path.split('/').last}.html')),
            200,
          );
        }),
      );
      addTearDown(source.close);
      final events = await source.readEvents();
      expect(paths.toSet(), {
        '/DSD/Calendar/calendar_2',
        '/DSD/Calendar/calendar_3',
        '/DSD/Calendar/calendar_4',
      });
      expect(events.length, 6);
      expect(events.map((e) => e.category).toSet(), {2, 3, 4});
      final event = events.firstWhere((e) => e.id == '13241');
      expect(
        event.title,
        'การประยุกต์เทคโนโลยีปัญญาประดิษฐ์สำหรับงานโลจิสติกส์',
      );
      expect(event.start, DateTime(2026, 7, 27));
    },
  );

  test(
    'decodes HTML entities and escaped quotes without executing scripts',
    () {
      final events = CalendarSource.parseEvents(r'''successCallback([
      {id: '1', title: 'ทดสอบ &quot;AI&quot; \'hello\'', start: '2026-09-01',},
    ])''', 2);
      expect(events.single.title, 'ทดสอบ "AI" \'hello\'');
    },
  );

  test(
    'distinguishes empty calendar from changed markup or blocked responses',
    () {
      expect(CalendarSource.parseEvents('successCallback([])', 3), isEmpty);
      expect(
        () => CalendarSource.parseEvents('<html>Access denied</html>', 3),
        throwsFormatException,
      );
      expect(
        () => CalendarSource.parseEvents(
          "successCallback([{id: '1', name: 'changed'}])",
          3,
        ),
        throwsFormatException,
      );
    },
  );

  test('fails visibly if one category cannot be loaded', () async {
    final source = CalendarSource(
      client: MockClient((request) async {
        if (request.url.path.endsWith('_3')) {
          return http.Response('unavailable', 503);
        }
        return http.Response('successCallback([])', 200);
      }),
    );
    addTearDown(source.close);
    await expectLater(source.readEvents(), throwsStateError);
  });

  test('reads the website double-encoded detail and full date range', () {
    final event =
        CalendarSource.parseEvents(fixture('calendar_2.html'), 2).first;
    final detail = CalendarSource.parseDetail(fixture('detail.json'), event);
    expect(detail.end, DateTime(2026, 7, 30));
    expect(detail.department, 'สถาบันพัฒนาฝีมือแรงงาน 37 บุรีรัมย์');
    expect(detail.description, contains('โลจิสติกส์'));
    expect(detail.description, isNot(contains(r'\r\n')));
    expect(calendarDate(detail.start, true), '27 กรกฎาคม 2569');
    expect(calendarDate(detail.start, false), '27 July 2026');
  });

  test('rejects mismatched detail ids', () {
    expect(
      () => CalendarSource.parseDetail(
        fixture('detail.json'),
        CalendarEvent(id: '2', category: 2, title: '', start: DateTime(2026)),
      ),
      throwsFormatException,
    );
  });
}
