import 'package:dsd/blank_page/appbar.dart';
import 'package:dsd/blank_page/format.dart';
import 'package:dsd/blank_page/textfield.dart';
import 'package:dsd/style_theme.dart';
import 'package:flutter/material.dart';

class CourseAll extends StatefulWidget {
  const CourseAll({super.key, required this.course});
  final List<Map<String, dynamic>> course;
  @override
  State<CourseAll> createState() => _CourseAllState();
}

class _CourseAllState extends State<CourseAll> {
  void goBack() {
    Navigator.pop(context);
  }

  bool isLoading = true;
  List<Map<String, dynamic>> courseAll = [];
  // List<Map<String, dynamic>> category = [];
  List<Map<String, dynamic>> category = [
    {"title": "ทั้งหมด"},
    {"title": "ทำอาหาร"},
    {"title": "ตัดผม"},
    {"title": "ซ่อมรถ"},
    {"title": "DIY"},
    {"title": "เสื้อผ้า"},
    {"title": "เทคโนโลยี"},
    {"title": "อบขนม"},
    {"title": "แต่งหน้า"},
    {"title": "ปลูกต้นไม้"},
  ];

  @override
  void initState() {
    super.initState();
    courseAll = widget.course; // ✅ correct assignment

    // _privilegeApi();
    // _privilegeCategoryApi();
  }

  /*===============================>> API <<=============================== */
  // Future<void> _privilegeApi() async {
  //   final data = await postDio('${privilegeApi}read', {'limit': 10});
  //   setState(() {
  //     courseAll = (data as List).cast<Map<String, dynamic>>();
  //     isLoading = false;
  //   });
  // }

  // Future<void> _privilegeCategoryApi() async {
  //   final data = await postDio('${privilegeCategoryApi}read', {'limit': 10});
  //   setState(() {
  //     // ✅ เพิ่ม "ทั้งหมด" ไว้ตัวแรกเสมอ
  //     category = [
  //       {'code': '', 'title': 'ทั้งหมด'},
  //       ...(data as List).cast<Map<String, dynamic>>(),
  //     ];
  //     isLoading = false;
  //   });
  // }
  /*===============================>> API <<=============================== */

  // 🔥 controller ต้องอยู่นอก build
  final TextEditingController courseSearch = TextEditingController();

  int selectedIndex = 0;

  List<Map<String, dynamic>> getFilteredList() {
    List<Map<String, dynamic>> courselist = courseAll;
    if (selectedIndex != 0) {
      final selectedCode = category[selectedIndex]['code'];
      courselist =
          courselist.where((e) => e['category'] == selectedCode).toList();
    }
    if (courseSearch.text.isNotEmpty) {
      final keyword = courseSearch.text.toLowerCase();

      courselist =
          courselist
              .where((e) => e['COURSE'].toLowerCase().contains(keyword))
              .toList();
    }

    return courselist;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        title: "คอร์สอบรมแนะนำสำหรับคุณ",
        rightBtn: false,
        backBtn: true,
        backAction: () => goBack(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔍 search
            buildSearch(
              hintText: "Search",
              controller: courseSearch,
              rightBtn: true,
              onFilterTap: () {},
              onChanged: (value) {
                setState(() {}); // 🔥 ตัวนี้สำคัญสุด
              },
            ),

            const SizedBox(height: 12),

            // 🔥 tabs
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(category.length, (index) {
                  final isSelected = selectedIndex == index;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : Colors.white,
                          border: Border.all(
                            color:
                                isSelected ? Colors.white : AppColors.primary,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          child: Text(
                            category[index]['title'] ?? '',
                            style: TextStyle(
                              fontSize: 14,
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: GridView.builder(
                itemCount: getFilteredList().length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.68,
                ),
                itemBuilder: (context, index) {
                  final item = getFilteredList()[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                          child: Image.asset(
                            // item['imageUrl'] ?? '',
                            'assets/DSD/imgs/2.png',
                            height: 85,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (_, __, ___) => Container(
                                  height: 85,
                                  color: Colors.grey[200],
                                ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['COURSE'] ?? '',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 6),

                              Row(
                                children: [
                                  Image.asset(
                                    'assets/DSD/icon/icon date.png',
                                    width: 14,
                                    color: Color(0xFFBB439C),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    " ระยะเวลาที่ฝึก ${item['PERIOD'] ?? ''} ชั่วโมง",
                                    style: const TextStyle(
                                      color: AppColors.textDark,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Kanit',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/DSD/icon/icon_calendar_full.png',
                                    width: 14,
                                    color: AppColors.primary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "วันเริ่ม ${formatDate(item['DSD_START_DATE'] ?? '')}",
                                    style: const TextStyle(
                                      color: AppColors.textDark,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Kanit',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/DSD/icon/icon_calendar_full.png',
                                    width: 14,
                                    color: AppColors.primary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "วันสิ้นสุด ${formatDate(item['DSD_END_DATE'] ?? '')}",
                                    style: const TextStyle(
                                      color: AppColors.textDark,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Kanit',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Center(
                                child: InkWell(
                                  onTap: () {},
                                  child: Container(
                                    width: double.infinity,

                                    decoration: BoxDecoration(
                                      color: Color(0xFF6FC546),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8,
                                        ),
                                        child: const Text(
                                          "สมัคร",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Kanit',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
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
}
