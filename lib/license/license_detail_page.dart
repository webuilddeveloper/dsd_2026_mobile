// ignore_for_file: deprecated_member_use

import 'package:background_downloader/background_downloader.dart';
import 'package:dsd/blank_page/appbar.dart';
import 'package:dsd/blank_page/dialog_fail.dart';
import 'package:dsd/blank_page/format.dart';
import 'package:dsd/blank_page/gallery_viewer.dart';
import 'package:dsd/shared/app_strings.dart';
import 'package:dsd/style_theme.dart';
import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class LicenseDetailPage extends StatefulWidget {
  final Map<String, dynamic> license;
  final String title;
  final bool showLicenseCard;

  const LicenseDetailPage({
    super.key,
    required this.license,
    required this.title,
    required this.showLicenseCard,
  });

  @override
  State<LicenseDetailPage> createState() => _LicenseDetailPageState();
}

class _LicenseDetailPageState extends State<LicenseDetailPage> {
  bool showQR = false;
  bool _isDownloading = false;

  void goBack() {
    Navigator.pop(context, false);
  }

  Future<void> downloadPdf(String url, String fileName) async {
    final safeFileName =
        fileName.toLowerCase().endsWith('.pdf') ? fileName : '$fileName.pdf';

    setState(() {
      _isDownloading = true;
    });

    final task = DownloadTask(
      url: url,
      filename: safeFileName,
      baseDirectory: BaseDirectory.applicationDocuments,
      updates: Updates.statusAndProgress,
    );

    final downloadResult = await FileDownloader().download(
      task,
      onProgress: (progress) {
        print('โหลด: ${(progress * 100).toStringAsFixed(0)}%');
      },
    );

    if (downloadResult.status == TaskStatus.complete) {
      final dir = await getApplicationDocumentsDirectory();
      final fullPath = '${dir.path}/$safeFileName';

      if (mounted) {
        setState(() => _isDownloading = false);
        try {
          await Share.shareXFiles([XFile(fullPath)]);
        } catch (e) {
          print('share error: $e');
        }
      }
    } else {
      if (mounted) {
        setState(() => _isDownloading = false);
        showDialogFail(
          context,
          title: 'ดาวน์โหลดล้มเหลว',
          description: 'สถานะ: ${downloadResult.status}',
          onConfirm: () => Navigator.pop(context),
        );
      }
    }
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
                      widget.showLicenseCard == true
                          ? _buildCard()
                          : SizedBox(),
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
  // ignore: unused_element
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
          SizedBox(height: 12),

          InkWell(
            onTap:
                _isDownloading
                    ? null // 👈 กันกดซ้ำตอนกำลังโหลด
                    : () {
                      downloadPdf(
                        'https://khubdeedlt.we-builds.com/khubdeedlt-document/images/knowledge/knowledge_261952630.pdf',
                        "document",
                      );
                    },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child:
                    _isDownloading
                        ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              'กำลังดาวน์โหลด...',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )
                        : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/DSD/icon/icon_downlond.png',
                              color: Colors.black,
                              width: 24,
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'ดาวน์โหลดเอกสาร',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
              ),
            ),
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
