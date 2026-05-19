import 'package:dsd/blank_page/appbar.dart';
import 'package:dsd/blank_page/carousel.dart';
import 'package:dsd/blank_page/format.dart';
import 'package:dsd/blank_page/textfield.dart';
import 'package:dsd/shared/app_strings.dart';
import 'package:dsd/training/training_all.dart';
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
  bool isCert = false;

  final txtFirstName = TextEditingController();
  final txtLastName = TextEditingController();
  final searchController = TextEditingController();
  List<Map<String, String>> training = [];

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
        isCert = user['isCert'];
      });
    }
  }

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

  Future<List<Map<String, dynamic>>> _futureTraining() async {
    final data = await postDio('${trainingApi}readAPI', {"keySearch": "2569"});
    return (data as List).cast<Map<String, dynamic>>();
  }

  /*===============================>> UI <<=============================== */

  Widget _buildRightWidget(
    BuildContext context,
    bool isLoggedIn,
    bool hasIdCard,
    bool isCertified,
  ) {
    if (!isLoggedIn || !hasIdCard) {
      return const SizedBox();
    }

    if (isCertified) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PageLicense()),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: const Color(0xFFBB439C),
            border: Border.all(width: 1, color: const Color(0xFFDBDBDB)),
          ),
          child: Image.asset(
            "assets/DSD/icon/icon_portfolio.png",
            width: 30,
            height: 30,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        widget.onTabChange(2);
      },
      child: _circleIcon(
        Icon(Icons.notification_add, color: AppColors.primary, size: 30),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final language = AppStrings.of(context); // ← ดึง strings ตาม locale
    final bool isLoggedIn = _code.isNotEmpty;
    final bool hasIdCard = idcard.isNotEmpty;
    final bool isCertified = isCert;

    final String name =
        isLoggedIn
            ? '${txtFirstName.text} ${txtLastName.text}'
            : language.logged;

    final String memberType =
        !isLoggedIn
            ? language.tologin
            : !hasIdCard
            ? language.verified
            : isCertified
            ? language.certified
            : language.general;

    final String imageUrl = isLoggedIn ? _imageUrl : '';
    return Scaffold(
      appBar: AppBarHome(
        name: name,
        memberType: memberType,
        imageUrl: imageUrl,
        onProfileTap: () {
          if (!isLoggedIn) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          } else {
            widget.onTabChange(3);
          }
        },
        rightWidget: _buildRightWidget(
          context,
          isLoggedIn,
          hasIdCard,
          isCertified,
        ),
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
              buildSearch(
                controller: searchController,
                hintText: "${language.search}...",
              ),
              const SizedBox(height: 16),

              _buildRowText(language.service, () {
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
              _buildRowText(language.recommended, () async {
                final data = await _futureTraining(); // 🔥 รอก่อน

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TrainingAll()),
                );
              }),
              const SizedBox(height: 16),
              _buildCourse(),

              const SizedBox(height: 16),
              _buildRowText(language.pressrelease, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewAll()),
                );
              }),
              const SizedBox(height: 16),
              _buildNew(),

              const SizedBox(height: 16),
              _buildRowText(language.privilege, () {
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
    final language = AppStrings.of(context); // ← ดึง strings ตาม locale
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
          child: Text(
            "${language.seeall} >",
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
      itemCount: services(context).length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        final service = services(context)[index];

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
    return FutureBuilder(
      future: _futureTraining(),
      builder: (context, snapshot) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.28,
          child: ListView.separated(
            separatorBuilder:
                (BuildContext context, int index) => const SizedBox(width: 12),
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (context, index) {
              final training = snapshot.data!;

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
                            training[index]['course'] ?? '',
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
                                " ระยะเวลาที่ฝึก ${training[index]['period'] ?? ''} ชั่วโมง",
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
                                "วันเริ่ม ${formatDate(training[index]['dsdStartDate'] ?? '')}",
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
                                "วันสิ้นสุด ${formatDate(training[index]['dsdEndDate'] ?? '')}",
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
      },
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
