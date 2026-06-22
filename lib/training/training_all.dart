import 'package:dsd/blank_page/appbar.dart';
import 'package:dsd/blank_page/format.dart';
import 'package:dsd/blank_page/launch.dart';
import 'package:dsd/blank_page/textfield.dart';
import 'package:dsd/shared/api_provider.dart';
import 'package:dsd/shared/app_strings.dart';
import 'package:dsd/style_theme.dart';
import 'package:flutter/material.dart';

class TrainingAll extends StatefulWidget {
  const TrainingAll({super.key});

  @override
  State<TrainingAll> createState() => _TrainingAllState();
}

class _TrainingAllState extends State<TrainingAll> {
  void goBack() {
    Navigator.pop(context);
  }

  List<Map<String, dynamic>> category = [];
  late Future<List<Map<String, dynamic>>> futureTraining;

  final TextEditingController courseSearch = TextEditingController();
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    futureTraining = fetchTraining(); // ✅ โหลดครั้งแรก
    TrainingCategoryApi();
  }

  /*================ API =================*/

  Future<List<Map<String, dynamic>>> fetchTraining({
    String? categoryCode,
  }) async {
    final body = {"keySearch": "2569"};

    // ✅ ส่งเฉพาะตอนมี category
    if (categoryCode != null && categoryCode.isNotEmpty) {
      body["category"] = categoryCode;
    }

    final data = await postDio('${trainingApi}readAPI', body);
    return (data as List).cast<Map<String, dynamic>>();
  }

  // ignore: non_constant_identifier_names
  Future<void> TrainingCategoryApi() async {
    final data = await postDio('${trainingCategoryApi}read', {'limit': 999});

    setState(() {
      category = [
        {'code': '', 'title': 'ทั้งหมด'},
        ...(data as List).cast<Map<String, dynamic>>(),
      ];
    });
  }

  /*================ FILTER =================*/

  List<Map<String, dynamic>> getFilteredList(List<Map<String, dynamic>> list) {
    if (courseSearch.text.isEmpty) return list;

    final keyword = courseSearch.text.toLowerCase();

    return list
        .where((e) => e['course'].toString().toLowerCase().contains(keyword))
        .toList();
  }

  /*================ UI =================*/

  @override
  Widget build(BuildContext context) {
    final language = AppStrings.of(context);
    return Scaffold(
      appBar: appBar(
        title: language.recommended,
        rightBtn: false,
        backBtn: true,
        backAction: () => goBack(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            // 🔍 search
            buildSearch(
              hintText: "Search",
              controller: courseSearch,
              rightBtn: false,
              onFilterTap: () {},
              onChanged: (value) {
                setState(() {});
              },
            ),

            const SizedBox(height: 12),

            // 🔥 category tabs
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(category.length, (index) {
                  final isSelected = selectedIndex == index;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: InkWell(
                      onTap: () {
                        final selectedCode = category[index]['code'] ?? '';

                        setState(() {
                          selectedIndex = index;

                          // ✅ โหลดใหม่ตาม category
                          futureTraining = fetchTraining(
                            categoryCode: selectedCode,
                          );
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        child: Text(
                          category[index]['title'] ?? '',
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 12),

            // 🔥 list
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: futureTraining,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("ไม่พบข้อมูล"));
                  }

                  final filtered = getFilteredList(snapshot.data!);

                  return GridView.builder(
                    itemCount: filtered.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.68,
                        ),
                    itemBuilder: (context, index) {
                      return buildItem(filtered[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildItem(Map<String, dynamic> item) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.28,
      width: MediaQuery.of(context).size.width * 0.45,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 85,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.asset('assets/DSD/imgs/2.png', fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 8, vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['course'] ?? '',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
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
                      " ระยะเวลาที่ฝึก ${item['period'] ?? ''} ชั่วโมง",
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
                      "วันเริ่ม ${formatDate(item['dsdStartDate'] ?? '')}",
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
                      "วันสิ้นสุด ${formatDate(item['dsdEndDate'] ?? '')}",
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
                    onTap: () async {
                      final url = buildDsdUrl(item);
                      await launchURL(url);
                    },
                    child: Container(
                      width: double.infinity,

                      decoration: BoxDecoration(
                        color: Color(0xFF6FC546),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
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
  }
}
