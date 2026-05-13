import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dsd/blank_page/appbar.dart';
import 'package:dsd/blank_page/format.dart';
import 'package:dsd/shared/api_provider.dart';
import 'package:dsd/style_theme.dart';
import 'package:dsd/training/traning_history_detail.dart';

class TrainingHistory extends StatefulWidget {
  const TrainingHistory({super.key});

  @override
  State<TrainingHistory> createState() => _TrainingHistoryState();
}

class _TrainingHistoryState extends State<TrainingHistory> {
  final storage = const FlutterSecureStorage();

  List<Map<String, dynamic>> training = [];
  bool isLoading = true;

  void goBack() => Navigator.pop(context);

  @override
  void initState() {
    super.initState();
    _fetchTraining();
  }

  /* ================= API ================= */

  Future<void> _fetchTraining() async {
    final idcard = await storage.read(key: 'idcard');

    final data = await postDio('${trainingApi}readAPIPersonal', {
      "keySearch": idcard,
    });

    setState(() {
      training = (data as List).cast<Map<String, dynamic>>();
      isLoading = false;
    });
  }

  /* ================= CALCULATE ================= */

  int get totalHours => training.fold(
    0,
    (sum, item) => sum + ((item['period'] as num?)?.toInt() ?? 0),
  );

  /* ================= STATUS ================= */

  Widget statusBadge(int status) {
    String label;
    Color bg;
    Color text;

    switch (status) {
      case 1:
        label = 'รอการตรวจสอบ';
        bg = const Color(0xFFF1EFE8);
        text = const Color(0xFF5F5E5A);
        break;
      case 2:
        label = 'รออนุมัติ';
        bg = const Color(0xFFFFF3CD);
        text = const Color(0xFF856404);
        break;
      case 3:
        label = 'รอคัดเลือก';
        bg = const Color(0xFFD1ECF1);
        text = const Color(0xFF0C5460);
        break;
      case 4:
        label = 'ไม่ผ่าน';
        bg = const Color(0xFFF8D7DA);
        text = const Color(0xFF721C24);
        break;
      case 5:
        label = 'ยกเลิกรุ่น';
        bg = const Color(0xFFE2E3E5);
        text = const Color(0xFF383D41);
        break;
      case 6:
        label = 'ติดต่อแล้ว';
        bg = const Color(0xFFEAF3DE);
        text = const Color(0xFF27500A);
        break;
      case 7:
        label = 'ติดต่อไม่ได้';
        bg = const Color(0xFFFFE5E5);
        text = const Color(0xFFB00020);
        break;
      default:
        label = 'ไม่ทราบสถานะ';
        bg = Colors.grey.shade200;
        text = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: TextStyle(fontSize: 11, color: text)),
    );
  }

  /* ================= UI ================= */

  Widget infoRow(IconData icon, String text) {
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

  Widget summaryCard(String label, String value, Color color) {
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
            style: const TextStyle(fontSize: 11, color: AppColors.textgrey),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget trainingCard(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => TrainingHistoryDetail(item: item)),
        );
      },
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
            /// 🔥 title + status
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['course'] ?? '-',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'รุ่นที่ ${item['classNo'] ?? '-'} · ${item['provinceName'] ?? '-'}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textgrey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                statusBadge(int.tryParse(item['statusCheck'].toString()) ?? 0),
              ],
            ),

            const SizedBox(height: 12),
            const Divider(height: 1, color: AppColors.backgroundMain),
            const SizedBox(height: 10),

            /// 🔥 date + hours
            Row(
              children: [
                Expanded(
                  child: infoRow(
                    Icons.calendar_today_outlined,
                    '${formatDate(item['dsdStartDate'])} - ${formatDate(item['dsdEndDate'])}',
                  ),
                ),
                infoRow(
                  Icons.access_time_outlined,
                  '${item['period'] ?? 0} ชม.',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /* ================= BUILD ================= */

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
              ? const Center(child: CircularProgressIndicator())
              : training.isEmpty
              ? const Center(child: Text('ยังไม่มีข้อมูล'))
              : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  /// 🔥 summary
                  Row(
                    children: [
                      Expanded(
                        child: summaryCard(
                          'หลักสูตรทั้งหมด',
                          '${training.length}',
                          AppColors.textDark,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: summaryCard(
                          'รวมชั่วโมง',
                          '$totalHours',
                          AppColors.primary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// 🔥 title
                  const Text(
                    'รายการอบรม',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),

                  const SizedBox(height: 12),

                  /// 🔥 list
                  ...training.map((e) => trainingCard(e)).toList(),
                ],
              ),
    );
  }
}
