import 'package:dsd/blank_page/appbar.dart';
import 'package:dsd/blank_page/carousel.dart';
import 'package:dsd/blank_page/textfield%20.dart';
import 'package:dsd/license_page.dart';
import 'package:dsd/model/new_data.dart';
import 'package:dsd/model/privilege.dart';
import 'package:dsd/model/service_data.dart';
import 'package:dsd/new_all.dart';
import 'package:dsd/new_detail.dart';
import 'package:dsd/privilege_all.dart';
import 'package:dsd/privilege_detail.dart';
import 'package:dsd/service_allpage.dart';
import 'package:dsd/style_theme.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final Function(int) onTabChange;
  const HomePage({super.key, required this.onTabChange});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarHome(
        context: context,
        name: 'ออกแบบ ทดลอง',
        memberType: 'ช่าง',
        imageUrl: 'assets/DSD/imgs/Rectangle 3412.png',
        rightWidget: Row(
          children: [
            GestureDetector(
              onTap:
                  () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PageLicense()),
                    ),
                  },
              child: Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: Colors.white,
                  border: Border.all(width: 1, color: const Color(0xFFDBDBDB)),
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildSearch(controller: searchController, hintText: "Search..."),
              SizedBox(height: 16),
              _buildRowText(
                title: 'บริการ',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ServicePage()),
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
          onTap: () => service.onTap(context),
        );
      },
    );
  }

  Widget _buildServiceCard(
    String title,
    String imageUrl, {
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Stack(
        children: [
          // Positioned.fill(child: Image.network(imageUrl, fit: BoxFit.fill)),
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
    );
  }

  _buildNew() {
    return CarouselBanner<NewsData>(
      items: newsList,
      height: 200,
      itemBuilder: (context, news) {
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => NewsDetailPage(news: news)),
            );
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(news.image, fit: BoxFit.cover),

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
                        news.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Kanit',
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                      ),

                      Row(
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                'assets/DSD/icon/icon date.png',
                                width: 14,
                              ),
                              SizedBox(width: 12),
                              Text(
                                news.date,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 10),

                          Row(
                            children: [
                              Image.asset(
                                'assets/DSD/icon/bookmark.png',
                                width: 14,
                              ),
                              SizedBox(width: 12),
                              Text(
                                news.shareCount,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(width: 10),

                          Row(
                            children: [
                              Image.asset(
                                'assets/DSD/icon/share.png',
                                width: 14,
                              ),
                              SizedBox(width: 12),
                              Text(
                                news.Bookmarked,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ],
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
  }

  _buildPrivilege() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 10),
      itemCount: privileges.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        // childAspectRatio: 0.85,
      ),
      itemBuilder: (context, index) {
        final privilege = privileges[index];

        return _buildPrivilegeCard(
          privilege.title,
          privilege.image,
          privilege.date,
          privilege.bookmark,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PrivilegeDetail(privilege: privilege),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPrivilegeCard(
    String title,
    String imageUrl,
    String date,
    String bookmark, {
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Positioned.fill(child: Image.asset(imageUrl, fit: BoxFit.cover)),

              /// bottom content
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// title
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Kanit',
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 6),

                      /// date + bookmark
                      Row(
                        children: [
                          /// date
                          Row(
                            children: [
                              Image.asset(
                                'assets/DSD/icon/icon date.png',
                                width: 14,
                                color: AppColors.borderColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                date,
                                style: const TextStyle(
                                  color: AppColors.borderColor,
                                  fontSize: 11,
                                  fontFamily: 'Kanit',
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(width: 12),

                          /// bookmark
                          Row(
                            children: [
                              Image.asset(
                                'assets/DSD/icon/bookmark.png',
                                width: 14,
                                color: AppColors.borderColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                bookmark,
                                style: const TextStyle(
                                  color: AppColors.borderColor,
                                  fontSize: 11,
                                  fontFamily: 'Kanit',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
