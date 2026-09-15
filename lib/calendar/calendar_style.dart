import 'package:dsd/style_theme.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

// Day cells animate between states, so every state must use the same shape.
const _dayDecoration = BoxDecoration(
  shape: BoxShape.rectangle,
  borderRadius: BorderRadius.all(Radius.circular(8)),
);

const activityCalendarStyle = CalendarStyle(
  markersMaxCount: 1,
  defaultDecoration: _dayDecoration,
  weekendDecoration: _dayDecoration,
  outsideDecoration: _dayDecoration,
  disabledDecoration: _dayDecoration,
  holidayDecoration: BoxDecoration(
    shape: BoxShape.rectangle,
    borderRadius: BorderRadius.all(Radius.circular(8)),
    border: Border.fromBorderSide(
      BorderSide(color: Color(0xFF9FA8DA), width: 1.4),
    ),
  ),
  withinRangeDecoration: _dayDecoration,
  rangeStartDecoration: _selectedDecoration,
  rangeEndDecoration: _selectedDecoration,
  selectedDecoration: _selectedDecoration,
  todayDecoration: BoxDecoration(
    color: AppColors.primaryShade,
    shape: BoxShape.rectangle,
    borderRadius: BorderRadius.all(Radius.circular(8)),
  ),
);

const _selectedDecoration = BoxDecoration(
  color: AppColors.primary,
  shape: BoxShape.rectangle,
  borderRadius: BorderRadius.all(Radius.circular(8)),
);
