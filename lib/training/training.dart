import 'package:dsd/blank_page/appbar.dart';
import 'package:dsd/blank_page/format.dart';
import 'package:dsd/blank_page/launch.dart';
import 'package:dsd/blank_page/webview.dart';

import 'package:dsd/shared/api_provider.dart';
import 'package:dsd/shared/app_strings.dart';
// import 'package:dsd/training/traning_detail.dart';
import 'package:flutter/material.dart';
import 'package:dsd/style_theme.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TrainingService extends StatefulWidget {
  const TrainingService({super.key});

  @override
  State<TrainingService> createState() => _TrainingServiceState();
}

class _TrainingServiceState extends State<TrainingService> {
  void goBack() {
    Navigator.pop(context, false);
  }

  // final trainingList = TrainingDataService.getTraList();
  List<Map<String, dynamic>> training = [];
  bool isLoading = true;
  final storage = FlutterSecureStorage();
  @override
  void initState() {
    super.initState();
    _trainingApi();
  }

  /*===============================>> API <<=============================== */
  Future<void> _trainingApi() async {
    final data = await postDio('${trainingApi}readAPI', {"keySearch": "2569"});
    setState(() {
      training = (data as List).cast<Map<String, dynamic>>();

      isLoading = false;
    });
  }

  /*===============================>> API <<=============================== */

  List<Map<String, dynamic>> mockTraining = [
    {
      'trainingId': '0333454',
      'course': 'ช่างปูกระเบื้อง(ช่างปู)',
      'classNo': 1,
      'site': 'สถาบันพัฒนาฝีมือแรงงาน 42 หนองคาย',
      'dsdStartDate': '2026-07-06',
      'dsdEndDate': '2026-07-09',
      'period': 30,
      'status2': false,
    },
    {
      'trainingId': '0321757',
      'course': 'การใช้เทคโนโลยีเพื่อจัดการน้ำสำหรับโรงเรือนเกษตรอัจฉริยะ',
      'classNo': 2,
      'site': 'สำนักงานพัฒนาฝีมือแรงงานกาฬสินธุ์',
      'dsdStartDate': '2026-07-13',
      'dsdEndDate': '2026-07-17',
      'period': 18,
      'status2': false,
    },
    {
      'trainingId': '0327396',
      'course': 'การบำรุงรักษาเครื่องปรับอากาศในบ้านและการพาณิชย์ขนาดเล็ก',
      'classNo': 3,
      'site': 'สำนักงานพัฒนาฝีมือแรงงานเลย',
      'dsdStartDate': '2026-07-13',
      'dsdEndDate': '2026-07-17',
      'period': 30,
      'status2': false,
    },
    {
      'trainingId': '0326287',
      'course': 'การประกอบธุรกิจเครื่องดื่มมืออาชีพ',
      'classNo': 4,
      'site': 'สำนักงานพัฒนาฝีมือแรงงานเลย',
      'dsdStartDate': '2026-07-13',
      'dsdEndDate': '2026-07-17',
      'period': 30,
      'status2': true,
    },
    {
      'trainingId': '0333926',
      'course':
          'เทคนิคการเพาะเลี้ยงผึ้งโพรงป่าด้วยนวัตกรรมการอนุรักษ์เชิงธรรมชาติ',
      'classNo': 5,
      'site': 'สำนักงานพัฒนาฝีมือแรงงานเลย',
      'dsdStartDate': '2026-07-15',
      'dsdEndDate': '2026-07-17',
      'period': 18,
      'status2': false,
    },
    {
      'trainingId': '0328033',
      'course': 'พื้นฐานระบบปัญญาประดิษฐ์',
      'classNo': 6,
      'site': 'สำนักงานพัฒนาฝีมือแรงงานมหาสารคาม',
      'dsdStartDate': '2026-07-18',
      'dsdEndDate': '2026-07-26',
      'period': 30,
      'status2': true,
    },
  ];
  @override
  Widget build(BuildContext context) {
    final language = AppStrings.of(context); // ← ดึง strings ตาม locale
    return Scaffold(
      appBar: appBar(
        title: language.trainingCourses,
        backBtn: true,
        rightBtn: false,
        backAction: () => goBack(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: ListView.builder(
          // itemCount: training.length,
          itemCount: mockTraining.length, // ชั่วราว
          itemBuilder: (context, index) {
            // final item = training[index];
            final item = mockTraining[index]; // ชั่วราว

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['course'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'รุ่นที่ ${item['classNo'] ?? '-'}',
                      style: const TextStyle(fontSize: 15),
                    ),
                    const SizedBox(height: 4),
                    Text(item['site'], style: const TextStyle(fontSize: 15)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'assets/DSD/icon/icon_calendar_full.png',
                              color: AppColors.primary,
                              width: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              formatDate(item['dsdStartDate']),
                              style: const TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                        SizedBox(width: 8),
                        Row(
                          children: [
                            Image.asset(
                              'assets/DSD/icon/icon_calendar_full.png',
                              color: AppColors.primary,
                              width: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              formatDate(item['dsdEndDate']),
                              style: const TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Image.asset(
                          'assets/DSD/icon/icon date.png',
                          color: AppColors.primary,
                          width: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'ระยะเวลาที่ฝึก : ${item['period']} ชั่วโมง',
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(color: AppColors.backgroundMain),
                    const SizedBox(height: 16),

                    /// Button
                    InkWell(
                      onTap: () {
                        // final url = buildDsdUrl(training[index]);
                        final url = buildDsdUrl(item); // ชั่วคราว
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => WebViewPage(url: url),
                          ),
                        );
                      },
                      // item['status2'] == true
                      //     ? null
                      //     : () {
                      //       Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //           builder: (_) => TraningDetail(item: item),
                      //         ),
                      //       );
                      //     },
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color:
                              item['status2'] == true
                                  ? Colors.grey
                                  : const Color(0xff6FC546),
                        ),
                        child: Center(
                          child: Text(
                            item['status2'] == true ? 'สมัครแล้ว' : 'สมัคร',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
