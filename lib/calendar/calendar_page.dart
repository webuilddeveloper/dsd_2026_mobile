import 'package:dsd/blank_page/appbar.dart';
import 'package:dsd/calendar/calendar_detail.dart';
import 'package:dsd/calendar/calendar_source.dart';
import 'package:dsd/shared/app_strings.dart';
import 'package:dsd/shared/locale_provider.dart';
import 'package:dsd/style_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  final Function(int)? onTabChange;
  final bool pushedFromPage;

  const CalendarPage({
    super.key,
    this.onTabChange,
    this.pushedFromPage = false,
  });

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final _source = CalendarSource();
  final _search = TextEditingController();
  List<CalendarEvent> _events = [];
  bool _loading = true;
  bool _failed = false;
  bool _listMode = false;
  int? _category;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _source.close();
    _search.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _failed = false;
    });
    try {
      final events = await _source.readEvents();
      if (!mounted) return;
      setState(() {
        _events = events;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _failed = true;
        _loading = false;
      });
    }
  }

  List<CalendarEvent> get _filtered {
    final query = _search.text.trim().toLowerCase();
    return _events
        .where(
          (event) =>
              (_category == null || event.category == _category) &&
              event.title.toLowerCase().contains(query),
        )
        .toList();
  }

  // Match the website's markers: events are placed on their start date.
  List<CalendarEvent> _onDate(DateTime date) =>
      _filtered.where((event) => isSameDay(event.start, date)).toList();

  @override
  Widget build(BuildContext context) {
    final language = AppStrings.of(context);
    final thai = context.watch<LocaleProvider>().locale.languageCode == 'th';
    final locale = thai ? 'th' : 'en';
    final items =
        _listMode ? _filtered.reversed.toList() : _onDate(_selectedDay);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(
        title: language.calendar,
        righttitle: _listMode ? language.calendar : language.list,
        backBtn: true,
        rightBtn: true,
        backAction: () {
          if (widget.pushedFromPage) {
            Navigator.pop(context);
          } else {
            widget.onTabChange?.call(0);
          }
        },
        rightAction: () => setState(() => _listMode = !_listMode),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 8, 0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _search,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: thai ? 'ค้นหากิจกรรม' : 'Search events',
                      prefixIcon: const Icon(Icons.search),
                      border: const OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: thai ? 'โหลดข้อมูลใหม่' : 'Refresh',
                  onPressed: _loading ? null : _load,
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                ChoiceChip(
                  label: Text(thai ? 'ทั้งหมด' : 'All'),
                  selected: _category == null,
                  onSelected: (_) => setState(() => _category = null),
                ),
                for (final category in calendarCategories)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: ChoiceChip(
                      label: Text(thai ? category.title : category.titleEN),
                      selected: _category == category.id,
                      onSelected:
                          (_) => setState(() => _category = category.id),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child:
                _loading
                    ? const Center(child: CircularProgressIndicator())
                    : _failed
                    ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            thai
                                ? 'โหลดปฏิทินจากเว็บไซต์ไม่สำเร็จ'
                                : 'Unable to load the website calendar',
                          ),
                          TextButton(
                            onPressed: _load,
                            child: Text(thai ? 'ลองใหม่' : 'Retry'),
                          ),
                        ],
                      ),
                    )
                    : ListView(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      children: [
                        if (!_listMode) ...[
                          TableCalendar<CalendarEvent>(
                            locale: locale,
                            focusedDay: _focusedDay,
                            firstDay:
                                _events.isNotEmpty &&
                                        _events.first.start.isBefore(
                                          DateTime(2010),
                                        )
                                    ? _events.first.start
                                    : DateTime(2010),
                            lastDay:
                                _events.isNotEmpty &&
                                        _events.last.start.isAfter(
                                          DateTime(
                                            DateTime.now().year + 10,
                                            12,
                                            31,
                                          ),
                                        )
                                    ? _events.last.start
                                    : DateTime(
                                      DateTime.now().year + 10,
                                      12,
                                      31,
                                    ),
                            selectedDayPredicate:
                                (day) => isSameDay(day, _selectedDay),
                            onDaySelected:
                                (day, focused) => setState(() {
                                  _selectedDay = day;
                                  _focusedDay = focused;
                                }),
                            onPageChanged: (day) => _focusedDay = day,
                            eventLoader: _onDate,
                            headerStyle: HeaderStyle(
                              titleCentered: true,
                              formatButtonVisible: false,
                              titleTextFormatter:
                                  (date, _) =>
                                      calendarDate(date, thai, monthOnly: true),
                            ),
                            calendarStyle: CalendarStyle(
                              markersMaxCount: 1,
                              todayDecoration: BoxDecoration(
                                color: AppColors.primaryShade,
                                shape: BoxShape.circle,
                              ),
                              selectedDecoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '${calendarDate(_selectedDay, thai)} · ${items.length} ${language.activity}',
                          ),
                          const SizedBox(height: 8),
                        ],
                        if (items.isEmpty)
                          Padding(
                            padding: const EdgeInsets.all(24),
                            child: Center(
                              child: Text(
                                thai ? 'ไม่พบกิจกรรม' : 'No events found',
                              ),
                            ),
                          ),
                        for (final event in items)
                          Card(
                            color: AppColors.primaryShade,
                            child: ListTile(
                              leading: const Icon(Icons.event),
                              title: Text(event.title),
                              subtitle: Text(
                                '${calendarDate(event.start, thai)}\n${thai ? calendarCategories.firstWhere((c) => c.id == event.category).title : calendarCategories.firstWhere((c) => c.id == event.category).titleEN}',
                              ),
                              isThreeLine: true,
                              // onTap:
                              //     () => Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //         builder:
                              //             (_) => CalendarDetail(event: event),
                              //       ),
                              //     ),
                            ),
                          ),
                      ],
                    ),
          ),
        ],
      ),
    );
  }
}
