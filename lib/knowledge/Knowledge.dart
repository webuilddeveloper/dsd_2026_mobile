import 'package:dsd/blank_page/appbar.dart';
import 'package:dsd/blank_page/textfield.dart';
import 'package:dsd/knowledge/knowledge_detail.dart';

import 'package:dsd/shared/api_provider.dart';
import 'package:dsd/style_theme.dart';
import 'package:flutter/material.dart';

class KnowledgePage extends StatefulWidget {
  const KnowledgePage({super.key});

  @override
  State<KnowledgePage> createState() => _KnowledgePageState();
}

class _KnowledgePageState extends State<KnowledgePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final TextEditingController knowledgeSearch = TextEditingController();
  int selectedIndex = 0;

  List<Map<String, dynamic>> allknowlege = [];
  List<Map<String, dynamic>> categoryknowlege = [];
  bool isLoading = true;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    _knowledgeApi();
    _knowledgeCategoryApi();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /*===============================>> API <<=============================== */
  Future<void> _knowledgeApi() async {
    final data = await postDio('${knowledgeApi}read', {'limit': 10});
    setState(() {
      allknowlege = (data as List).cast<Map<String, dynamic>>();
      isLoading = false;
    });
  }

  Future<void> _knowledgeCategoryApi() async {
    final data = await postDio('${knowledgeCategoryApi}read', {'limit': 10});
    setState(() {
      // ✅ เพิ่ม "ทั้งหมด" ไว้ตัวแรกเสมอ
      categoryknowlege = [
        {'code': '', 'title': 'ทั้งหมด'},
        ...(data as List).cast<Map<String, dynamic>>(),
      ];
      isLoading = false;
    });
  }
  /*===============================>> API <<=============================== */

  void goBack() => Navigator.pop(context, false);

  List<Map<String, dynamic>> getFiltered() {
    List<Map<String, dynamic>> knowlege = allknowlege;

    // ✅ filter ตาม category code
    if (selectedIndex != 0) {
      final selectedCode = categoryknowlege[selectedIndex]['code'];
      knowlege = knowlege.where((e) => e['category'] == selectedCode).toList();
      print(selectedCode);
    }

    // 🔍 filter จาก search
    if (knowledgeSearch.text.isNotEmpty) {
      final keyword = knowledgeSearch.text.toLowerCase();
      knowlege =
          knowlege
              .where((e) => (e['title'] ?? '').toLowerCase().contains(keyword))
              .toList();
    }

    return knowlege;
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = getFiltered();

    return Scaffold(
      appBar: appBar(
        title: "คลังความรู้",
        rightBtn: false,
        backBtn: true,
        backAction: () => goBack(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔍 Search
            buildSearch(
              hintText: "Search",
              controller: knowledgeSearch,
              rightBtn: true,
              onFilterTap: () {},
              onChanged: (value) => setState(() {}),
            ),
            const SizedBox(height: 16),

            // 🏷️ Tab chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(categoryknowlege.length, (index) {
                  final isSelected = selectedIndex == index;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => setState(() => selectedIndex = index),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : Colors.white,
                          border: Border.all(
                            color:
                                isSelected
                                    ? AppColors.primary
                                    : AppColors.primary,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        child: Text(
                          categoryknowlege[index]['title'],
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight:
                                isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                            color:
                                isSelected ? Colors.white : AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 16),

            // 📚 Grid
            // Expanded(
            //   child:
            //       filteredList.isEmpty
            //           ? const Center(
            //             child: Text(
            //               'ไม่พบข้อมูล',
            //               style: TextStyle(color: Colors.grey),
            //             ),
            //           )
            //           : GridView.builder(
            //             itemCount: filteredList.length,
            //             gridDelegate:
            //                 const SliverGridDelegateWithFixedCrossAxisCount(
            //                   crossAxisCount: 2,
            //                   crossAxisSpacing: 12,
            //                   mainAxisSpacing: 12,
            //                   childAspectRatio: 0.68,
            //                 ),
            //             itemBuilder: (context, index) {
            //               return _buildCard(filteredList[index]);
            //             },
            //           ),
            // ),
            Expanded(
              child:
                  filteredList.isEmpty
                      ? const Center(
                        child: Text(
                          'ไม่พบข้อมูล',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                      : ListView.builder(
                        itemCount: (filteredList.length / 2).ceil() * 2 - 1,
                        itemBuilder: (context, index) {
                          // index คี่ = เส้นคั่น
                          if (index.isOdd) {
                            return Image.asset(
                              'assets/DSD/imgs/bord.png',
                              width: double.infinity,
                              fit: BoxFit.fitWidth,
                            );
                          }

                          // index คู่ = row of 2 cards
                          final rowIndex = index ~/ 2;
                          final firstIndex = rowIndex * 2;
                          final secondIndex = firstIndex + 1;

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                Expanded(
                                  child: _buildCard(filteredList[firstIndex]),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child:
                                      secondIndex < filteredList.length
                                          ? _buildCard(
                                            filteredList[secondIndex],
                                          )
                                          : const SizedBox(),
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

  Widget _buildCard(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => KnowledgeDetail(code: item['code'], model: item),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.borderColor, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🖼️ รูปปก พร้อม padding รอบข้าง
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: AspectRatio(
                  aspectRatio: 0.68, // สัดส่วนหนังสือ portrait
                  child: Image.network(
                    item['imageUrl'],
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) => Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: Icon(
                              Icons.image_not_supported,
                              color: Colors.grey,
                              size: 40,
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
    );
  }
}
