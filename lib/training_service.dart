import 'package:dsd/blank_page/appbar.dart';
import 'package:dsd/model/training_service_data.dart';
import 'package:dsd/traning_detail_service.dart';
import 'package:flutter/material.dart';
import 'package:dsd/style_theme.dart';

class TrainingService extends StatefulWidget {
  const TrainingService({super.key});

  @override
  State<TrainingService> createState() => _TrainingServiceState();
}

class _TrainingServiceState extends State<TrainingService> {
  void goBack() {
    Navigator.pop(context, false);
  }

  final trainingList = TrainingDataService.getTraList();

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
          itemCount: trainingList.length,
          itemBuilder: (context, index) {
            final item = trainingList[index];

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
                    /// Title
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 6),

                    /// Batch
                    Text(item.batch, style: const TextStyle(fontSize: 15)),

                    const SizedBox(height: 4),

                    /// Organization
                    Text(
                      item.organization,
                      style: const TextStyle(fontSize: 15),
                    ),

                    const SizedBox(height: 12),

                    /// Date
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
                              '${item.startDate.day}/${item.startDate.month}/${item.startDate.year} ',
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
                              '${item.endDate.day}/${item.endDate.month}/${item.endDate.year} ',
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
                          'ระยะเวลาที่ฝึก : ${item.duration} ชั่วโมง',
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
                          item.isFull
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
                              item.isFull
                                  ? Colors.grey
                                  : const Color(0xff6FC546),
                        ),
                        child: Center(
                          child: Text(
                            item.isFull ? 'เต็ม' : 'สมัคร',
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
