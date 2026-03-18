import 'package:dsd/blank_page/appbar.dart';
import 'package:dsd/model/license_data.dart';
import 'package:dsd/style_theme.dart';
import 'package:flutter/material.dart';

class LicenseDetailPage extends StatefulWidget {
  final LicenseData license;

  const LicenseDetailPage({super.key, required this.license});

  @override
  State<LicenseDetailPage> createState() => _LicenseDetailPageState();
}

class _LicenseDetailPageState extends State<LicenseDetailPage> {
  bool showQR = false;

  void goBack() {
    Navigator.pop(context, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        title: "ใบอนุญาต",
        backBtn: true,
        rightBtn: false,
        backAction: () => goBack(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              /// CARD / QR
              GestureDetector(
                onTap: () {
                  setState(() {
                    showQR = !showQR;
                  });
                },
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      showQR ? _buildQR() : _buildCard(),

                      const SizedBox(height: 8),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: showQR ? 24 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color:
                                  showQR ? Colors.amber : Colors.grey.shade400,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          const SizedBox(width: 6),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: showQR ? 8 : 24,
                            height: 8,
                            decoration: BoxDecoration(
                              color:
                                  showQR ? Colors.grey.shade400 : Colors.amber,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// DETAIL
              _buildDetailCard(),
            ],
          ),
        ),
      ),
    );
  }

  /// CARD IMAGE
  Widget _buildCard() {
    return Container(
      key: const ValueKey("card"),

      // height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset("assets/images/license.png", fit: BoxFit.cover),
      ),
    );
  }

  /// QR
  Widget _buildQR() {
    return Icon(Icons.qr_code_2, size: 200, color: AppColors.primary);
  }

  /// DETAIL CARD
  Widget _buildDetailCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildtxt(title: 'เลขประจำตัวผู้ถือบัตร', subtitle: '1-2564-16577'),

          const Divider(color: AppColors.backgroundMain),

          _buildtxt(
            title: widget.license.title,
            subtitle: widget.license.branch,
          ),

          const Divider(color: AppColors.backgroundMain),
          _buildtxt(title: "วันออกบัตร", subtitle: widget.license.issueDate),
          const Divider(color: AppColors.backgroundMain),
          _buildtxtStatus(
            title: "สถานะใบอนุญาต",
            subtitle: widget.license.status,
          ),
        ],
      ),
    );
  }

  _buildtxt({required String title, required String subtitle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.textgrey,
            ),
          ),
        ],
      ),
    );
  }

  _buildtxtStatus({required String title, required String subtitle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Container(
                height: 15,
                width: 15,
                decoration: BoxDecoration(
                  color: Color(0xff34C759),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              SizedBox(width: 12),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textgrey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
