import 'package:dsd/blank_page/appbar.dart';
import 'package:dsd/blank_page/format.dart';
import 'package:dsd/blank_page/gallery_viewer.dart';
import 'package:dsd/style_theme.dart';
import 'package:flutter/material.dart';

class TechnicianDetailPage extends StatelessWidget {
  final Map<String, dynamic> technician;

  const TechnicianDetailPage({super.key, required this.technician});

  List<Map<String, dynamic>> get _certificates {
    final raw = technician["certificates"];

    List<Map<String, dynamic>> certs;
    if (raw is List) {
      certs =
          raw
              .whereType<Map>()
              .map((e) => Map<String, dynamic>.from(e))
              .toList();
    } else {
      certs = [
        {
          "course": technician["course"],
          "certificateNo": technician["certificateNo"],
          "certificateDate": technician["certificateDate"],
          "site": technician["site"],
          "pathCer": technician["pathCer"],
        },
      ];
    }

    // ── เรียงใบล่าสุดไว้บนสุด ──
    certs.sort((a, b) {
      final da = DateTime.tryParse(a["certificateDate"]?.toString() ?? "");
      final db = DateTime.tryParse(b["certificateDate"]?.toString() ?? "");
      if (da == null && db == null) return 0;
      if (da == null) return 1;
      if (db == null) return -1;
      return db.compareTo(da);
    });

    return certs;
  }

  // ── เช็คว่ามีรูปใบเซอร์ให้โหลดจริงหรือไม่ ──
  bool _hasValidImage(Map<String, dynamic> cert) {
    final path = cert["pathCer"];
    return path != null && path.toString().trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final certs = _certificates;

    return Scaffold(
      backgroundColor: AppColors.backgroundMain,
      appBar: appBar(
        title: 'รายละเอียดช่าง',
        rightBtn: false,
        backAction: () => Navigator.pop(context),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── แจ้งเตือนว่าเป็นข้อมูลตัวอย่าง (Mock Data) ──
          _buildMockNotice(),

          // ── การ์ดโปรไฟล์ + ข้อมูลส่วนตัวแบบครบถ้วน ──
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.grey.shade100),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.045),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(11.0),
                        child: Image.asset(
                          'assets/DSD/icon/icon_user.png',
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            technician["names"] ?? "-",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  size: 12,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "ช่างที่ได้รับการรับรอง",
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                Divider(height: 1, color: Colors.grey.shade200),
                const SizedBox(height: 14),

                _buildInfoRow(
                  Icons.badge_outlined,
                  "เลขบัตรประชาชน",
                  technician["personalId"],
                ),
                const SizedBox(height: 8),
                _buildInfoRow(
                  Icons.workspace_premium_outlined,
                  "จำนวนใบรับรอง",
                  "${certs.length} ใบ",
                ),
                const SizedBox(height: 8),
                _buildInfoRow(
                  Icons.business_outlined,
                  "หน่วยงานหลัก",
                  technician["site"],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Text(
                "ใบรับรองทั้งหมด",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "${certs.length}",
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          ...certs.map((cert) => _buildCertificateCard(context, cert)),
        ],
      ),
    );
  }

  // ── การ์ดแจ้งเตือนว่าข้อมูลในหน้านี้เป็นข้อมูลตัวอย่าง ──
  Widget _buildMockNotice() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        // color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.red, width: 1.2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 30, color: Colors.red),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "ข้อมูลในหน้านี้เป็นข้อมูลตัวอย่าง (Mock Data) "
              "การแสดงผลข้อมูลจริงจะเป็นไปตามระเบียบของกรมพัฒนาฝีมือแรงงาน",
              style: TextStyle(
                fontSize: 11.5,
                color: Colors.red,
                fontWeight: FontWeight.bold,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCertificateCard(
    BuildContext context,
    Map<String, dynamic> cert,
  ) {
    final hasImage = _hasValidImage(cert);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.045),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Icon(
                        Icons.workspace_premium_outlined,
                        size: 16,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        cert["course"] ?? "-",
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow(
                        Icons.badge_outlined,
                        "เลขรับรอง",
                        cert["certificateNo"],
                      ),
                      const SizedBox(height: 6),
                      _buildInfoRow(
                        Icons.calendar_month_outlined,
                        "วันที่ออก",
                        formatDate(cert["certificateDate"]),
                      ),
                      const SizedBox(height: 6),
                      _buildInfoRow(
                        Icons.business_outlined,
                        "หน่วยงาน",
                        cert["site"],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          GestureDetector(
            onTap: () {
              GalleryViewerAsset.open(
                context,
                gallery: [
                  {
                    'imageUrl':
                        hasImage
                            ? cert["pathCer"]
                            : 'assets/DSD/imgs/cer-test.jpg',
                  },
                ],
                initialIndex: 0,
              );
            },
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(18),
              ),
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(maxHeight: 170),
                    color: AppColors.backgroundMain,
                    child:
                        hasImage
                            ? Image.network(
                              cert["pathCer"],
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/DSD/imgs/cer-test.jpg',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                );
                              },
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return SizedBox(
                                  height: 170,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.primary,
                                      value:
                                          progress.expectedTotalBytes != null
                                              ? progress.cumulativeBytesLoaded /
                                                  progress.expectedTotalBytes!
                                              : null,
                                    ),
                                  ),
                                );
                              },
                            )
                            : Image.asset(
                              'assets/DSD/imgs/cer-test.jpg',
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.35),
                          ],
                          stops: const [0.6, 1.0],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 10,
                    bottom: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.zoom_in, color: Colors.white, size: 13),
                          SizedBox(width: 4),
                          Text(
                            "ดูใบเต็ม",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, dynamic value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 12.5, color: Colors.grey.shade500),
        const SizedBox(width: 5),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "$label : ",
                  style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600),
                ),
                TextSpan(
                  text: "${value ?? "-"}",
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
