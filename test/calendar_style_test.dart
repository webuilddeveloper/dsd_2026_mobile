import 'package:dsd/calendar/calendar_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('day selection animations retain valid decorations in every state', () {
    const style = activityCalendarStyle;
    final states = [
      style.defaultDecoration,
      style.weekendDecoration,
      style.outsideDecoration,
      style.disabledDecoration,
      style.holidayDecoration,
      style.withinRangeDecoration,
      style.rangeStartDecoration,
      style.rangeEndDecoration,
      style.todayDecoration,
      style.selectedDecoration,
    ];
    for (final from in states) {
      for (final to in states) {
        for (final progress in [0.0, 0.25, 0.5, 0.75, 1.0]) {
          final decoration = Decoration.lerp(from, to, progress)!;
          expect(decoration.debugAssertIsValid(), isTrue);
        }
      }
    }
  });
}
