import 'package:dsd/blank_page/appbar.dart';
import 'package:dsd/exan_service_datail.dart';
import 'package:dsd/model/exam_service_data.dart';
import 'package:dsd/style_theme.dart';
import 'package:flutter/material.dart';

class ExamService extends StatefulWidget {
  const ExamService({super.key});

  @override
  State<ExamService> createState() => _ExamServiceState();
}

class _ExamServiceState extends State<ExamService> {
  void goBack() {
    Navigator.pop(context, false);
  }

  final examList = ExamServiceData.getExamList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        title: "กำหนดการทดสอบมาตรฐานฝีมือแรงงาน",
        backBtn: true,
        rightBtn: false,
        backAction: () => goBack(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: ListView.builder(
          itemCount: examList.length,
          itemBuilder: (context, index) {
            final exam = examList[index];

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
                      exam.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 6),

                    /// Batch
                    Text(exam.batch, style: const TextStyle(fontSize: 15)),

                    const SizedBox(height: 4),

                    /// Organization
                    Text(
                      exam.organization,
                      style: const TextStyle(fontSize: 15),
                    ),

                    const SizedBox(height: 12),

                    /// Date
                    Row(
                      children: [
                        Image.asset(
                          'assets/DSD/icon/icon_calendar_full.png',
                          color: AppColors.primary,
                          width: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          exam.examDate,
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
                          exam.isFull
                              ? null
                              : () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => ExamDetailPage(exam: exam),
                                  ),
                                );
                              },
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color:
                              exam.isFull
                                  ? Colors.grey
                                  : const Color(0xff6FC546),
                        ),
                        child: Center(
                          child: Text(
                            exam.isFull ? 'เต็ม' : 'สมัคร',
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
