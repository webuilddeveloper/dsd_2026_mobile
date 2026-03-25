import 'package:dsd/blank_page/appbar.dart';
import 'package:dsd/blank_page/textfield.dart';
import 'package:dsd/news/new_detail.dart';
import 'package:dsd/shared/api_provider.dart';
import 'package:dsd/style_theme.dart';
import 'package:flutter/material.dart';

class NewAll extends StatefulWidget {
  const NewAll({super.key}); // ✅ ไม่รับค่าจากข้างนอก

  @override
  State<NewAll> createState() => _NewAllState();
}

class _NewAllState extends State<NewAll> {
  void goBack() => Navigator.pop(context);

  final TextEditingController newSearch = TextEditingController();
  int selectedIndex = 0;
  List<Map<String, dynamic>> allNews = [];
  List<Map<String, dynamic>> category = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _newsApi();
    _newsCategoryApi();
  }

  /*===============================>> API <<=============================== */
  Future<void> _newsApi() async {
    final data = await postDio('${newsApi}read', {'limit': 10});
    setState(() {
      allNews = (data as List).cast<Map<String, dynamic>>();
      isLoading = false;
    });
  }

  Future<void> _newsCategoryApi() async {
    final data = await postDio('${newsCategoryApi}read', {'limit': 10});
    setState(() {
      // ✅ เพิ่ม "ทั้งหมด" ไว้ตัวแรกเสมอ
      category = [
        {'code': '', 'title': 'ทั้งหมด'},
        ...(data as List).cast<Map<String, dynamic>>(),
      ];
      isLoading = false;
    });
  }
  /*===============================>> API <<=============================== */

  List<Map<String, dynamic>> getFiltered() {
    List<Map<String, dynamic>> news = allNews;

    // ✅ filter ตาม category code
    if (selectedIndex != 0) {
      final selectedCode = category[selectedIndex]['code'];
      news = news.where((e) => e['category'] == selectedCode).toList();
    }

    // 🔍 filter จาก search
    if (newSearch.text.isNotEmpty) {
      final keyword = newSearch.text.toLowerCase();
      news =
          news
              .where((e) => (e['title'] ?? '').toLowerCase().contains(keyword))
              .toList();
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
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Column(
                  children: [
                    buildSearch(
                      hintText: "Search",
                      controller: newSearch,
                      rightBtn: true,
                      onFilterTap: () {},
                      onChanged: (value) => setState(() {}),
                    ),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(category.length, (index) {
                          final isSelected = selectedIndex == index;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: InkWell(
                              onTap:
                                  () => setState(() => selectedIndex = index),
                              child: Container(
                                decoration: BoxDecoration(
                                  color:
                                      isSelected
                                          ? AppColors.primary
                                          : Colors.white,
                                  border: Border.all(
                                    color:
                                        isSelected
                                            ? Colors.white
                                            : AppColors.primary,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 4,
                                  ),
                                  child: Text(
                                    category[index]['title'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color:
                                          isSelected
                                              ? Colors.white
                                              : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          final news = getFiltered();

                          if (news.isEmpty) {
                            return const Center(child: Text("ไม่พบข้อมูล"));
                          }

                          return ListView.builder(
                            itemCount: news.length,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return Column(
                                  children: [
                                    buildHighlightNews(news.first),
                                    const SizedBox(height: 12),
                                  ],
                                );
                              }
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: AppColors.borderColor,
                                      width: 1,
                                    ),
                                  ),
                                  child: buildNewsItem(news[index]),
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

  Widget buildHighlightNews(Map<String, dynamic> news) {
    return InkWell(
      onTap:
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => NewsDetailPage(news: news)),
          ),
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: NetworkImage(news['imageUrl'] ?? ''), // ✅
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
                news['title'] ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Image.asset('assets/DSD/icon/icon date.png', width: 14),
                  const SizedBox(width: 6),
                  Text(
                    news['docDate'] ?? '',
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNewsItem(Map<String, dynamic> news) {
    return InkWell(
      onTap:
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => NewsDetailPage(news: news)),
          ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                // ✅
                news['imageUrl'] ?? '',
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder:
                    (_, __, ___) =>
                        Container(width: 80, height: 80, color: Colors.grey),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    news['title'] ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Image.asset(
                        'assets/DSD/icon/icon date.png',
                        width: 14,
                        color: AppColors.textgrey,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        news['docDate'] ?? '',
                        style: const TextStyle(
                          color: AppColors.textgrey,
                          fontSize: 10,
                        ),
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
