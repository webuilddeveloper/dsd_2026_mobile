import 'package:dsd/blank_page/appbar.dart';
import 'package:dsd/blank_page/format.dart';
import 'package:dsd/blank_page/textfield.dart';
import 'package:dsd/privilege/privilege_detail.dart';
import 'package:dsd/shared/api_provider.dart';
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

  bool isLoading = true;
  List<Map<String, dynamic>> privilegesAll = [];
  List<Map<String, dynamic>> category = [];

  @override
  void initState() {
    super.initState();
    _privilegeApi();
    _privilegeCategoryApi();
  }

  /*===============================>> API <<=============================== */
  Future<void> _privilegeApi() async {
    final data = await postDio('${privilegeApi}read', {'limit': 10});
    setState(() {
      privilegesAll = (data as List).cast<Map<String, dynamic>>();
      isLoading = false;
    });
  }

  Future<void> _privilegeCategoryApi() async {
    final data = await postDio('${privilegeCategoryApi}read', {'limit': 10});
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

  // 🔥 controller ต้องอยู่นอก build
  final TextEditingController privilegeSearch = TextEditingController();

  int selectedIndex = 0;

  List<Map<String, dynamic>> getFilteredList() {
    List<Map<String, dynamic>> privilegeslist = privilegesAll;
    if (selectedIndex != 0) {
      final selectedCode = category[selectedIndex]['code'];
      privilegeslist =
          privilegeslist.where((e) => e['category'] == selectedCode).toList();
    }
    if (privilegeSearch.text.isNotEmpty) {
      final keyword = privilegeSearch.text.toLowerCase();

      privilegeslist =
          privilegeslist
              .where((e) => e['title'].toLowerCase().contains(keyword))
              .toList();
    }

    return privilegeslist;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        title: "สิทธิประโยชน์ ",
        rightBtn: false,
        backBtn: true,
        backAction: () => goBack(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(category.length, (index) {
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
                            category[index]['title'],
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
                itemCount: getFilteredList().length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                itemBuilder: (context, index) {
                  final item = getFilteredList()[index];
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
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                            child: Image.network(
                              item['imageUrl'] ?? '',
                              height: 120,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (_, __, ___) => Container(
                                    height: 120,
                                    color: Colors.grey[200],
                                  ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['title'] ?? '',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 6),

                                item['dateStart'] != null &&
                                        item['dateStart'] != '' &&
                                        item['dateStart'] != 'Invalid date'
                                    ? Row(
                                      children: [
                                        Image.asset(
                                          'assets/DSD/icon/icon date.png',
                                          width: 14,
                                          color: AppColors.borderColor,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          formatDate(item['dateStart']),
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
