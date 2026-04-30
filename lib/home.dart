import 'package:dsd/blank_page/appbar.dart';
import 'package:dsd/blank_page/carousel.dart';
import 'package:dsd/blank_page/format.dart';
import 'package:dsd/blank_page/textfield.dart';
import 'package:dsd/course/course_all.dart';
import 'package:dsd/license/license_page.dart';
import 'package:dsd/login.dart';
import 'package:dsd/service/service_data.dart';
import 'package:dsd/news/new_all.dart';
import 'package:dsd/news/new_detail.dart';
import 'package:dsd/privilege/privilege_all.dart';
import 'package:dsd/privilege/privilege_detail.dart';
import 'package:dsd/service/service_allpage.dart';
import 'package:dsd/shared/api_provider.dart';
import 'package:dsd/style_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HomePage extends StatefulWidget {
  final Function(int) onTabChange;
  const HomePage({super.key, required this.onTabChange});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final storage = FlutterSecureStorage();

  String _imageUrl = '';
  String _code = '';
  String category = '';
  String idcard = '';

  final txtFirstName = TextEditingController();
  final txtLastName = TextEditingController();
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  /*===============================>> LOAD DATA <<=============================== */

  Future<void> loadData() async {
    final code = await storage.read(key: 'profileCode');
    final profileCategory = await storage.read(key: 'profileCategory');

    print('-------- >> profileCode : $code');
    if (code == null || code.isEmpty) {
      if (!mounted) return;
      setState(() {
        _code = '';
        category = '';
        _imageUrl = '';
        txtFirstName.clear();
        txtLastName.clear();
      });
      return;
    }

    _code = code;
    category = profileCategory ?? '';

    final value = await postapi('${register}read', {"code": _code});

    if (value != null &&
        value['objectData'] != null &&
        value['objectData'].isNotEmpty) {
      var user = value['objectData'][0];

      if (!mounted) return;
      setState(() {
        _imageUrl = user['imageUrl'] ?? '';
        txtFirstName.text = user['firstName'] ?? '';
        txtLastName.text = user['lastName'] ?? '';
        idcard = user['idcard'] ?? '';
      });
    }
  }

  List<Map<String, String>> mockCourse = [
    {
      "SITE": "สถาบันพัฒนาฝีมือแรงงาน 15 พระนครศรีอยุธยา",
      "DEPT_ID": "14",
      "TRAINING_ID": "0331887",
      "TRAINING_OCCUPATION_ID": "2220017230213",
      "COURSE":
          "Content Marketing และการขายออนไลน์ด้วยเทคโนโลยีปัญญาประดิษฐ์ (AI)",
      "PERIOD": "30",
      "CLASS_NO": "1",
      "DSD_START_DATE": "2026-05-07T17:00:00.000Z",
      "DSD_END_DATE": "2026-05-21T17:00:00.000Z",
      "ACTIVITY_ID": "2",
      "PROVINCE_NAME": "พระนครศรีอยุธยา",
      "BUDGET_YEAR": "2569",
    },
    {
      "SITE": "สถาบันพัฒนาฝีมือแรงงาน 17 ระยอง",
      "DEPT_ID": "21",
      "TRAINING_ID": "0330725",
      "TRAINING_OCCUPATION_ID": "0920222091102",
      "COURSE": "การใช้เครื่องมือวัดละเอียดทางมิติ",
      "PERIOD": "30",
      "CLASS_NO": "2",
      "DSD_START_DATE": "2026-05-08T17:00:00.000Z",
      "DSD_END_DATE": "2026-05-16T17:00:00.000Z",
      "ACTIVITY_ID": "2",
      "PROVINCE_NAME": "ระยอง",
      "BUDGET_YEAR": "2569",
    },
    {
      "SITE": "สำนักงานพัฒนาฝีมือแรงงานกาฬสินธุ์",
      "DEPT_ID": "46",
      "TRAINING_ID": "0321762",
      "TRAINING_OCCUPATION_ID": "0930014150101",
      "COURSE": "การใช้เทคโนโลยีเพื่อจัดการน้ำสำหรับโรงเรือนเกษตรอัจฉริยะ",
      "PERIOD": "18",
      "CLASS_NO": "2",
      "DSD_START_DATE": "2026-05-10T17:00:00.000Z",
      "DSD_END_DATE": "2026-05-14T17:00:00.000Z",
      "ACTIVITY_ID": "3",
      "PROVINCE_NAME": "กาฬสินธุ์",
      "BUDGET_YEAR": "2569",
    },
    {
      "SITE": "สถาบันพัฒนาฝีมือแรงงาน 27 สมุทรสาคร",
      "DEPT_ID": "74",
      "TRAINING_ID": "0332033",
      "TRAINING_OCCUPATION_ID": "7920183400103",
      "COURSE": "การซ่อมบำรุงและดัดแปลงจักรยานยนต์ไฟฟ้า",
      "PERIOD": "30",
      "CLASS_NO": "2",
      "DSD_START_DATE": "2026-05-10T17:00:00.000Z",
      "DSD_END_DATE": "2026-05-14T17:00:00.000Z",
      "ACTIVITY_ID": "2",
      "PROVINCE_NAME": "สมุทรสาคร",
      "BUDGET_YEAR": "2569",
    },
    {
      "SITE": "สถาบันพัฒนาฝีมือแรงงาน 43 ตาก",
      "DEPT_ID": "63",
      "TRAINING_ID": "0325379",
      "TRAINING_OCCUPATION_ID": "0920227460307",
      "COURSE": "ภาษาเกาหลีสำหรับผู้ที่จะเดินทางหรือทำงานอยู่ในต่างประเทศ",
      "PERIOD": "30",
      "CLASS_NO": "1",
      "DSD_START_DATE": "2026-05-17T17:00:00.000Z",
      "DSD_END_DATE": "2026-05-21T17:00:00.000Z",
      "ACTIVITY_ID": "2",
      "PROVINCE_NAME": "ตาก",
      "BUDGET_YEAR": "2569",
    },

    // 👉 ตัวอย่าง: ที่เหลือใช้ pattern เดิม (ตัดให้ไม่ยาวเกิน)
    {
      "SITE": "สถาบันพัฒนาฝีมือแรงงาน 37 บุรีรัมย์",
      "DEPT_ID": "31",
      "TRAINING_ID": "0328848",
      "TRAINING_OCCUPATION_ID": "0920227230415",
      "COURSE": "การบริหารสินค้าคงคลัง",
      "PERIOD": "30",
      "CLASS_NO": "2",
      "DSD_START_DATE": "2026-05-17T17:00:00.000Z",
      "DSD_END_DATE": "2026-05-21T17:00:00.000Z",
      "ACTIVITY_ID": "2",
      "PROVINCE_NAME": "บุรีรัมย์",
      "BUDGET_YEAR": "2569",
    },
    {
      "SITE": "สถาบันพัฒนาฝีมือแรงงาน 15 พระนครศรีอยุธยา",
      "DEPT_ID": "14",
      "TRAINING_ID": "0331831",
      "TRAINING_OCCUPATION_ID": "1020014220601",
      "COURSE": "AI Generative and Data for Marketing",
      "PERIOD": "30",
      "CLASS_NO": "1",
      "DSD_START_DATE": "2026-05-17T17:00:00.000Z",
      "DSD_END_DATE": "2026-05-25T17:00:00.000Z",
      "ACTIVITY_ID": "2",
      "PROVINCE_NAME": "พระนครศรีอยุธยา",
      "BUDGET_YEAR": "2569",
    },
  ];

  /*============================>> REFRESH <<============================= */

  Future<void> refreshPage() async {
    await loadData();
  }

  /*============================>> API LIST <<============================ */

  Future<List<Map<String, dynamic>>> _futureNews() async {
    final data = await postDio('${newsApi}read', {'limit': 10});
    return (data as List).cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> _futurePrivilege() async {
    final data = await postDio('${privilegeApi}read', {'limit': 10});
    return (data as List).cast<Map<String, dynamic>>();
  }

  /*===============================>> UI <<=============================== */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarHome(
        context: context,
        profileAction: () {
          if (_code.isEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          } else {
            widget.onTabChange(3); // ไปที่หน้า Notification
          }
        },
        name:
            _code.isNotEmpty
                ? '${txtFirstName.text} ${txtLastName.text}'
                : 'ท่านยังไม่ได้เข้าสู่ระบบ',
        memberType:
            _code.isNotEmpty
                ? (idcard != '' ? 'ช่าง' : 'บุคคลทั่วไป')
                : 'คลิกเพิ่อเข้าสู่ระบบ',
        imagenetwork: _code.isNotEmpty,
        imageUrl: _code.isNotEmpty ? _imageUrl : 'assets/DSD/imgs/profile.png',
        rightWidget:
            _code.isNotEmpty
                ? Row(
                  children: [
                    idcard != ''
                        ? GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PageLicense(),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),

                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              color: Color(0xFFBB439C),
                              border: Border.all(
                                width: 1,
                                color: const Color(0xFFDBDBDB),
                              ),
                            ),
                            child: Image.asset(
                              "assets/DSD/icon/icon_portfolio.png",
                              width: 30,
                              height: 30,
                            ),
                          ),
                        )
                        : GestureDetector(
                          onTap: () {
                            widget.onTabChange(2); // ไปที่หน้า Notification
                          },
                          child: _circleIcon(
                            Icon(
                              Icons.notification_add,
                              color: AppColors.primary,
                              size: 30,
                            ),
                          ),
                        ),
                  ],
                )
                : const SizedBox(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: 16,
            left: 16,
            right: 16,
            bottom: 65 + MediaQuery.of(context).padding.bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildSearch(controller: searchController, hintText: "Search..."),
              const SizedBox(height: 16),

              _buildRowText('บริการ', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            ServiceAllPage(onTabChange: widget.onTabChange),
                  ),
                );
              }),
              const SizedBox(height: 16),
              _buildServiceSection(),
              const SizedBox(height: 16),
              _buildRowText('คอร์สอบรมแนะนำสำหรับคุณ', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CourseAll(
                    course: mockCourse,
                  )),
                );
              }),
              const SizedBox(height: 16),
              _buildCourse(),

              const SizedBox(height: 16),
              _buildRowText('ข่าวประชาสัมพันธ์', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewAll()),
                );
              }),
              const SizedBox(height: 16),
              _buildNew(),

              const SizedBox(height: 16),
              _buildRowText('สิทธิประโยชน์', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PrivilegeAll()),
                );
              }),
              const SizedBox(height: 16),
              _buildPrivilege(),
            ],
          ),
        ),
      ),
    );
  }

  /*===============================>> WIDGET <<=============================== */

  Widget _circleIcon(Widget child) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white,
        border: Border.all(width: 1, color: const Color(0xFFDBDBDB)),
      ),
      child: child,
    );
  }

  Widget _buildRowText(String title, VoidCallback onTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Kanit',
          ),
        ),
        InkWell(
          onTap: onTap,
          child: const Text(
            "ดูทั้งหมด >",
            style: TextStyle(color: Colors.grey, fontFamily: 'Kanit'),
          ),
        ),
      ],
    );
  }

  Widget _buildServiceSection() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 10),
      itemCount: services.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        final service = services[index];

        return _buildServiceCard(
          service.title,
          service.image,
          onTap: () {
            service.onTap(context, widget.onTabChange); // ✅ ส่งเพิ่มตรงนี้
          },
        );
      },
    );
  }

  Widget _buildServiceCard(
    String title,
    String imageUrl, {
    required VoidCallback onTap,
  }) {
    return Material(
      // ✅ เพิ่มตรงนี้
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            Positioned.fill(child: Image.asset(imageUrl, fit: BoxFit.fill)),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 35,
                color: AppColors.primarysecond,
                alignment: Alignment.center,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Kanit',
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourse() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.28,
      child: ListView.separated(
        separatorBuilder:
            (BuildContext context, int index) => const SizedBox(width: 12),
        scrollDirection: Axis.horizontal,
        itemCount: mockCourse.length,
        itemBuilder: (context, index) {
          final course = mockCourse[index];
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
                    child: Image.asset(
                      'assets/DSD/imgs/2.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsGeometry.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course['COURSE'] ?? '',
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
                            " ระยะเวลาที่ฝึก ${course['PERIOD'] ?? ''} ชั่วโมง",
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
                            "วันเริ่ม ${formatDate(course['DSD_START_DATE'] ?? '')}",
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
                            "วันสิ้นสุด ${formatDate(course['DSD_END_DATE'] ?? '')}",
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
    );
  }

  Widget _buildNew() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _futureNews(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox();
        }
        final newsList = snapshot.data!;

        return CarouselBanner<Map<String, dynamic>>(
          items: newsList,
          height: 200,
          itemBuilder: (context, news) {
            return InkWell(
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => NewsDetailPage(news: news),
                    ),
                  ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    news['imageUrl'] ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: Colors.grey),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.transparent, Colors.black87],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            news['title'] ?? '',
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'Kanit',
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                          ),
                          Row(
                            children: [
                              Image.asset(
                                'assets/DSD/icon/icon date.png',
                                width: 14,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                // news['docDate'] ?? '',
                                formatDate(news['docDate'] ?? ''),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  _buildPrivilege() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _futurePrivilege(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox();
        }
        final privilege = snapshot.data!;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: 10),
          itemCount: privilege.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.87,
          ),
          itemBuilder: (context, index) {
            final item = privilege[index];
            return _buildPrivilegeCard(
              item['title'] ?? '',
              item['imageUrl'] ?? '',
              item['dateStart'] ?? '',

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PrivilegeDetail(privilege: item),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildPrivilegeCard(
    String title,
    String imageUrl,
    String date, {
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Image.network(
                  // item['imageUrl'] ?? '',
                  imageUrl,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (_, __, ___) =>
                          Container(height: 120, color: Colors.grey[200]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // ignore: unnecessary_null_comparison
                    date != null && date != '' && date != 'Invalid date'
                        ? Row(
                          children: [
                            Image.asset(
                              'assets/DSD/icon/icon date.png',
                              width: 14,
                              color: AppColors.borderColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              formatDate(date),

                              style: const TextStyle(
                                color: AppColors.borderColor,
                                fontSize: 11,
                                fontFamily: 'Kanit',
                              ),
                            ),
                          ],
                        )
                        : SizedBox(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
