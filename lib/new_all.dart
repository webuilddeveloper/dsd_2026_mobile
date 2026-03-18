import 'package:dsd/blank_page/appbar.dart';
import 'package:dsd/blank_page/textfield%20.dart';
import 'package:dsd/model/new_data.dart';
import 'package:dsd/new_detail.dart';
import 'package:dsd/style_theme.dart';
import 'package:flutter/material.dart';

class NewAll extends StatefulWidget {
  const NewAll({super.key});

  @override
  State<NewAll> createState() => _NewAllState();
}

class _NewAllState extends State<NewAll> {
  void goBack() {
    Navigator.pop(context);
  }

  final TextEditingController newSearch = TextEditingController();
  int selectedIndex = 0;

  final List<String> tabs = [
    'ทั้งหมด',
    'ประชาสัมพันธ์',
    'ข่าวฝึกอบรม',
    'ข่าวมาตรฐานฝีมือแรงงาน',
  ];

  List<NewsData> getFiltered() {
    List<NewsData> news = newsList;

    if (selectedIndex == 1) {
      news = news.where((e) => e.type == '1').toList();
    } else if (selectedIndex == 2) {
      news = news.where((e) => e.type == '2').toList();
    } else if (selectedIndex == 3) {
      news = news.where((e) => e.type == '3').toList();
    }
    // 🔥 selectedIndex == 0 = ทั้งหมด → ไม่ต้อง filter

    if (newSearch.text.isNotEmpty) {
      final keyword = newSearch.text.toLowerCase();

      news =
          news.where((e) => e.title.toLowerCase().contains(keyword)).toList();
    }

    return news;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        title: "ข่าวประชาสัมพันธ์",
        rightBtn: false,
        backBtn: true,
        backAction: () => goBack(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            buildSearch(
              hintText: "Search",
              controller: newSearch,
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
                children: List.generate(tabs.length, (index) {
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
                            tabs[index],
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
            SizedBox(height: 16),
            Expanded(
              child: Builder(
                builder: (context) {
                  final news = getFiltered();

                  if (news.isEmpty) {
                    return Center(child: Text("ไม่พบข้อมูล"));
                  }

                  return ListView.builder(
                    itemCount: news.length,
                    itemBuilder: (context, index) {
                      // 🔥 ข่าวแรก
                      if (index == 0) {
                        return Column(
                          children: [
                            buildHighlightNews(news.first),
                            const SizedBox(height: 12),
                          ],
                        );
                      }

                      // 🔥 ข่าวรายการ
                      final item = news[index];

                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: 12,
                        ), // ✅ spacing ระหว่างรายการ
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: AppColors.borderColor,
                              width: 1,
                            ),
                          ),
                          child: buildNewsItem(item),
                        ),
                      );
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

  Widget buildHighlightNews(NewsData news) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => NewsDetailPage(news: news)),
        );
      },
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: AssetImage(news.image),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          padding: const EdgeInsets.all(12),
          alignment: Alignment.bottomLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                news.title,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Row(
                    children: [
                      Image.asset('assets/DSD/icon/icon date.png', width: 14),
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
                      Image.asset('assets/DSD/icon/bookmark.png', width: 14),
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
                      Image.asset('assets/DSD/icon/share.png', width: 14),
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
    );
  }

  Widget buildNewsItem(NewsData news) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => NewsDetailPage(news: news)),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                news.image,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    news.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/DSD/icon/icon date.png',
                            width: 14,
                            color: AppColors.textgrey,
                          ),
                          SizedBox(width: 12),
                          Text(
                            news.date,
                            style: const TextStyle(
                              color: AppColors.textgrey,
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

                            color: AppColors.textgrey,
                          ),
                          SizedBox(width: 12),
                          Text(
                            news.shareCount,
                            style: const TextStyle(
                              color: AppColors.textgrey,
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
                            color: AppColors.textgrey,
                          ),
                          SizedBox(width: 12),
                          Text(
                            news.Bookmarked,
                            style: const TextStyle(
                              color: AppColors.textgrey,
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
          ],
        ),
      ),
    );
  }
}
