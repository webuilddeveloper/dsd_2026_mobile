import 'package:dsd/blank_page/appbar.dart';
import 'package:dsd/blank_page/format.dart';
import 'package:dsd/blank_page/launch.dart';
import 'package:dsd/blank_page/textfield.dart';
import 'package:dsd/blank_page/webview.dart';
import 'package:dsd/shared/api_provider.dart';
import 'package:dsd/shared/app_strings.dart';
import 'package:dsd/shared/locale_provider.dart';
import 'package:dsd/style_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TrainingAll extends StatefulWidget {
  const TrainingAll({super.key, this.request});
  final Future<dynamic> Function(String, Map<String, dynamic>)? request;

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
  bool _categoryError = false;
  Object? _categoryFailure;
  bool _categoryLoading = false;

  Future<dynamic> _post(String url, Map<String, dynamic> body) =>
      (widget.request ?? postDio)(url, body).timeout(
        const Duration(seconds: 30),
      );

  @override
  void dispose() {
    courseSearch.dispose();
    super.dispose();
  }

  void _retryTraining() {
    setState(() {
      futureTraining = fetchTraining(
        categoryCode:
            category.isEmpty
                ? null
                : category[selectedIndex]['code']?.toString(),
      );
    });
  }

  Widget _connectionError(Object? error, VoidCallback retry) {
    final language = AppStrings.of(context);
    final message = error?.toString().replaceFirst('Exception: ', '').trim();
    return Align(
      alignment: Alignment.topCenter,
      child: Tooltip(
        message: language.calendarRetry,
        child: InkWell(
          onTap: retry,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 4),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF9E6),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.35),
                width: 1,
              ),
            ),
            child: Text(
              message == null || message.isEmpty
                  ? language.trainingConnectionError
                  : message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                fontFamily: 'Kanit',
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    futureTraining = fetchTraining(); // ✅ โหลดครั้งแรก
    TrainingCategoryApi();
  }

  List<Map<String, dynamic>> mockTraining = [
    {
      'trainingId': '0333454',
      'course': 'ช่างปูกระเบื้อง(ช่างปู)',
      'classNo': 1,
      'site': 'สถาบันพัฒนาฝีมือแรงงาน 42 หนองคาย',
      'dsdStartDate': '2026-07-06',
      'dsdEndDate': '2026-07-09',
      'period': 30,
      'status2': false,
    },
    {
      'trainingId': '0321757',
      'course': 'การใช้เทคโนโลยีเพื่อจัดการน้ำสำหรับโรงเรือนเกษตรอัจฉริยะ',
      'classNo': 2,
      'site': 'สำนักงานพัฒนาฝีมือแรงงานกาฬสินธุ์',
      'dsdStartDate': '2026-07-13',
      'dsdEndDate': '2026-07-17',
      'period': 18,
      'status2': false,
    },
    {
      'trainingId': '0327396',
      'course': 'การบำรุงรักษาเครื่องปรับอากาศในบ้านและการพาณิชย์ขนาดเล็ก',
      'classNo': 3,
      'site': 'สำนักงานพัฒนาฝีมือแรงงานเลย',
      'dsdStartDate': '2026-07-13',
      'dsdEndDate': '2026-07-17',
      'period': 30,
      'status2': false,
    },
    {
      'trainingId': '0326287',
      'course': 'การประกอบธุรกิจเครื่องดื่มมืออาชีพ',
      'classNo': 4,
      'site': 'สำนักงานพัฒนาฝีมือแรงงานเลย',
      'dsdStartDate': '2026-07-13',
      'dsdEndDate': '2026-07-17',
      'period': 30,
      'status2': true,
    },
    {
      'trainingId': '0333926',
      'course':
          'เทคนิคการเพาะเลี้ยงผึ้งโพรงป่าด้วยนวัตกรรมการอนุรักษ์เชิงธรรมชาติ',
      'classNo': 5,
      'site': 'สำนักงานพัฒนาฝีมือแรงงานเลย',
      'dsdStartDate': '2026-07-15',
      'dsdEndDate': '2026-07-17',
      'period': 18,
      'status2': false,
    },
    {
      'trainingId': '0328033',
      'course': 'พื้นฐานระบบปัญญาประดิษฐ์',
      'classNo': 6,
      'site': 'สำนักงานพัฒนาฝีมือแรงงานมหาสารคาม',
      'dsdStartDate': '2026-07-18',
      'dsdEndDate': '2026-07-26',
      'period': 30,
      'status2': true,
    },
  ];

  /*================ API =================*/

  Future<List<Map<String, dynamic>>> fetchTraining({
    String? categoryCode,
  }) async {
    final body = {"keySearch": "2569"};

    // ✅ ส่งเฉพาะตอนมี category
    if (categoryCode != null && categoryCode.isNotEmpty) {
      body["category"] = categoryCode;
    }

    final data = await _post('${trainingApi}readAPI', body);
    return (data as List).cast<Map<String, dynamic>>();
  }
  // Future<List<Map<String, dynamic>>> fetchTraining({
  //   String? categoryCode,
  // }) async {
  //   if (categoryCode == null || categoryCode.isEmpty) {
  //     return mockTraining;
  //   }

  //   return mockTraining.where((e) => e['category'] == categoryCode).toList();
  // }

  // ignore: non_constant_identifier_names
  Future<void> TrainingCategoryApi() async {
    if (_categoryLoading) return;
    setState(() {
      _categoryLoading = true;
      _categoryError = false;
    });
    try {
      final data = await _post('${trainingCategoryApi}read', {'limit': 999});
      final rows = (data as List).cast<Map<String, dynamic>>();
      if (!mounted) return;
      setState(() {
        category = [
          {'code': '', 'title': 'ทั้งหมด', 'titleEN': 'All'},
          ...rows,
        ];
      });
    } catch (error) {
      if (mounted)
        setState(() {
          _categoryError = true;
          _categoryFailure = error;
        });
    } finally {
      if (mounted) setState(() => _categoryLoading = false);
    }
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
    final provider = context.watch<LocaleProvider>();
    final selectedCode = provider.locale.languageCode;
    String _code = '';

    final bool isLoggedIn = _code.isNotEmpty;

    return Scaffold(
      appBar: appBar(
        title: isLoggedIn ? language.recommended : language.recommendedGuest,
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

            if (_categoryError)
              _connectionError(_categoryFailure, TrainingCategoryApi),
            if (_categoryLoading) const LinearProgressIndicator(),
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
                          selectedCode == "th"
                              ? category[index]['title']
                              : category[index]['titleEN'] ?? '',

                          style: TextStyle(color: Colors.black),
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

                  if (snapshot.hasError) {
                    return _connectionError(snapshot.error, _retryTraining);
                  }
                  final filtered = getFilteredList(snapshot.data ?? []);
                  if (filtered.isEmpty) {
                    return Center(child: Text(language.noData));
                  }

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
    final language = AppStrings.of(context);
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
                SizedBox(
                  height: 34,
                  child: Text(
                    item['course'] ?? '',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
                      final url = buildTrainingUrl(item);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => WebViewPage(
                                url: url,
                                title: language.trainingCourses,
                              ),
                        ),
                      );
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
