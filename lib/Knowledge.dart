import 'package:dsd/blank_page/appbar.dart';
import 'package:dsd/blank_page/textfield%20.dart';
import 'package:dsd/model/knowledge_data.dart';
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

  final List<String> tabs = [
    'ทั้งหมด',
    'เทคโนโลยียานยนต์',
    'เทคโนโลยีไฟฟ้าและอิเล็กทรอนิกส์',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void goBack() => Navigator.pop(context, false);

  List<KnowledgeData> getFilteredList() {
    List<KnowledgeData> list = knowledgeList;

    if (selectedIndex == 1) {
      list = list.where((e) => e.title.contains('ยานยนต์')).toList();
    } else if (selectedIndex == 2) {
      list =
          list
              .where(
                (e) =>
                    e.title.contains('ไฟฟ้า') ||
                    e.title.contains('อิเล็กทรอนิกส์'),
              )
              .toList();
    }

    if (knowledgeSearch.text.isNotEmpty) {
      final keyword = knowledgeSearch.text.toLowerCase();
      list =
          list.where((e) => e.title.toLowerCase().contains(keyword)).toList();
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = getFilteredList();

    return Scaffold(
      appBar: appBar(
        title: "การกำหนดฝึกอบรม",
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
                children: List.generate(tabs.length, (index) {
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
                          tabs[index],
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

  Widget _buildCard(KnowledgeData item) {
    return GestureDetector(
      onTap: () {
        // TODO: navigate to detail page
        print('------ >>KnowledgeData');
        print(item.title);
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
                  child: Image.asset(
                    item.image,
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
