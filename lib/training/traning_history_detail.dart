import 'package:dsd/blank_page/appbar.dart';
import 'package:dsd/blank_page/format.dart';
import 'package:dsd/style_theme.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TrainingHistoryDetail extends StatelessWidget {
  final Map<String, dynamic> item;

  const TrainingHistoryDetail({super.key, required this.item});

  bool get _isDone =>
      item['status2'] == true ||
      item['status2'] == 1 ||
      item['status2'] == 'done';

  // สี theme ตาม status
  Color get _bgColor =>
      _isDone ? const Color(0xFFEAF3DE) : const Color(0xFFFAEEDA);
  Color get _iconColor =>
      _isDone ? const Color(0xFF3B6D11) : const Color(0xFF854F0B);
  Color get _badgeBg =>
      _isDone ? const Color(0xFFEAF3DE) : const Color(0xFFFAEEDA);
  Color get _badgeText =>
      _isDone ? const Color(0xFF27500A) : const Color(0xFF633806);
  String get _badgeLabel => _isDone ? 'ผ่านแล้ว' : 'กำลังอบรม';

  Future<void> _openCertificate(BuildContext context) async {
    final url = item['certificateUrl'] as String?;
    if (url == null || url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ไม่พบลิงก์ใบประกาศนียบัตร')),
      );
      return;
    }
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundMain,
      appBar: appBar(
        title: 'รายละเอียดการอบรม',
        backBtn: true,
        rightBtn: false,
        backAction: () => Navigator.pop(context),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
        children: [
          // ── Main info card ──
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title + badge
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
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Kanit',
                              color: AppColors.textDark,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'รุ่นที่ ${item['generation'] ?? '-'}',
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _badgeBg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _badgeLabel,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Kanit',
                          color: _badgeText,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(height: 1, color: AppColors.backgroundMain),
                const SizedBox(height: 16),

                // Info rows
                _infoRow(
                  icon: Icons.apartment_outlined,
                  label: 'หน่วยงาน',
                  value: item['agency'] ?? '-',
                ),
                const SizedBox(height: 12),
                _infoRow(
                  icon: Icons.calendar_today_outlined,
                  label: 'วันที่อบรม',
                  value:
                      '${formatDate(item['dateStart'])} – ${formatDate(item['dateEnd'])}',
                ),
                const SizedBox(height: 12),
                _infoRow(
                  icon: Icons.access_time_outlined,
                  label: 'ระยะเวลา',
                  value: '${item['duration'] ?? '-'} ชั่วโมง',
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // ── Certificate section ──
          if (_isDone) _certificateCard(context) else _pendingCard(),
        ],
      ),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: _bgColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 15, color: _iconColor),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontFamily: 'Kanit',
                  color: AppColors.textgrey,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontFamily: 'Kanit',
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _certificateCard(BuildContext context) {
    return GestureDetector(
      onTap: () => _openCertificate(context),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF3DE),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.description_outlined,
                size: 22,
                color: Color(0xFF3B6D11),
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ใบประกาศนียบัตร',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Kanit',
                      color: AppColors.textDark,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'กดเพื่อดูหรือดาวน์โหลด',
                    style: TextStyle(
                      fontSize: 11,
                      fontFamily: 'Kanit',
                      color: AppColors.textgrey,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF3DE),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.open_in_new_rounded,
                size: 15,
                color: Color(0xFF3B6D11),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pendingCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1EFE8),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 16,
            color: const Color(0xFF888780),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'ใบประกาศจะออกให้หลังผ่านการอบรม',
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'Kanit',
                color: Color(0xFF5F5E5A),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
