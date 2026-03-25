import 'package:dsd/blank_page/appbar.dart';
import 'package:dsd/blank_page/carousel.dart';
import 'package:dsd/blank_page/format.dart';
import 'package:dsd/blank_page/textfield.dart';
import 'package:dsd/license_page.dart';
import 'package:dsd/login.dart';
import 'package:dsd/model/service_data.dart';
import 'package:dsd/news/new_all.dart';
import 'package:dsd/news/new_detail.dart';
import 'package:dsd/privilege/privilege_all.dart';
import 'package:dsd/privilege/privilege_detail.dart';
import 'package:dsd/service_allpage.dart';
import 'package:dsd/shared/api_provider.dart';
import 'package:dsd/style_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HomePage extends StatefulWidget {
  final Function(int) onTabChange;
  const HomePage({Key? key, required this.onTabChange})
    : super(key: key); // ✅ แก้ตรงนี้

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final storage = FlutterSecureStorage();
  String _imageUrl = '';
  String _code = '';

  final txtFirstName = TextEditingController();
  final txtLastName = TextEditingController();
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    _registerRead();
    super.initState();
  }

  void refreshPage() {
    setState(() {
      _code = '';
      _imageUrl = '';
      txtFirstName.clear();
      txtLastName.clear();
    });
    _registerRead();
  }

  /*===============================>> API <<=============================== */

  Future<List<Map<String, dynamic>>> _futureNews() async {
    final data = await postDio('${newsApi}read', {'limit': 10});

    return (data as List).cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> _futurePrivilege() async {
    final data = await postDio('${privilegeApi}read', {'limit': 10});

    return (data as List).cast<Map<String, dynamic>>();
  }

  Future<void> _registerRead() async {
    // var value = await storage.read(key: 'dataUserLoginDDPM') ?? ''; // local
    final code = await storage.read(key: 'profileCode');

    setState(() {
      _code = code ?? '';
      print('###########################');
      print(_code);
    });

    final value = await postLoginRegister('${register}read', {
      "code": _code,
    }); // api

    if (value.isNotEmpty) {
      try {
        var user = value['objectData'][0];
        setState(() {
          _imageUrl = user['imageUrl'] ?? '';
          txtFirstName.text = user['firstName'] ?? '';
          txtLastName.text = user['lastName'] ?? '';
        });
      } catch (_) {}
    }
  }
  /*===============================>> API <<=============================== */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarHome(
        context: context,
        profileAction: () {
          _code == ''
              ? Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              )
              : null;
        },
        name:
            _code != ''
                ? '${txtFirstName.text} ${txtLastName.text}'
                : 'ท่านยังไม่ได้เข้าสู่ระบบ',
        memberType: _code != '' ? 'ช่าง' : 'คลิกเพิ่อเข้าสู่ระบบ',
        imagenetwork: _code != '' ? true : false,
        imageUrl: _code != '' ? _imageUrl : 'assets/DSD/imgs/profile.png',

        rightWidget:
            _code != ''
                ? Row(
                  children: [
                    GestureDetector(
                      onTap:
                          () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PageLicense(),
                              ),
                            ),
                          },
                      child: Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: Colors.white,
                          border: Border.all(
                            width: 1,
                            color: const Color(0xFFDBDBDB),
                          ),
                        ),
                        child: Image.asset(
                          "assets/DSD/imgs/qr_bg.png",
                          width: 35,
                          height: 35,
                          // color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                )
                : SizedBox(),
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildSearch(controller: searchController, hintText: "Search..."),
              SizedBox(height: 16),
              _buildRowText(
                title: 'บริการ',
                onTap: () {
                  print('-----> บริการ');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              ServiceAllPage(onTabChange: widget.onTabChange),
                    ),
                  );
                },
              ),
              SizedBox(height: 16),
              _buildServiceSection(),
              SizedBox(height: 16),
              _buildRowText(
                title: 'ข่าวประชาสัมพันธ์',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NewAll()),
                  );
                },
              ),
              SizedBox(height: 16),
              _buildNew(),
              SizedBox(height: 16),
              _buildRowText(
                title: 'สิทธิประโยชน์',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PrivilegeAll()),
                  );
                },
              ),
              SizedBox(height: 16),
              _buildPrivilege(),
            ],
          ),
        ),
      ),
    );
  }

  _buildRowText({required String title, required VoidCallback onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Kanit',
          ),
        ),
        InkWell(
          onTap: () => onTap(),
          child: Text(
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
        // childAspectRatio: 0.85,
      ),
      itemBuilder: (context, index) {
        final service = services[index];

        return _buildServiceCard(
          service.title,
          service.image,
          onTap: () {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              // ✅
              service.onTap(context);
            });
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
                color: AppColors.primary,
                alignment: Alignment.center,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
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
