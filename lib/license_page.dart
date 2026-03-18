import 'package:dsd/blank_page/appbar.dart';
import 'package:dsd/license_detail_page.dart';
import 'package:dsd/model/license_data.dart';
import 'package:dsd/style_theme.dart';
import 'package:flutter/material.dart';

class PageLicense extends StatefulWidget {
  const PageLicense({super.key});

  @override
  State<PageLicense> createState() => _PageLicenseState();
}

class _PageLicenseState extends State<PageLicense> {
  void goBack() async {
    Navigator.pop(context, false);
  }

  @override
  Widget build(BuildContext context) {
    // return const Placeholder();
    return Scaffold(
      appBar: appBar(
        title: "ใบอนุญาต",
        backBtn: true,
        rightBtn: false,
        backAction: () => goBack(),
        // rightAction: () => {},
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
        child: ListView.builder(
          itemCount: licenseList.length,
          itemBuilder: (context, index) {
            final item = licenseList[index];

            return _buildLicenseCard(
              title: item.title,
              date: item.issueDate,
              ontap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LicenseDetailPage(license: item),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildLicenseCard({
    required String title,
    required String date,
    required VoidCallback ontap,
  }) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        height: 85,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Kanit',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'ออกบัตร $date',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textgrey,
                fontFamily: 'Kanit',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
