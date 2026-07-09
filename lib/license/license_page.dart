import 'package:dsd/blank_page/appbar.dart';
import 'package:dsd/blank_page/textfield.dart';
import 'package:dsd/license/license_detail_page.dart';
import 'package:dsd/shared/api_provider.dart';
import 'package:dsd/shared/app_strings.dart';
import 'package:dsd/style_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
  late Future<List<Map<String, dynamic>>> _certFuture;

  @override
  void initState() {
    super.initState();
    _certFuture = _futureGetcert();
  }

  Future<List<Map<String, dynamic>>> _futureGetcert() async {
    final storage = FlutterSecureStorage();
    final idcard = await storage.read(key: 'idcard');
    final data = await postDio(getCert, {"idcard": idcard});
    return (data as List).cast<Map<String, dynamic>>();
  }

  List<Map<String, dynamic>> _filtered(
    List<Map<String, dynamic>> allData,
    String typeOfTrain,
  ) {
    final query = licenseSearch.text.trim().toLowerCase();
    return allData.where((item) {
      final matchType = item['typeOfTrain'] == typeOfTrain;
      if (!matchType) return false;
      if (query.isEmpty) return true;
      return (item['course'] as String).toLowerCase().contains(query) ||
          (item['site'] as String).toLowerCase().contains(query) ||
          (item['certificateNo'] as String).toLowerCase().contains(query);
    }).toList();
  }

  List<Map<String, dynamic>> mockTraining = [
    {
      "personalId": "4700800001962",
      "names": "นางสาวสุกัญญา แสวงสุข",
      "course": "อาชีพด้านการแพทย์ และสุขภาพ สาขาพนักงานนวดไทย ระดับ 1",
      "certificateNo": "06-000541/2569",
      "certificateDate": "2026-04-20T02:02:38Z",
      "site": "สถาบันพัฒนาทรัพยากรมนุษย์สำหรับอุตสาหกรรมบริการสุขภาพ",
      "typeOfTrain": "1",
      "cerExpire": "",
    },
  ];

  List<Map<String, dynamic>> mockTesting = [
    {
      "personalId": "4700800001962",
      "names": "นางสาวสุกัญญา แสวงสุข",
      "course": "ทดสอบมาตรฐานฝีมือแรงงาน สาขาพนักงานนวดไทย ระดับ 1",
      "certificateNo": "T-000101/2569",
      "certificateDate": "2026-03-12T02:02:38Z",
      "site": "ศูนย์ทดสอบมาตรฐานฝีมือแรงงาน กรุงเทพมหานคร",
      "typeOfTrain": "2",
      "cerExpire": "",
    },
    {
      "personalId": "4700800001962",
      "names": "นางสาวสุกัญญา แสวงสุข",
      "course": "ทดสอบมาตรฐานฝีมือแรงงาน สาขาผู้ดูแลผู้สูงอายุ",
      "certificateNo": "T-000102/2569",
      "certificateDate": "2026-05-20T02:02:38Z",
      "site": "ศูนย์ทดสอบมาตรฐานฝีมือแรงงาน สมุทรปราการ",
      "typeOfTrain": "2",
      "cerExpire": "",
    },
  ];
  List<Map<String, dynamic>> mockEvent = [
    {
      "personalId": "4700800001962",
      "names": "นางสาวสุกัญญา แสวงสุข",
      "course": "อาชีพด้านการแพทย์ และสุขภาพ สาขาพนักงานนวดไทย ระดับ 1",
      "certificateNo": "06-000541/2569",
      "certificateDate": "2026-04-20T02:02:38Z",
      "site": "สถาบันพัฒนาทรัพยากรมนุษย์สำหรับอุตสาหกรรมบริการสุขภาพ",
      "typeOfTrain": "3",
      "cerExpire": "",
    },
  ];
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
    final language = AppStrings.of(context);
    return Scaffold(
      appBar: appBar(
        title: language.workhistory,
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
              rightBtn: false,
              onFilterTap: () {},
              onChanged: (value) {
                setState(() {});
              },
            ),

            const SizedBox(height: 16),

            /// 🔽 LIST
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _certFuture,
                builder: (context, snapshot) {
                  // //api
                  // if (snapshot.connectionState == ConnectionState.waiting) {
                  //   return const Center(child: CircularProgressIndicator());
                  // }
                  // if (snapshot.hasError) {
                  //   return Center(
                  //     child: Text(
                  //       "เกิดข้อผิดพลาด: ${snapshot.error}",
                  //       style: const TextStyle(color: Colors.red),
                  //     ),
                  //   );
                  // }

                  // final allData = snapshot.data ?? [];
                  // final training = _filtered(allData, "1");
                  // final testing = _filtered(allData, "2");
                  // final evaluations = _filtered(allData, "3"); api ยังไม่มีข้อมูลประเภทนี้
                  final training = mockTraining;
                  final testing = mockTesting;
                  final evaluations =
                      mockTraining; // 👈 ใช้ mock data แทนชั่วคราว

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildLicenseCard(
                          index: 0,
                          title: language.trainingresults,
                          dataList: training,
                          colorMain: AppColors.primary,
                          colorTitle: Colors.black,
                          iconPath: "assets/DSD/icon/icontraining.png",
                          coloricon: const Color(0xFF784C4C),
                          scrollbarColor: const Color(0xFFD8A32B),
                          matchCount: training.length,
                          showLicenseCar: false,
                        ),
                        _buildLicenseCard(
                          index: 1,
                          title: language.skillresult,
                          dataList: testing,
                          colorMain: const Color(0xffBB439C),
                          colorTitle: Colors.white,
                          iconPath: "assets/DSD/icon/icon_skills.png",
                          coloricon: Colors.white,
                          scrollbarColor: const Color(0xFF4F1964),
                          matchCount: testing.length,
                          showLicenseCar: false,
                        ),

                        _buildLicenseCard(
                          index: 2,
                          title: language.evaluationresults,
                          dataList: evaluations,
                          colorMain: const Color(0xff4F1964),
                          colorTitle: Colors.white,
                          iconPath: "assets/DSD/imgs/icon_estimate.png",
                          coloricon: Colors.white,
                          scrollbarColor: const Color(0xFFD8A32B),
                          matchCount: evaluations.length,
                          showLicenseCar: true,
                        ),
                      ],
                    ),
                  );
                },
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
    required bool showLicenseCar,
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
            padding: EdgeInsets.only(left: 8, right: 18, top: 12, bottom: 12),
            child: Row(
              children: [
                const SizedBox(width: 12),

                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        selectedIndex = isOpen ? null : index;
                      });
                    },
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
                        showLicenseCar: showLicenseCar,
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
    required bool showLicenseCar,
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
                  child: _buildItem(
                    data: dataList[idx],
                    title: title,
                    showLicenseCar: showLicenseCar,
                  ),
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
    required bool showLicenseCar,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => LicenseDetailPage(
                    license: data,
                    title: title,
                    showLicenseCard: showLicenseCar,
                  ),
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
                Text(
                  data['course'] ?? "", // 👈 camelCase
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
