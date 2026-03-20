import 'package:dsd/blank_page/appbar.dart';
import 'package:dsd/blank_page/dialog_fail.dart';
import 'package:dsd/blank_page/format.dart';
import 'package:dsd/blank_page/launch.dart';

import 'package:dsd/style_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class PrivilegeDetail extends StatefulWidget {
  // final PrivilegeItem privilege;
  final Map<String, dynamic> privilege;
  // news;
  const PrivilegeDetail({super.key, required this.privilege});

  @override
  State<PrivilegeDetail> createState() => _PrivilegeDetailState();
}

class _PrivilegeDetailState extends State<PrivilegeDetail> {
  void goBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appBar(
        title: "ข่าวประชาสัมพันธ์",
        rightBtn: false,
        backAction: () => goBack(),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                // รูปภาพ
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 55,
                  ),
                  child: Image.network(
                    widget.privilege['imageUrl'],
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),

                // Badge 1/2
                // Positioned(
                //   bottom: MediaQuery.of(context).padding.bottom + 0,
                //   right: 12,
                //   child: Container(
                //     padding: const EdgeInsets.symmetric(
                //       horizontal: 8,
                //       vertical: 4,
                //     ),
                //     decoration: BoxDecoration(
                //       color: Colors.black54,
                //       borderRadius: BorderRadius.circular(12),
                //     ),
                //     child: const Text(
                //       '1/2',
                //       style: TextStyle(color: Colors.white, fontSize: 12),
                //     ),
                //   ),
                // ),
              ],
            ),

            Transform.translate(
              offset: const Offset(0, -16), // ดึงขึ้นไปทับรูป
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
                    Text(
                      widget.privilege['title'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 16),
                    Divider(color: AppColors.borderColor),
                    SizedBox(height: 16),

                    Text(
                      'รายละเอียด มีดังนี้',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'วันที่ลง : ${formatDate(widget.privilege['_id']['creationTime'])}',
                    ),
                    SizedBox(height: 16),

                    Html(data: widget.privilege['description']),
                    SizedBox(height: 32),
                    Center(
                      child: InkWell(
                        onTap: () {
                          final link = widget.privilege['linkUrl'];

                          if (link == null || link.toString().trim().isEmpty) {
                            showDialogFail(
                              context,
                              title: 'ไม่พบลิงก์',
                              description:
                                  'ไม่สามารถเปิดข่าวนี้ได้ เนื่องจากไม่มีลิงก์',
                              onConfirm: () {
                                Navigator.pop(context);
                              },
                            );
                            return;
                          }

                          launchURL(link as String);
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
                            padding: EdgeInsetsGeometry.symmetric(
                              vertical: 8,
                              horizontal: 16,
                            ),
                            child: Text(
                              'อ่านเพิ่มเติม',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
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
