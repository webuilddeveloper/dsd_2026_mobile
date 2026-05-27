import 'package:dsd/blank_page/appbar.dart';
import 'package:dsd/blank_page/dialog_fail.dart';
import 'package:dsd/menu.dart';
import 'package:dsd/shared/api_provider.dart';
import 'package:dsd/shared/app_strings.dart';
import 'package:dsd/shared/locale_provider.dart';
import 'package:dsd/style_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class Interests extends StatefulWidget {
  const Interests({super.key, required this.isEdit});
  final bool isEdit;

  @override
  State<Interests> createState() => _InterestsState();
}

class _InterestsState extends State<Interests> {
  final storage = FlutterSecureStorage();

  List<dynamic> categories = [];
  List<String> selectedItems = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<void> initData() async {
    await interestsCategory();
    if (widget.isEdit) await readInterest();
  }

  Future<void> interestsCategory() async {
    final data = await postDio('${trainingCategoryApi}read', {
      "skip": 0,
      "limit": 999,
      "permission": "all",
    });
    setState(() => categories = data);
  }

  Future<void> readInterest() async {
    final res = await postDio('${register}readInterest', {
      "profileCode": await storage.read(key: 'profileCode'),
    });

    List data = [];
    if (res is List) {
      data = res;
    } else if (res is Map && res['status'] == 'S') {
      data = res['objectData'] ?? [];
    }

    setState(() {
      selectedItems =
          data
              .where((e) => e['isActive'] == true)
              .map<String>((e) => e['trainingCategory'].toString())
              .toList();
    });
  }

  void toggleItem(String code) {
    setState(() {
      selectedItems.contains(code)
          ? selectedItems.remove(code)
          : selectedItems.add(code);
    });
  }

  List<Map<String, dynamic>> buildTrainingCategory() {
    return categories
        .map(
          (item) => {
            "code": item['code'],
            "isActive": selectedItems.contains(item['code']),
          },
        )
        .toList();
  }

  Future<void> updateInterests() async {
    final language = AppStrings.of(context);
    if (isLoading) return;
    setState(() => isLoading = true);

    try {
      final profileCode = await storage.read(key: 'profileCode') ?? '';
      final profileFirstName =
          await storage.read(key: 'profileFirstName') ?? '';

      final response = await postapi('${register}CraterInterest', {
        "profileCode": profileCode,
        "trainingCategory": buildTrainingCategory(),
        "updateBy": profileFirstName,
      });

      if (response['status'] == 'S') {
        widget.isEdit
            ? showCustomDialog(
              context,
              title: language.successfully,
              description: language.interestSkip,
              cencelable: true,
              onConfirm: () {
                Navigator.pop(context);
              },
            )
            : Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => Menu()),
              (route) => false,
            );
      }
    } catch (e) {
      debugPrint('❌ updateInterests error: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> skipAll() async {
    setState(() => selectedItems.clear());
    await updateInterests();
  }

  @override
  Widget build(BuildContext context) {
    final language = AppStrings.of(context);
    final provider = context.watch<LocaleProvider>();
    final selectedCode = provider.locale.languageCode;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:
          widget.isEdit
              ? appBar(
                title: language.interest,
                rightBtn: false,
                backAction: () => Navigator.pop(context),
              )
              : AppBar(
                backgroundColor: Colors.white,
                title: Column(
                  children: [
                    Text(
                      language.selectinterests,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      language.recommendations,
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: isLoading ? null : skipAll,
                    child: Text(
                      language.skip,
                      style: TextStyle(color: AppColors.textgrey),
                    ),
                  ),
                ],
              ),
      body:
          categories.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: categories.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.8,
                        ),
                    itemBuilder: (context, index) {
                      final item = categories[index];
                      final isSelected = selectedItems.contains(item['code']);

                      return GestureDetector(
                        onTap: () => toggleItem(item['code']),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color:
                                          isSelected
                                              ? AppColors.primarysecond
                                              : Colors.grey.withOpacity(0.25),
                                      width: isSelected ? 2.5 : 1.5,
                                    ),
                                  ),
                                  child: CircleAvatar(
                                    radius: 40,
                                    backgroundImage: NetworkImage(
                                      item['imageUrl'],
                                    ),
                                  ),
                                ),
                                if (isSelected)
                                  Positioned(
                                    bottom: 2,
                                    right: 2,
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.primarysecond,
                                      ),
                                      child: const Icon(
                                        Icons.check,
                                        size: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              selectedCode == "th"
                                  ? item['title']
                                  : item['titleEN'] ?? "-",
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
      bottomNavigationBar: Container(
        height: 100,
        padding: const EdgeInsets.all(24),
        child: InkWell(
          onTap: isLoading ? null : updateInterests,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.primarysecond,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Center(
              child:
                  isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                        widget.isEdit ? language.save : language.next,

                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
            ),
          ),
        ),
      ),
    );
  }
}
