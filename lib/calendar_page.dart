import 'package:dsd/blank_page/appbar.dart';
import 'package:dsd/model/calendar_data.dart';
import 'package:dsd/style_theme.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  final Function(int)? onTabChange;
  const CalendarPage({super.key, this.onTabChange});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime selectedDay = DateTime.now();

  void goBack() {
    widget.onTabChange?.call(0);
  }

  List<Calendar> getEventsByDate(DateTime date) {
    String formatted =
        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

    return calendarList.where((e) => e.date == formatted).toList();
  }

  String formatThaiDate(DateTime date) {
    const months = [
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

    return "${date.day} ${months[date.month]} ${date.year + 543}";
  }

  @override
  Widget build(BuildContext context) {
    final events = getEventsByDate(selectedDay);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(
        title: "กำหนดการทดสอบมาตรฐานฝีมือแรงงาน",
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
                    const months = [
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

                    final year = date.year + 543; // 👈 แปลงเป็น พ.ศ.

                    return '${months[date.month]} $year';
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

              /// 📌 วันที่ + จำนวนกิจกรรม
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

                  return Container(
                    height: 115,
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
                            Text(
                              item.title,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "เวลา ${item.time}",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  item.image,
                                  width: 80,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              flex: 3,
                              child: Text(
                                item.description,
                                style: const TextStyle(
                                  color: AppColors.textgrey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // child:
                    // Row(
                    //   children: [
                    //     Image.asset(
                    //       item.image,
                    //       width: 80,
                    //       height: 60,
                    //       fit: BoxFit.cover,
                    //     ),
                    //     const SizedBox(width: 10),

                    //     Expanded(
                    //       child: Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           Text(
                    //             item.title,
                    //             style: const TextStyle(
                    //               fontWeight: FontWeight.bold,
                    //             ),
                    //           ),
                    //           const SizedBox(height: 4),
                    //           Text("เวลา ${item.time}"),
                    //         ],
                    //       ),
                    //     ),
                    //   ],
                    // ),
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
