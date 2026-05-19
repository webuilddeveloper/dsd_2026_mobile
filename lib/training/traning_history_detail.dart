import 'package:dsd/blank_page/appbar.dart';
import 'package:dsd/blank_page/format.dart';
import 'package:dsd/shared/app_strings.dart';
import 'package:dsd/style_theme.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TrainingHistoryDetail extends StatelessWidget {
  final Map<String, dynamic> item;

  const TrainingHistoryDetail({super.key, required this.item});

  /* ================= HELPERS ================= */

  int toInt(dynamic value) {
    return int.tryParse(value.toString()) ?? 0;
  }

  int get status => toInt(item['statusCheck']);

  bool get isSuccess => status == 6;

  /* ================= STATUS UI ================= */

  String statusLabel(AppStrings language) {
    switch (status) {
      case 1:
        return language.statusPendingReview;
      case 2:
        return language.statusPendingApproval;
      case 3:
        return language.statusPendingSelection;
      case 4:
        return language.statusFailed;
      case 5:
        return language.statusCancelled;
      case 6:
        return language.statusContacted;
      case 7:
        return language.statusNotContacted;
      default:
        return language.statusUnknown;
    }
  }

  Color get badgeBg {
    switch (status) {
      case 6:
        return const Color(0xFFEAF3DE);
      case 4:
      case 5:
      case 7:
        return const Color(0xFFF8D7DA);
      default:
        return const Color(0xFFF1EFE8);
    }
  }

  Color get badgeText {
    switch (status) {
      case 6:
        return const Color(0xFF27500A);
      case 4:
      case 5:
      case 7:
        return const Color(0xFF721C24);
      default:
        return const Color(0xFF5F5E5A);
    }
  }

  /* ================= CERTIFICATE ================= */

  Future<void> openCertificate(BuildContext context) async {
    final url = item['certificateUrl'] as String?;

    if (url == null || url.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('ไม่พบใบประกาศ')));
      return;
    }

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  /* ================= UI ================= */

  @override
  Widget build(BuildContext context) {
    final language = AppStrings.of(context);
    return Scaffold(
      backgroundColor: AppColors.backgroundMain,
      appBar: appBar(
        title: language.trainingDetails,
        backBtn: true,
        rightBtn: false,
        backAction: () => Navigator.pop(context),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          /// 🔥 main card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// title + status
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
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${language.batchNo} ${item['classNo'] ?? '-'}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textgrey,
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// status badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: badgeBg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        statusLabel(language),
                        style: TextStyle(fontSize: 11, color: badgeText),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                const Divider(height: 1, color: AppColors.backgroundMain),
                const SizedBox(height: 16),

                /// info
                _infoRow(
                  Icons.apartment_outlined,
                  language.organization,
                  item['provinceName'] ?? '-',
                ),
                const SizedBox(height: 12),

                _infoRow(
                  Icons.calendar_today_outlined,
                  language.trainingDate,
                  '${formatDate(item['dsdStartDate'] ?? '')} - ${formatDate(item['dsdEndDate'] ?? '')}',
                ),
                const SizedBox(height: 12),

                _infoRow(
                  Icons.access_time_outlined,
                  language.duration,
                  '${toInt(item['period'])} ${language.hours}',
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          /// 🔥 certificate
          isSuccess ? _certificateCard(context) : _pendingCard(context),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          '$label : ',
          style: const TextStyle(fontSize: 12, color: AppColors.textgrey),
        ),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 13))),
      ],
    );
  }

  Widget _certificateCard(BuildContext context) {
    final language = AppStrings.of(context);
    return GestureDetector(
      onTap: () => openCertificate(context),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(Icons.description),
            SizedBox(width: 10),
            Text(language.viewCertificate),
          ],
        ),
      ),
    );
  }

  Widget _pendingCard(BuildContext context) {
    final language = AppStrings.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF1EFE8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        language.certificateNotAvailable,
        style: TextStyle(fontSize: 12),
      ),
    );
  }
}
