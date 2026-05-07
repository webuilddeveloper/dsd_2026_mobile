import 'package:dsd/blank_page/appbar.dart';
import 'package:dsd/blank_page/format.dart';

import 'package:dsd/shared/api_provider.dart';
import 'package:dsd/training/traning_detail.dart';
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
    print('##########_skilledLaborApi###########');
    final profileCode = await storage.read(key: 'profileCode');

    final data = await postDio('${trainingApi}read', {
      'limit': 10,
      "username": profileCode,
    });
    setState(() {
      training = (data as List).cast<Map<String, dynamic>>();
      print(training);
      isLoading = false;
    });
  }

  /*===============================>> API <<=============================== */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        title: "หลักสูตรฝึกอบรม",
        backBtn: true,
        rightBtn: false,
        backAction: () => goBack(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: ListView.builder(
          itemCount: training.length,
          itemBuilder: (context, index) {
            final item = training[index];

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
                      item['title'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 6),
                    Text(
                      'รุ่นที่ ${item['generation'] ?? '-'}',
                      style: const TextStyle(fontSize: 15),
                    ),
                    const SizedBox(height: 4),
                    Text(item['agency'], style: const TextStyle(fontSize: 15)),
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
                              // exam.examDate,
                              formatDate(item['dateStart']),
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
                              // exam.examDate,
                              formatDate(item['dateEnd']),
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
                          'ระยะเวลาที่ฝึก : ${item['duration']} ชั่วโมง',
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(color: AppColors.backgroundMain),
                    const SizedBox(height: 16),

                    /// Button
                    InkWell(
                      onTap:
                          item['status2'] == true
                              ? null
                              : () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => TraningDetail(item: item),
                                  ),
                                );
                              },
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
