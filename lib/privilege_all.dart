import 'package:dsd/blank_page/appbar.dart';
import 'package:dsd/blank_page/textfield%20.dart';
import 'package:dsd/model/privilege.dart';
import 'package:dsd/privilege_detail.dart';
import 'package:dsd/style_theme.dart';
import 'package:flutter/material.dart';

class PrivilegeAll extends StatefulWidget {
  const PrivilegeAll({super.key});

  @override
  State<PrivilegeAll> createState() => _PrivilegeAllState();
}

class _PrivilegeAllState extends State<PrivilegeAll> {
  void goBack() {
    Navigator.pop(context);
  }

  // 🔥 controller ต้องอยู่นอก build
  final TextEditingController privilegeSearch = TextEditingController();

  int selectedIndex = 0;

  final List<String> tabs = [
    'ทั้งหมด',
    'จากหน่วยงานภาครัฐ',
    'จากหน่วยงานภาคเอกชน',
  ];

  // 🔥 filter logic
  List<PrivilegeItem> getFilteredList() {
    List<PrivilegeItem> list = privileges;

    if (selectedIndex == 1) {
      list = list.where((e) => e.type == 'รัฐ').toList();
    } else if (selectedIndex == 2) {
      list = list.where((e) => e.type == 'เอกชน').toList();
    }

    // 🔥 filter ตาม search (ใช้แบบ ignore case)
    if (privilegeSearch.text.isNotEmpty) {
      final keyword = privilegeSearch.text.toLowerCase();

      list =
          list.where((e) => e.title.toLowerCase().contains(keyword)).toList();
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    final list = getFilteredList();

    return Scaffold(
      appBar: appBar(
        title: "สิทธิประโยชน์",
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
              controller: privilegeSearch,
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

            const SizedBox(height: 12),

            Expanded(
              child: GridView.builder(
                itemCount: list.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 👈 2 ช่อง
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.95, // 👈 ปรับความสูง/กว้าง
                ),
                itemBuilder: (context, index) {
                  final item = list[index];

                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => PrivilegeDetail(privilege: item),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 🔥 รูป
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                            child: Image.asset(
                              item.image,
                              height: 120,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),

                          // 🔥 เนื้อหา
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),

                                const SizedBox(height: 6),

                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/DSD/icon/icon date.png',
                                          width: 14,
                                          color: AppColors.borderColor,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          item.date,
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
                                          item.bookmark,
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
                        ],
                      ),
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
}
