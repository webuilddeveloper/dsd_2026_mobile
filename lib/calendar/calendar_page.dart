import 'package:dsd/blank_page/appbar.dart';
import 'package:dsd/blank_page/textfield.dart';
import 'package:dsd/calendar/calendar_detail.dart';

import 'package:dsd/shared/api_provider.dart';
import 'package:dsd/style_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  final Function(int)? onTabChange;
  final bool pushedFromPage;

  const CalendarPage({
    super.key,
    this.onTabChange,
    this.pushedFromPage = false, // 👈 default
  });

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  bool fromMenu = false;
  bool isLoading = true;
  List<Map<String, dynamic>> category = [];
  List<Map<String, dynamic>> eventCalendar = [];
  int selectedIndex = 0;
  DateTime selectedDay = DateTime.now();
  final TextEditingController calendarSearch = TextEditingController();

  void goBack() {
    // widget.onTabChange?.call(0);
    if (widget.pushedFromPage) {
      Navigator.pop(context);
    } else {
      widget.onTabChange?.call(0);
    }
  }

  static const List<String> _thaiMonths = [
    '',
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

  @override
  void initState() {
    _eventCalendarApi();
    _eventCalendarCategoryApi();
    super.initState();
  }

  /*===============================>> API <<=============================== */

  Future<void> _eventCalendarApi() async {
    final data = await postDio('${eventCalendarApi}read', {
      "permission": "all",
      "skip": 0,
      "limit": 10,
      "keySearch": "",
      "isHighlight": false,
      "category": "",
    });
    setState(() {
      eventCalendar = (data as List).cast<Map<String, dynamic>>();
    });

    // return (data as List).cast<Map<String, dynamic>>();
  }

  Future<void> _eventCalendarCategoryApi() async {
    final data = await postDio('${eventCalendarCategory}read', {'limit': 10});
    setState(() {
      // ✅ เพิ่ม "ทั้งหมด" ไว้ตัวแรกเสมอ
      category = [
        {'code': '', 'title': 'ทั้งหมด'},
        ...(data as List).cast<Map<String, dynamic>>(),
      ];
      isLoading = false;
    });
  }

  /*===============================>> API <<=============================== */
  List<Map<String, dynamic>> getFiltered() {
    List<Map<String, dynamic>> calendar = eventCalendar;

    // ✅ filter ตาม category code
    if (selectedIndex != 0) {
      final selectedCode = category[selectedIndex]['code'];
      calendar = calendar.where((e) => e['category'] == selectedCode).toList();
    }

    // 🔍 filter จาก search
    if (calendarSearch.text.isNotEmpty) {
      final keyword = calendarSearch.text.toLowerCase();
      calendar =
          calendar
              .where((e) => (e['title'] ?? '').toLowerCase().contains(keyword))
              .toList();
    }

    return calendar;
  }

  List<Map<String, dynamic>> getEventsByDate(DateTime date) {
    String formatted =
        "${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}";

    return eventCalendar.where((e) => e['dateStart'] == formatted).toList();
  }

  String formatThaiDate(DateTime date) {
    return "${date.day} ${_thaiMonths[date.month]} ${date.year + 543}";
  }

  @override
  Widget build(BuildContext context) {
    final events = getEventsByDate(selectedDay);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(
        title: "ปฏิทินกิจกรรม",
        backBtn: true,
        rightBtn: true,
        backAction: () => goBack(),
        rightAction: () {
          setState(() {
            fromMenu = !fromMenu;
          });
        },
      ),

      body:
          fromMenu == false
              ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      /// 📅 Calendar
                      TableCalendar(
                        focusedDay: selectedDay,
                        firstDay: DateTime(2020),
                        lastDay: DateTime(2030),
                        selectedDayPredicate:
                            (day) => isSameDay(day, selectedDay),
                        onDaySelected: (day, _) {
                          setState(() {
                            selectedDay = day;
                          });
                        },
                        headerStyle: HeaderStyle(
                          titleCentered: true,
                          formatButtonVisible: false,
                          titleTextFormatter: (date, locale) {
                            return '${_thaiMonths[date.month]} ${date.year + 543}';
                          },
                        ),

                        calendarStyle: CalendarStyle(
                          markersMaxCount: 1,

                          // วันที่เลือก
                          selectedDecoration: BoxDecoration(
                            color: Colors.amber,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(10),
                          ),

                          // วันนี้
                          todayDecoration: BoxDecoration(
                            color: AppColors.primaryShade,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(10),
                          ),

                          // วันปกติ (ต้องระบุด้วย ไม่งั้น default เป็น circle แล้ว animate ชน)
                          defaultDecoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(10),
                          ),

                          // วันหยุด
                          weekendDecoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(10),
                          ),

                          // วันนอกเดือน
                          outsideDecoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(10),
                          ),

                          // จุด marker — ใช้ circle ล้วน ไม่ใส่ borderRadius
                          markerDecoration: BoxDecoration(
                            border: Border.all(color: Colors.blueAccent),
                            shape: BoxShape.circle,
                          ),
                        ),
                        calendarBuilders: CalendarBuilders(
                          defaultBuilder: (context, day, focusedDay) {
                            return InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              child: Center(child: Text('${day.day}')),
                            );
                          },
                        ),
                        eventLoader: (day) {
                          return getEventsByDate(day);
                        },
                      ),

                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            formatThaiDate(selectedDay),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            '${events.length} กิจกรรม',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      /// 📦 List Events
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: events.length,
                        itemBuilder: (context, index) {
                          final item = events[index];

                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          CalendarDetail(calendarlist: item),
                                ),
                              );
                            },
                            child: Container(
                              // height: 115,
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.primaryShade,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item['title'],
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          maxLines: 2,
                                        ),
                                      ),
                                      // Text(
                                      // "เวลา ${item.time}",
                                      //   "'",
                                      //   style: const TextStyle(
                                      //     fontSize: 14,
                                      //     fontWeight: FontWeight.w400,
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // ✅ รูปภาพ - ไม่ต้องใช้ Expanded
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          item['imageUrl'],
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Container(
                                                    width: 80,
                                                    height: 80,
                                                    color: Colors.grey[300],
                                                  ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      // ✅ description - ใช้ Text + strip HTML แทน Html widget
                                      Expanded(
                                        child: Html(
                                          data: item['description'],
                                          style: {
                                            "body": Style(
                                              maxLines: 4,
                                              textOverflow:
                                                  TextOverflow.ellipsis,
                                              fontSize: FontSize(12),
                                              color: AppColors.textgrey,
                                            ),
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              )
              : isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildSearch(
                      hintText: "Search",
                      controller: calendarSearch,
                      rightBtn: true,
                      onFilterTap: () {},
                      onChanged: (value) => setState(() {}),
                    ),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      reverse: false,
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(category.length, (index) {
                          final isSelected = selectedIndex == index;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: InkWell(
                              onTap:
                                  () => setState(() => selectedIndex = index),
                              child: Container(
                                decoration: BoxDecoration(
                                  color:
                                      isSelected
                                          ? AppColors.primary
                                          : Colors.white,
                                  border: Border.all(
                                    color:
                                        isSelected
                                            ? Colors.white
                                            : AppColors.primary,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 4,
                                  ),
                                  child: Text(
                                    category[index]['title'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color:
                                          isSelected
                                              ? Colors.white
                                              : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          final news = getFiltered();

                          if (news.isEmpty) {
                            return const Center(child: Text("ไม่พบข้อมูล"));
                          }

                          return ListView.builder(
                            itemCount: news.length,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return Column(
                                  children: [
                                    buildHighlightCalendar(news.first),
                                    const SizedBox(height: 12),
                                  ],
                                );
                              }
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: AppColors.borderColor,
                                      width: 1,
                                    ),
                                  ),
                                  child: buildCalendarItem(news[index]),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  Widget buildHighlightCalendar(Map<String, dynamic> calendar) {
    return InkWell(
      onTap:
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CalendarDetail(calendarlist: calendar),
            ),
          ),
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: NetworkImage(calendar['imageUrl'] ?? ''), // ✅
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          padding: const EdgeInsets.all(12),
          alignment: Alignment.bottomLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                calendar['title'] ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Image.asset('assets/DSD/icon/icon date.png', width: 14),
                  const SizedBox(width: 6),
                  Text(
                    calendar['docDate'] ?? '',
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCalendarItem(Map<String, dynamic> calendar) {
    return InkWell(
      onTap:
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CalendarDetail(calendarlist: calendar),
            ),
          ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                // ✅
                calendar['imageUrl'] ?? '',
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder:
                    (_, __, ___) =>
                        Container(width: 80, height: 80, color: Colors.grey),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    calendar['title'] ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Image.asset(
                        'assets/DSD/icon/icon date.png',
                        width: 14,
                        color: AppColors.textgrey,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        calendar['docDate'] ?? '',
                        style: const TextStyle(
                          color: AppColors.textgrey,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
