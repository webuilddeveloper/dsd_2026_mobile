import 'package:dsd/blank_page/appbar.dart';

import 'package:dsd/blank_page/format.dart';
import 'package:dsd/blank_page/gallery_viewer.dart';
import 'package:dsd/blank_page/launch.dart';
import 'package:dsd/shared/api_provider.dart';

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
  void initState() {
    _readGallery();
    super.initState();
  }

  List<Map<String, dynamic>> _gallery = [];

  _readGallery() async {
    final data = await postDio('${privilegeGallery}read', {
      'limit': 10,
      // "skip": 0,
      'code': widget.privilege['code'],
    });
    setState(() {
      _gallery = (data as List).cast<Map<String, dynamic>>();

      if (widget.privilege['imageUrl'] != null) {
        _gallery.insert(0, {'imageUrl': widget.privilege['imageUrl']});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appBar(
        title: "สิทธิประโยชน์ ",
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
                  child:
                      _gallery.isNotEmpty
                          ? GestureDetector(
                            onTap:
                                () => GalleryViewer.open(
                                  context,
                                  gallery: _gallery,
                                  initialIndex: 0, // ✅ รูปแรก
                                ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                _gallery[0]['imageUrl'],
                                width: double.infinity,
                                height: 350,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                          : SizedBox(),
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
                    if (_gallery.length > 1)
                      SizedBox(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _gallery.length - 1,
                          itemBuilder: (context, index) {
                            final item = _gallery[index + 1];

                            return Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: GestureDetector(
                                onTap:
                                    () => GalleryViewer.open(
                                      context,
                                      gallery: _gallery,
                                      initialIndex: index + 1, // ✅ ตรงนี้ใช้ได้
                                    ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    item['imageUrl'],
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    SizedBox(height: 16),
                    Text(
                      'รายละเอียด มีดังนี้',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    widget.privilege['dateStart'] != null &&
                            widget.privilege['dateStart'] != '' &&
                            widget.privilege['dateStart'] != 'Invalid date'
                        ? Text(
                          'วันที่ลง : ${formatDate(widget.privilege['dateStart'])}',
                        )
                        : SizedBox(),
                    SizedBox(height: 16),

                    Html(data: widget.privilege['description']),
                    SizedBox(height: 32),

                    widget.privilege['textButton'] != ''
                        ? Center(
                          child: InkWell(
                            onTap: () {
                              final link = widget.privilege['linkUrl'];
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
                                  widget.privilege['textButton'],
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                        : SizedBox(),
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
