# DSD website calendar

The native Flutter calendar reads the FullCalendar event literals embedded in:

- https://www.dsd.go.th/DSD/Calendar/calendar_2 — training
- https://www.dsd.go.th/DSD/Calendar/calendar_3 — skill standard tests
- https://www.dsd.go.th/DSD/Calendar/calendar_4 — skills competitions

These are the three category iframes linked by https://www.dsd.go.th/DSD/Calendar.
The general activities category (`calendar_1`) is intentionally excluded.
The list and category requests no longer use the mobile eventCalendar API.
Details use `getShowCalendar/{id}` on the DSD website, the same request as its
activity modal, and no longer request the old mobile gallery API.

The parser reads data without executing JavaScript. Both calendar and list views
share category/search filters; markers follow the website's start-date behavior.
The detail view shows the full date range. Thai source content remains visible
when the app language is English because the source does not provide translations.

Scope is the events embedded by the website, not an unlimited historical archive.
On 2026-09-15 the pages exposed 120 training, 120 testing and 7 competition events.
Empty arrays are accepted; unexpected markup, blocked responses and failed
requests display a retry state rather than a misleading empty calendar.
If the website changes its JavaScript structure, update `parseEvents` and fixtures.

Validation:

```
flutter analyze lib/calendar test/calendar_source_test.dart
flutter test test/calendar_source_test.dart
```

Fixtures contain short samples from the public pages captured on 2026-09-15.
Android/iOS device testing is still needed to verify layout and connectivity on a
real device. Direct requests from Flutter Web may be subject to the website's CORS
policy; this integration targets the mobile app.
