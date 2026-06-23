import 'package:dsd/blank_page/appbar.dart';
import 'package:dsd/blank_page/format.dart';
import 'package:dsd/blank_page/gallery_viewer.dart';
import 'package:dsd/shared/app_strings.dart';
import 'package:dsd/style_theme.dart';
import 'package:flutter/material.dart';

class LicenseDetailPage extends StatefulWidget {
  final Map<String, dynamic> license;
  final String title;

  const LicenseDetailPage({
    super.key,
    required this.license,
    required this.title,
  });

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
        title: widget.title,
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
                  // setState(() {
                  //   showQR = !showQR;
                  // });
                },
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // showQR ?
                      // _buildQR() :
                      _buildCard(),
                      const SizedBox(height: 8),

                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     AnimatedContainer(
                      //       duration: const Duration(milliseconds: 300),
                      //       width: showQR ? 24 : 8,
                      //       height: 8,
                      //       decoration: BoxDecoration(
                      //         color:
                      //             showQR ? Colors.amber : Colors.grey.shade400,
                      //         borderRadius: BorderRadius.circular(8),
                      //       ),
                      //     ),
                      //     const SizedBox(width: 6),
                      //     AnimatedContainer(
                      //       duration: const Duration(milliseconds: 300),
                      //       width: showQR ? 8 : 24,
                      //       height: 8,
                      //       decoration: BoxDecoration(
                      //         color:
                      //             showQR ? Colors.grey.shade400 : Colors.amber,
                      //         borderRadius: BorderRadius.circular(8),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              /// DETAIL
              _buildDetailCard(),
              const SizedBox(height: 30),
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

      height: MediaQuery.of(context).size.height * 0.4,
      width: MediaQuery.of(context).size.width * 0.6,
      // width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: GestureDetector(
          onTap: () {
            AssetImageViewer.open(
              context,
              imagePath: "assets/DSD/imgs/cer-test.jpg",
            );
          },
          child: Image.asset(
            "assets/DSD/imgs/cer-test.jpg",
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  /// QR
  Widget _buildQR() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.45,
      width: MediaQuery.of(context).size.width * 0.8,
      // width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Image.asset(
            "assets/DSD/imgs/qr-test.png",
            fit: BoxFit.contain,
          ),
        ),
        // child: Icon(
        //   Icons.qr_code_2,
        //   color: AppColors.primary,
        //   size: MediaQuery.of(context).size.height * 0.3,
        // ),
      ),
    );
  }

  /// DETAIL CARD
  Widget _buildDetailCard() {
    final language = AppStrings.of(context);
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
          _buildtxt(
            title: language.cardholdernumber,
            subtitle: widget.license['personalId'],
          ),

          const Divider(color: AppColors.backgroundMain),

          _buildtxt(
            title: widget.license['course'] ?? "",
            subtitle: widget.license['site'] ?? "",
          ),

          const Divider(color: AppColors.backgroundMain),
          _buildtxt(
            title: language.dateIssue,
            subtitle: formatDate(widget.license['certificateDate'] ?? ""),
          ),
          const Divider(color: AppColors.backgroundMain),
          _buildtxtStatus(
            title: language.licenseStatus,
            subtitle: widget.license['cerExpire'] ?? "-",
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
