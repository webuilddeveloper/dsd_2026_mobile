import 'package:dsd/blank_page/appbar.dart';
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
  DateTime selectedDay = DateTime.now();

  void goBack() {
    if (widget.pushedFromPage) {
      Navigator.pop(context); // มาจาก ServiceAllPage → pop กลับ
    } else {
      widget.onTabChange?.call(0); // มาจาก Menu/Home → switch tab
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
    super.initState();
  }

  List<Map<String, dynamic>> eventCalendar = [];

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
        rightBtn: false,
        backAction: () => goBack(),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              /// 📅 Calendar
              TableCalendar(
                focusedDay: selectedDay,
                firstDay: DateTime(2020),
                lastDay: DateTime(2030),
                selectedDayPredicate: (day) => isSameDay(day, selectedDay),
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                  Text(
                    '${events.length} กิจกรรม',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
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
                              (context) => CalendraDetail(calendarlist: item),
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
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                      (context, error, stackTrace) => Container(
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
                                      textOverflow: TextOverflow.ellipsis,
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
      ),
    );
  }
}
