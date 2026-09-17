import 'package:dsd/blank_page/appbar.dart';
import 'package:dsd/blank_page/textfield.dart';
import 'package:dsd/knowledge/knowledge_detail.dart';

import 'package:dsd/knowledge/knowledge_source.dart';
import 'package:dsd/knowledge/knowledge_cover.dart';
import 'package:dsd/shared/app_strings.dart';
import 'package:dsd/shared/locale_provider.dart';
import 'package:dsd/style_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class KnowledgePage extends StatefulWidget {
  const KnowledgePage({super.key, this.source});
  final KnowledgeSource? source;

  @override
  State<KnowledgePage> createState() => _KnowledgePageState();
}

class _KnowledgePageState extends State<KnowledgePage> {
  late final KnowledgeSource _source;
  List<KnowledgeCategory> _categories = [];
  String? _error;
  int _request = 0;
  bool _openingBook = false;
  final TextEditingController knowledgeSearch = TextEditingController();
  int selectedIndex = 0;

  List<Map<String, dynamic>> allknowlege = [];
  List<Map<String, dynamic>> categoryknowlege = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _source = widget.source ?? KnowledgeSource();
    _loadCategories();
  }

  @override
  void dispose() {
    _source.close();
    knowledgeSearch.dispose();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    setState(() {
      isLoading = true;
      _error = null;
    });
    try {
      final categories = await _source.readCategories();
      if (!mounted) return;
      setState(() {
        _categories = categories;
        categoryknowlege =
            categories
                .map((c) => {'title': c.title, 'titleEN': c.titleEN})
                .toList();
      });
      await _loadBooks(0);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
        _error = 'load';
      });
    }
  }

  Future<void> _loadBooks(int index, {bool refresh = false}) async {
    final request = ++_request;
    setState(() {
      selectedIndex = index;
      isLoading = true;
      _error = null;
      allknowlege = [];
    });
    try {
      final books = await _source.readBooks(
        _categories[index],
        refresh: refresh,
      );
      if (!mounted || request != _request) return;
      setState(() {
        allknowlege = books;
        isLoading = false;
      });
    } catch (_) {
      if (!mounted || request != _request) return;
      setState(() {
        isLoading = false;
        _error = 'load';
      });
    }
  }

  Future<void> _openBook(Map<String, dynamic> book) async {
    if (_openingBook) return;
    setState(() => _openingBook = true);
    try {
      final detail = await _source.readDetail(book);
      if (!mounted) return;
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => KnowledgeDetail(code: detail['code'], model: detail),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      final thai = context.read<LocaleProvider>().locale.languageCode == 'th';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            thai
                ? 'โหลดข้อมูลหนังสือไม่สำเร็จ กรุณาลองอีกครั้ง'
                : 'Unable to load book. Please try again.',
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _openingBook = false);
    }
  }

  void goBack() => Navigator.pop(context, false);

  List<Map<String, dynamic>> getFiltered() {
    List<Map<String, dynamic>> knowlege = allknowlege;

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
    final language = AppStrings.of(context);
    final provider = context.watch<LocaleProvider>();
    final selectedCodelanguage = provider.locale.languageCode;
    return Scaffold(
      appBar: appBar(
        title: language.knowledge,
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
              rightBtn: false,
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
                      onTap: () => _loadBooks(index),
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
                          selectedCodelanguage == 'th'
                              ? categoryknowlege[index]['title']
                              : categoryknowlege[index]['titleEN'] ?? '',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight:
                                isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 16),

            if (_openingBook) const LinearProgressIndicator(),
            Expanded(
              child:
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _error != null
                      ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              selectedCodelanguage == 'th'
                                  ? 'โหลดข้อมูลไม่สำเร็จ'
                                  : 'Unable to load books',
                            ),
                            TextButton(
                              onPressed:
                                  () =>
                                      _categories.isEmpty
                                          ? _loadCategories()
                                          : _loadBooks(
                                            selectedIndex,
                                            refresh: true,
                                          ),
                              child: Text(
                                selectedCodelanguage == 'th'
                                    ? 'ลองอีกครั้ง'
                                    : 'Retry',
                              ),
                            ),
                          ],
                        ),
                      )
                      : filteredList.isEmpty
                      ? Center(
                        child: Text(
                          selectedCodelanguage == 'th'
                              ? 'ไม่พบข้อมูล'
                              : 'No books found',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                      : RefreshIndicator(
                        onRefresh:
                            () => _loadBooks(selectedIndex, refresh: true),
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () => _openBook(item),
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
                  child: KnowledgeCover(
                    source: item['imageUrl'] as String? ?? '',
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
