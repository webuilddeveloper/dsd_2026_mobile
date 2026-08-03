import 'package:dsd/blank_page/format.dart';
import 'package:dsd/blank_page/gallery_viewer.dart';
import 'package:dsd/style_theme.dart';
import 'package:flutter/material.dart';

class TechnicianDetailDialog extends StatelessWidget {
  final Map<String, dynamic> technician;

  const TechnicianDetailDialog({super.key, required this.technician});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * .9,
        constraints: const BoxConstraints(maxWidth: 430),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ปุ่มปิด
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      color: Colors.grey.shade700,
                      size: 18,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 4),

              // Avatar + ชื่อ + แท็กประเภท
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Image.asset(
                        'assets/DSD/icon/icon_user.png',
                        width: 28,
                        height: 28,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          technician["names"] ?? "-",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.backgroundMain,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            technician["course"] ?? "-",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              Divider(height: 1, color: Colors.grey.shade200),
              const SizedBox(height: 16),

              _buildInfoRow(
                Icons.badge_outlined,
                "เลขรับรอง",
                technician["certificateNo"],
              ),
              const SizedBox(height: 10),
              _buildInfoRow(
                Icons.calendar_month_outlined,
                "วันที่ออก",

                formatDate(technician["certificateDate"]),
              ),
              const SizedBox(height: 10),
              _buildInfoRow(
                Icons.business_outlined,
                "หน่วยงาน",
                technician["site"],
              ),

              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  // เปิดรูปเต็มตอนมี pathCer ให้เปิด GalleryViewer, ถ้าไม่มีให้ไม่ทำอะไร
                  // Positioned.fill(
                  //   child: Material(
                  //     color: Colors.transparent,
                  //     child: InkWell(
                  //       onTap: () {
                  //         PdfViewerDialog.open(context, pdfUrl: pathCer);
                  //       },
                  //     ),
                  //   ),
                  // );
                  GalleryViewerAsset.open(
                    context,
                    gallery: [
                      {'imageUrl': 'assets/DSD/imgs/cer-test.jpg'},
                    ],
                    initialIndex: 0,
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        constraints: const BoxConstraints(maxHeight: 260),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundMain,
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child:
                            technician["pathCer"] == null
                                ? Image.asset(
                                  'assets/DSD/imgs/cer-test.jpg',
                                  fit: BoxFit.contain,
                                )
                                : Image.network(
                                  technician["pathCer"],
                                  fit: BoxFit.contain,
                                ),
                      ),
                      // Positioned(
                      //   right: 8,
                      //   bottom: 8,
                      //   child: Container(
                      //     padding: const EdgeInsets.all(6),
                      //     decoration: BoxDecoration(
                      //       color: Colors.black.withOpacity(0.45),
                      //       shape: BoxShape.circle,
                      //     ),
                      //     child: const Icon(
                      //       Icons.zoom_in,
                      //       color: Colors.white,
                      //       size: 16,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),

              // const SizedBox(height: 22),

              // SizedBox(
              //   width: double.infinity,
              //   height: 46,
              //   child: ElevatedButton(
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: AppColors.primary,
              //       elevation: 0,
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(16),
              //       ),
              //     ),
              //     onPressed: () => Navigator.pop(context),
              //     child: const Text(
              //       "ปิด",
              //       style: TextStyle(
              //         color: Colors.white,
              //         fontWeight: FontWeight.w600,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  // สไตล์เดียวกับ _buildInfoRow ในหน้า TechnicianPage
  Widget _buildInfoRow(IconData icon, String label, dynamic value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 15, color: Colors.grey.shade500),
        const SizedBox(width: 6),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "$label : ",
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
                TextSpan(
                  text: "${value ?? "-"}",
                  style: const TextStyle(
                    fontSize: 13,
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
