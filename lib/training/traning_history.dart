import 'package:dsd/blank_page/appbar.dart';
import 'package:dsd/blank_page/format.dart';
import 'package:dsd/shared/api_provider.dart';
import 'package:dsd/style_theme.dart';
import 'package:dsd/training/traning_history_detail.dart';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TrainingHistory extends StatefulWidget {
  const TrainingHistory({super.key});

  @override
  State<TrainingHistory> createState() => _TrainingHistoryState();
}

class _TrainingHistoryState extends State<TrainingHistory> {
  List<Map<String, dynamic>> training = [];
  bool isLoading = true;
  final storage = FlutterSecureStorage();

  void goBack() => Navigator.pop(context);

  @override
  void initState() {
    super.initState();
    _fetchTraining();
  }

  Future<void> _fetchTraining() async {
    final profileCode = await storage.read(key: 'profileCode');
    final data = await postDio('${trainingApi}read', {
      'limit': 3,
      'username': profileCode,
    });
    setState(() {
      training = (data as List).cast<Map<String, dynamic>>();
      isLoading = false;
    });
  }

  // รวมชั่วโมงทั้งหมด
  int get _totalHours => training.fold(
    0,
    (sum, item) => sum + ((item['duration'] as num?)?.toInt() ?? 0),
  );

  // badge สถานะ
  Widget _statusBadge(dynamic status) {
    final bool isDone = status == true || status == 1 || status == 'done';
    final bool isOngoing =
        status == false || status == 0 || status == 'ongoing';

    final String label =
        isDone
            ? 'ผ่านแล้ว'
            : isOngoing
            ? 'กำลังอบรม'
            : 'รอดำเนินการ';

    final Color bg =
        isDone
            ? const Color(0xFFEAF3DE)
            : isOngoing
            ? const Color(0xFFFAEEDA)
            : const Color(0xFFF1EFE8);

    final Color text =
        isDone
            ? const Color(0xFF27500A)
            : isOngoing
            ? const Color(0xFF633806)
            : const Color(0xFF5F5E5A);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          fontFamily: 'Kanit',
          color: text,
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 13, color: AppColors.primary),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontFamily: 'Kanit',
            color: AppColors.textgrey,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundMain,
      appBar: appBar(
        title: 'ประวัติการอบรม',
        backBtn: true,
        rightBtn: false,
        backAction: () => goBack(),
      ),
      body:
          isLoading
              ? const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              )
              : training.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.school_outlined,
                      size: 56,
                      color: AppColors.textgrey.withOpacity(0.4),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'ยังไม่มีประวัติการอบรม',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Kanit',
                        color: AppColors.textgrey,
                      ),
                    ),
                  ],
                ),
              )
              : ListView(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
                children: [
                  // ── Summary cards ──
                  Row(
                    children: [
                      Expanded(
                        child: _summaryCard(
                          label: 'หลักสูตรทั้งหมด',
                          value: '${training.length}',
                          valueColor: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _summaryCard(
                          label: 'รวมชั่วโมง',
                          value: '$_totalHours',
                          valueColor: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ── Section title ──
                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 18,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'รายการอบรม',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Kanit',
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // ── Training cards ──
                  ...training.map((item) => _trainingCard(item)).toList(),
                ],
              ),
    );
  }

  Widget _summaryCard({
    required String label,
    required String value,
    required Color valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontFamily: 'Kanit',
              color: AppColors.textgrey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              fontFamily: 'Kanit',
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _trainingCard(Map<String, dynamic> item) {
    return GestureDetector(
      onTap:
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TrainingHistoryDetail(item: item),
            ),
          ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title row + badge
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title'] ?? '-',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Kanit',
                          color: AppColors.textDark,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'รุ่นที่ ${item['generation'] ?? '-'} · ${item['agency'] ?? '-'}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'Kanit',
                          color: AppColors.textgrey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                _statusBadge(item['status2']),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1, color: AppColors.backgroundMain),
            const SizedBox(height: 10),

            // Date + Duration row
            Row(
              children: [
                Expanded(
                  child: _infoRow(
                    Icons.calendar_today_outlined,
                    '${formatDate(item['dateStart'])} – ${formatDate(item['dateEnd'])}',
                  ),
                ),
                _infoRow(
                  Icons.access_time_outlined,
                  '${item['duration']} ชั่วโมง',
                ),
              ],
            ),
          ],
        ),
      ), // Container
    ); // GestureDetector
  }
}
