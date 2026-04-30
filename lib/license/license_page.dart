import 'package:dsd/blank_page/appbar.dart';

import 'package:dsd/blank_page/textfield.dart';
import 'package:dsd/license/license_detail_page.dart';
import 'package:flutter/material.dart';

class PageLicense extends StatefulWidget {
  const PageLicense({super.key});

  @override
  State<PageLicense> createState() => _PageLicenseState();
}

class _PageLicenseState extends State<PageLicense> {
  void goBack() {
    Navigator.pop(context, false);
  }

  final TextEditingController licenseSearch = TextEditingController();
  final List<ScrollController> _scrollControllers = List.generate(
    3,
    (_) => ScrollController(),
  );

  int? selectedIndex;
  // Set<int> openSections = {};

  // ─────────────────────────────────────────────
  //  ข้อมูลจริงจาก API (TYPEOFTRAIN: "1" = ฝึกอบรม, "2" = ทดสอบมาตรฐาน)
  // ─────────────────────────────────────────────
  final List<Map<String, dynamic>> allData = [
    {
      "PERSONAL_ID": "4700800001962",
      "NAMES": "นายสุวัฒน์ เจริญพิบูลย์",
      "COURSE":
          "การใช้ Microsoft AI Skills for Everyone (สำหรับวิทยากร) 6 ชั่วโมง",
      "CERTIFICATE_NO": "09-000109/2568",
      "CERTIFICATE_DATE": "2025-02-06T07:08:34.000Z",
      "SITE": "กองพัฒนาผู้ฝึกและเทคโนโลยีการฝึก",
      "TYPEOFTRAIN": "1",
    },
    {
      "PERSONAL_ID": "4700800001962",
      "NAMES": "นายสุวัฒน์ เจริญพิบูลย์",
      "COURSE": "การใช้ Microsoft AI Skills for Everyone 3 ชั่วโมง",
      "CERTIFICATE_NO": "06-000630/2568",
      "CERTIFICATE_DATE": "2025-01-23T10:16:18.000Z",
      "SITE": "กองบริหารทรัพยากรบุคคล",
      "TYPEOFTRAIN": "1",
    },
    {
      "PERSONAL_ID": "4700800001962",
      "NAMES": "นายสุวัฒน์ เจริญพิบูลย์",
      "COURSE": "กิจกรรมกลุ่มคุณภาพ 6 ชั่วโมง",
      "CERTIFICATE_NO": "ศพจ.มห.ย.0662/2557",
      "CERTIFICATE_DATE": "2014-04-29T17:00:00.000Z",
      "SITE": "สถาบันพัฒนาฝีมือแรงงาน 40 มุกดาหาร",
      "TYPEOFTRAIN": "1",
    },
    {
      "PERSONAL_ID": "4700800001962",
      "NAMES": "นายสุวัฒน์ เจริญพิบูลย์",
      "COURSE": "พนักงานการใช้คอมพิวเตอร์(การประมวลผลคำ) 18 ชั่วโมง",
      "CERTIFICATE_NO": "46694",
      "CERTIFICATE_DATE": "2014-09-02T17:00:00.000Z",
      "SITE": "สถาบันพัฒนาฝีมือแรงงาน 6 ขอนแก่น",
      "TYPEOFTRAIN": "1",
    },
    {
      "PERSONAL_ID": "4700800001962",
      "NAMES": "นายสุวัฒน์ เจริญพิบูลย์",
      "COURSE":
          "AI สำหรับเพิ่มประสิทธิภาพการทำงานด้วยโปรแกรม Microsoft Copilot 3 ชั่วโมง",
      "CERTIFICATE_NO": "06-000541/2569",
      "CERTIFICATE_DATE": "2025-12-22T02:02:38.000Z",
      "SITE": "กองบริหารทรัพยากรบุคคล",
      "TYPEOFTRAIN": "1",
    },
    {
      "PERSONAL_ID": "4700800001962",
      "NAMES": "นายสุวัฒน์ เจริญพิบูลย์",
      "COURSE": "เจ้าหน้าที่ฝึกอบรม 18 ชั่วโมง",
      "CERTIFICATE_NO": "ย2074/56",
      "CERTIFICATE_DATE": "2013-06-19T17:00:00.000Z",
      "SITE": "สถาบันพัฒนาฝีมือแรงงาน 40 มุกดาหาร",
      "TYPEOFTRAIN": "1",
    },
    {
      "PERSONAL_ID": "4700800001962",
      "NAMES": "นายสุวัฒน์ เจริญพิบูลย์",
      "COURSE": "การสร้างและพัฒนาเว็บไซต์ด้วยโปรแกรม Joomla 30 ชั่วโมง",
      "CERTIFICATE_NO": "ศพจ.มห.ย.0851/2558",
      "CERTIFICATE_DATE": "2014-11-23T17:00:00.000Z",
      "SITE": "สถาบันพัฒนาฝีมือแรงงาน 40 มุกดาหาร",
      "TYPEOFTRAIN": "1",
    },
    {
      "PERSONAL_ID": "4700800001962",
      "NAMES": "นายสุวัฒน์ เจริญพิบูลย์",
      "COURSE":
          "เทคนิคการจัดทำ Competency อย่างง่าย (Easy Competency) 6 ชั่วโมง",
      "CERTIFICATE_NO": "ศพจ.มห.ย.0170/2557",
      "CERTIFICATE_DATE": "2013-12-12T17:00:00.000Z",
      "SITE": "สถาบันพัฒนาฝีมือแรงงาน 40 มุกดาหาร",
      "TYPEOFTRAIN": "1",
    },
    {
      "PERSONAL_ID": "4700800001962",
      "NAMES": "นายสุวัฒน์ เจริญพิบูลย์",
      "COURSE": "พนักงานการใช้คอมพิวเตอร์ (ประมวลผลคำ) ระดับ 1",
      "CERTIFICATE_NO": "ศพจ.มห.ท.101/2557",
      "CERTIFICATE_DATE": "2014-04-08T17:00:00.000Z",
      "SITE": "สถาบันพัฒนาฝีมือแรงงาน 40 มุกดาหาร",
      "TYPEOFTRAIN": "1",
    },
    // TYPEOFTRAIN = "2" → ทดสอบมาตรฐานฝีมือแรงงาน
    {
      "PERSONAL_ID": "4700800001962",
      "NAMES": "นายสุวัฒน์ เจริญพิบูลย์",
      "COURSE": "พนักงานการใช้คอมพิวเตอร์ (ประมวลผลคำ) ระดับ 1",
      "CERTIFICATE_NO": "ศพจ.มห.ท.101/2557",
      "CERTIFICATE_DATE": "2014-04-08T17:00:00.000Z",
      "SITE": "สถาบันพัฒนาฝีมือแรงงาน 40 มุกดาหาร",
      "TYPEOFTRAIN": "2",
    },
    {
      "PERSONAL_ID": "4700800001962",
      "NAMES": "นายสุวัฒน์ เจริญพิบูลย์",
      "COURSE": "พนักงานควบคุมเครื่องจักรรถยกใช้เครื่องยนต์ ระดับ 1",
      "CERTIFICATE_NO": "สนพ.พบ/0421/60",
      "CERTIFICATE_DATE": "2017-08-20T17:00:00.000Z",
      "SITE": "สถาบันพัฒนาฝีมือแรงงาน 35 เพชรบุรี",
      "TYPEOFTRAIN": "2",
    },
    {
      "PERSONAL_ID": "4700800001962",
      "NAMES": "นายสุวัฒน์ เจริญพิบูลย์",
      "COURSE": "ช่างบำรุงรักษารถยนต์ ระดับ 1",
      "CERTIFICATE_NO": "สนพ.พบ/0435/60",
      "CERTIFICATE_DATE": "2017-08-29T17:00:00.000Z",
      "SITE": "สถาบันพัฒนาฝีมือแรงงาน 35 เพชรบุรี",
      "TYPEOFTRAIN": "2",
    },
  ];

  // ─────────────────────────────────────────────
  //  Filter ตาม search text
  // ─────────────────────────────────────────────
  List<Map<String, dynamic>> _filtered(String typeOfTrain) {
    final query = licenseSearch.text.trim().toLowerCase();
    return allData.where((item) {
      final matchType = item['TYPEOFTRAIN'] == typeOfTrain;
      if (!matchType) return false;

      if (query.isEmpty) return true;
      return (item['COURSE'] as String).toLowerCase().contains(query) ||
          (item['SITE'] as String).toLowerCase().contains(query) ||
          (item['CERTIFICATE_NO'] as String).toLowerCase().contains(query);
    }).toList();
  }

  @override
  void dispose() {
    for (final c in _scrollControllers) {
      c.dispose();
    }
    licenseSearch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Section data
    final training = _filtered("1"); // ผลการฝึกอบรม
    final testing = _filtered("2"); // ผลการทดสอบมาตรฐานฝีมือแรงงาน
    final evaluations = _filtered("3"); // ข้อมูลประเมิน

    return Scaffold(
      appBar: appBar(
        title: "ประวัติผลงาน",
        backBtn: true,
        rightBtn: false,
        backAction: () => goBack(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
        child: Column(
          children: [
            /// 🔍 SEARCH
            buildSearch(
              hintText: "Search...",
              controller: licenseSearch,
              rightBtn: true,
              onFilterTap: () {},
              onChanged: (value) {
                setState(() {
                  // เปิดทุก section ตอนมี text เพื่อให้เห็นผลลัพธ์ทันที
                  // if (value.trim().isEmpty) {
                  //   openSections.clear();
                  // } else {
                  //   openSections.clear();
                  //   if (_filtered("1").isNotEmpty) openSections.add(0);
                  //   if (_filtered("2").isNotEmpty) openSections.add(1);
                  //   if (_filtered("3").isNotEmpty) openSections.add(2);
                  // }
                });
              },
            ),

            const SizedBox(height: 16),

            /// 🔽 LIST
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildLicenseCard(
                      index: 0,
                      title: "ผลการฝึกอบรม",
                      dataList: training,
                      colorMain: const Color(0xffE7C882),
                      colorTitle: Colors.black,
                      iconPath: "assets/DSD/icon/icontraining.png",
                      coloricon: const Color(0xFF784C4C),
                      scrollbarColor: const Color(0xFFD8A32B),
                      matchCount: training.length,
                    ),
                    _buildLicenseCard(
                      index: 1,
                      title: "ผลการทดสอบมาตรฐานฝีมือแรงงาน",
                      dataList: testing,
                      colorMain: const Color(0xffBB439C),
                      colorTitle: Colors.white,
                      iconPath: "assets/DSD/icon/icon_skills.png",
                      coloricon: Colors.white,
                      scrollbarColor: const Color(0xFF4F1964),
                      matchCount: testing.length,
                    ),
                    _buildLicenseCard(
                      index: 2,
                      title: "ผลการประเมิน",
                      dataList: evaluations,
                      colorMain: const Color(0xff4F1964),
                      colorTitle: Colors.white,
                      iconPath: "assets/DSD/imgs/icon_estimate.png",
                      coloricon: Colors.white,
                      scrollbarColor: const Color(0xFFD8A32B),
                      matchCount: evaluations.length,
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

  // ─────────────────────────────────────────────
  //  Card หลักแต่ละ section (รับ dataList จากนอก)
  // ─────────────────────────────────────────────
  Widget _buildLicenseCard({
    required int index,
    required String title,
    required List<Map<String, dynamic>> dataList,
    required Color colorMain,
    required Color colorTitle,
    required Color coloricon,
    required String iconPath,
    required Color scrollbarColor,
    required int matchCount, // 👈 เพิ่มตรงนี้
  }) {
    final isOpen = selectedIndex == index;
    final isSearching = licenseSearch.text.trim().isNotEmpty; // 👈

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: colorMain,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          /// 🔹 HEADER
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Row(
              children: [
                const SizedBox(width: 12),

                Expanded(
                  child: Row(
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.all(6),
                        child: Image.asset(iconPath, fit: BoxFit.contain),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            color: colorTitle,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      // 👇 Badge แสดงจำนวนเฉพาะตอน search
                      if (isSearching)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white30,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "$matchCount",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              // matchCount > 0
                              //     ? colorMain // สีของ section
                              //     // ignore: deprecated_member_use
                              //     : colorTitle,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),
                InkWell(
                  onTap: () {
                    setState(() {
                      selectedIndex = isOpen ? null : index;
                    });
                  },
                  child: Icon(
                    isOpen
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: coloricon,
                  ),
                ),
              ],
            ),
          ),

          // content เหมือนเดิม ...
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            crossFadeState:
                isOpen ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            firstChild: const SizedBox(),
            secondChild:
                dataList.isEmpty
                    ? Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        "ไม่มีข้อมูล",
                        style: TextStyle(
                          color: colorTitle.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                    )
                    : SizedBox(
                      height:
                          dataList.length > 3
                              ? MediaQuery.of(context).size.height * 0.4
                              : dataList.length * 110.0,
                      child: _buildScrollbarList(
                        title: title,
                        dataList: dataList,
                        scrollbarColor: scrollbarColor,
                        scrollController: _scrollControllers[index],
                      ),
                    ),
          ),
        ],
      ),
    );
  }
  // Widget _buildLicenseCard({
  //   required int index,
  //   required String title,
  //   required List<Map<String, dynamic>> dataList,
  //   required Color colorMain,
  //   required Color colorTitle,
  //   required Color coloricon,
  //   required String iconPath,
  //   required Color scrollbarColor,
  // }) {
  //   final isOpen = openSections.contains(index);
  //   return AnimatedContainer(
  //     duration: const Duration(milliseconds: 300),
  //     margin: const EdgeInsets.symmetric(vertical: 6),
  //     decoration: BoxDecoration(
  //       color: colorMain,
  //       borderRadius: BorderRadius.circular(30),
  //     ),
  //     child: Column(
  //       children: [
  //         /// 🔹 HEADER
  //         Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  //           child: Row(
  //             children: [
  //               Container(
  //                 height: 40,
  //                 width: 40,
  //                 decoration: BoxDecoration(
  //                   color: Colors.white,
  //                   borderRadius: BorderRadius.circular(30),
  //                 ),
  //                 padding: const EdgeInsets.all(6),
  //                 child: Image.asset(iconPath, fit: BoxFit.contain),
  //               ),
  //               const SizedBox(width: 12),
  //               Expanded(
  //                 child: Text(
  //                   title,
  //                   style: TextStyle(
  //                     color: colorTitle,
  //                     fontSize: 16,
  //                     fontWeight: FontWeight.w500,
  //                   ),
  //                 ),
  //               ),
  //               InkWell(
  //                 // onTap: () {
  //                 //   setState(() {
  //                 //     selectedIndex = isOpen ? null : index;
  //                 //   });
  //                 // },
  //                 onTap: () {
  //                   setState(() {
  //                     if (isOpen) {
  //                       openSections.remove(index);
  //                     } else {
  //                       openSections.add(index);
  //                     }
  //                   });
  //                 },
  //                 child: Icon(
  //                   isOpen
  //                       ? Icons.keyboard_arrow_up
  //                       : Icons.keyboard_arrow_down,
  //                   color: coloricon,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         /// 🔹 CONTENT
  //         AnimatedCrossFade(
  //           duration: const Duration(milliseconds: 250),
  //           crossFadeState:
  //               isOpen ? CrossFadeState.showSecond : CrossFadeState.showFirst,
  //           firstChild: const SizedBox(),
  //           secondChild:
  //               dataList.isEmpty
  //                   ? Padding(
  //                     padding: const EdgeInsets.only(bottom: 16),
  //                     child: Text(
  //                       "ไม่มีข้อมูล",
  //                       style: TextStyle(
  //                         color: colorTitle.withOpacity(0.7),
  //                         fontSize: 14,
  //                       ),
  //                     ),
  //                   )
  //                   : SizedBox(
  //                     height:
  //                         dataList.length > 3
  //                             ? MediaQuery.of(context).size.height * 0.4
  //                             : dataList.length * 110.0,
  //                     child: _buildScrollbarList(
  //                       title: title,
  //                       dataList: dataList,
  //                       scrollbarColor: scrollbarColor,
  //                       scrollController: _scrollControllers[index],
  //                     ),
  //                   ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // ─────────────────────────────────────────────
  //  Scrollable list พร้อม custom scrollbar
  // ─────────────────────────────────────────────
  Widget _buildScrollbarList({
    required String title,
    required List<Map<String, dynamic>> dataList,
    required Color scrollbarColor,
    required ScrollController scrollController,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: Stack(
        children: [
          dataList.length > 4
              ? Positioned(
                right: 0,
                top: 0,
                bottom: MediaQuery.of(context).size.height * 0.02,
                child: Container(
                  width: 8,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              )
              : const SizedBox(),
          RawScrollbar(
            controller: scrollController,
            thumbVisibility: dataList.length > 4 ? true : false,
            thickness: 8,
            radius: const Radius.circular(10),
            thumbColor: scrollbarColor,
            trackVisibility: false,
            child: ListView.separated(
              controller: scrollController,
              itemCount: dataList.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, idx) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: _buildItem(data: dataList[idx], title: title),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  Card แต่ละรายการ — แสดงข้อมูลจริงครบถ้วน
  // ─────────────────────────────────────────────
  Widget _buildItem({
    required Map<String, dynamic> data,
    required String title,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => LicenseDetailPage(license: data, title: title),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ชื่อหลักสูตร
                Text(
                  data['COURSE'] ?? "",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                // const SizedBox(height: 6),
                // // สถานที่
                // Row(
                //   children: [
                //     const Icon(
                //       Icons.location_on_outlined,
                //       size: 14,
                //       color: Colors.grey,
                //     ),
                //     const SizedBox(width: 4),
                //     Expanded(
                //       child: Text(
                //         data['SITE'] ?? "",
                //         style: const TextStyle(
                //           fontSize: 12,
                //           color: Colors.grey,
                //         ),
                //         overflow: TextOverflow.ellipsis,
                //       ),
                //     ),
                //   ],
                // ),
                // const SizedBox(height: 4),

                // // เลขที่ใบประกาศ + วันที่
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Row(
                //       children: [
                //         const Icon(
                //           Icons.card_membership_outlined,
                //           size: 14,
                //           color: Colors.grey,
                //         ),
                //         const SizedBox(width: 4),
                //         Text(
                //           data['CERTIFICATE_NO'] ?? "",
                //           style: const TextStyle(
                //             fontSize: 12,
                //             color: Colors.blueGrey,
                //           ),
                //         ),
                //       ],
                //     ),
                //     Text(
                //       formatDate(data['CERTIFICATE_DATE'] ?? ""),
                //       style: const TextStyle(
                //         fontSize: 12,
                //         color: Colors.blueGrey,
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
