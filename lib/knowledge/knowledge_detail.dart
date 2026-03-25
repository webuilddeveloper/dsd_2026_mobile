import 'package:dsd/blank_page/appbar.dart';
import 'package:dsd/blank_page/format.dart';
import 'package:dsd/blank_page/gallery_viewer.dart';
import 'package:dsd/blank_page/launch.dart';
import 'package:dsd/style_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

class KnowledgeDetail extends StatefulWidget {
  const KnowledgeDetail({Key? key, required this.code, required this.model})
    : super(key: key);
  final String code;
  final dynamic model;

  @override
  State<KnowledgeDetail> createState() => _KnowledgeDetailPageState();
}

class _KnowledgeDetailPageState extends State<KnowledgeDetail> {
  void goBack() => Navigator.pop(context);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );

    final model = widget.model;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appBar(
        title: 'คลังความรู้',
        rightBtn: false,
        backAction: () => goBack(),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── รูปหลัก ──
            Stack(
              children: [
                // Padding(
                //   padding: EdgeInsets.only(
                //     top: MediaQuery.of(context).padding.top + 55,
                //   ),
                //   child:
                //       (model['imageUrl'] != null && model['imageUrl'] != '')
                //           ? Image.network(
                //             model['imageUrl'],
                //             width: double.infinity,
                //             height: 350,
                //             fit: BoxFit.cover,
                //             errorBuilder:
                //                 (_, __, ___) => Container(
                //                   height: 350,
                //                   color: Colors.grey[300],
                //                 ),
                //           )
                //           : Container(height: 350, color: Colors.grey[300]),
                // ),
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 55,
                  ),
                  child:
                      (model['imageUrl'] != null && model['imageUrl'] != '')
                          ? GestureDetector(
                            onTap:
                                () => GalleryViewer.open(
                                  context,
                                  gallery: [
                                    {'imageUrl': model['imageUrl']},
                                  ], // ✅ แปลงเป็น List เพราะ GalleryViewer สร้างเป็น list ไว้
                                  initialIndex: 0,
                                ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                model['imageUrl'],
                                width: double.infinity,
                                height: 350,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (_, __, ___) => Container(
                                      height: 350,
                                      color: Colors.grey[300],
                                    ),
                              ),
                            ),
                          )
                          : Container(height: 350, color: Colors.grey[300]),
                ),
              ],
            ),

            // ── White Card ──
            Transform.translate(
              offset: const Offset(0, -16),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── ชื่อ ──
                    Text(
                      model['title'] ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Kanit',
                      ),
                    ),

                    const SizedBox(height: 16),
                    Divider(color: AppColors.borderColor),
                    const SizedBox(height: 16),

                    // ── ข้อมูล ──
                    if ((model['author'] ?? '') != '')
                      _InfoRow(label: 'ผู้แต่ง', value: model['author']),
                    if ((model['publisher'] ?? '') != '')
                      _InfoRow(label: 'สำนักพิมพ์', value: model['publisher']),
                    if ((model['categoryList'] ?? []).isNotEmpty &&
                        (model['categoryList'][0]['title'] ?? '') != '')
                      _InfoRow(
                        label: 'หมวดหมู่',
                        value: model['categoryList'][0]['title'],
                      ),
                    if ((model['bookType'] ?? '') != '')
                      _InfoRow(
                        label: 'ประเภทหนังสือ',
                        value: model['bookType'],
                      ),
                    if ((model['numberOfPages']?.toString() ?? '') != '')
                      _InfoRow(
                        label: 'จำนวนหน้า',
                        value: model['numberOfPages'].toString(),
                      ),
                    if ((model['size']?.toString() ?? '') != '')
                      _InfoRow(label: 'ขนาด', value: model['size'].toString()),

                    // ── วันที่ ──
                    if ((model['createDate'] ?? '') != '' &&
                        model['createDate'] != 'Invalid date')
                      Text(
                        'วันที่ลง : ${dateStringToDate(model['createDate'])}',
                        style: const TextStyle(fontFamily: 'Kanit'),
                      ),

                    const SizedBox(height: 16),

                    // ── description ──
                    Html(
                      data: model['description'] ?? '',
                      onLinkTap:
                          (url, attributes, element) =>
                              launchUrl(Uri.parse(url ?? '')),
                    ),

                    const SizedBox(height: 32),

                    // ── ปุ่มอ่าน ──
                    if ((model['fileUrl'] ?? '') != '' ||
                        (model['linkUrl'] ?? '') != '')
                      Center(
                        child: InkWell(
                          onTap: () {
                            if (model['fileUrl']?.isNotEmpty == true) {
                              launchURL(model['fileUrl']);
                            } else {
                              launchURL(model['linkUrl']);
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: AppColors.primary,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 48,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    'assets/DSD/imgs/Group337.png',
                                    height: 20,
                                    width: 20,
                                    color: AppColors.primary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'อ่าน',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Kanit',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.grey,
                fontFamily: 'Kanit',
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, fontFamily: 'Kanit'),
            ),
          ),
        ],
      ),
    );
  }
}
