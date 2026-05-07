import 'package:dsd/blank_page/appbar.dart';

import 'package:dsd/shared/app_strings.dart'; // ← เพิ่ม
import 'package:dsd/shared/locale_provider.dart';
import 'package:dsd/style_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});

  static const _languages = [
    _LangOption(code: 'th', flag: '🇹🇭', name: 'ภาษาไทย', subtitle: 'Thai'),
    _LangOption(code: 'en', flag: '🇬🇧', name: 'English', subtitle: 'อังกฤษ'),
  ];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LocaleProvider>();
    final selectedCode = provider.locale.languageCode;
    final s = AppStrings.of(context); // ← ดึง strings ตาม locale

    return Scaffold(
      backgroundColor: AppColors.backgroundMain,
      appBar: appBar(
        title: s.languagePageTitle, // ← ใช้ AppStrings
        backBtn: true,
        rightBtn: false,
        backAction: () => Navigator.pop(context),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
        children: [
          // ── Language list card ──
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 16,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        s.selectLanguage, // ← ใช้ AppStrings
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Kanit',
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                ),
                ..._languages.map((lang) {
                  final isSelected = lang.code == selectedCode;
                  return _buildLanguageRow(
                    context: context,
                    lang: lang,
                    isSelected: isSelected,
                    onTap: () {
                      context.read<LocaleProvider>().setLocale(
                        Locale(lang.code),
                      );
                    },
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // ── Info note ──
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  size: 16,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    s.languageChangeNote, // ← ใช้ AppStrings
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'Kanit',
                      color: AppColors.textgrey,
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageRow({
    required BuildContext context,
    required _LangOption lang,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        const Divider(height: 1, color: AppColors.backgroundMain),
        InkWell(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            color: isSelected ? const Color(0xFFFAEEDA) : Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                // Flag icon
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? const Color(0xFFFAC775)
                            : AppColors.backgroundMain,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      lang.flag,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Name + subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lang.name,
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Kanit',
                          fontWeight:
                              isSelected ? FontWeight.w500 : FontWeight.normal,
                          color:
                              isSelected
                                  ? const Color(0xFF412402)
                                  : AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        lang.subtitle,
                        style: TextStyle(
                          fontSize: 11,
                          fontFamily: 'Kanit',
                          color:
                              isSelected
                                  ? const Color(0xFF854F0B)
                                  : AppColors.textgrey,
                        ),
                      ),
                    ],
                  ),
                ),

                // Radio indicator
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color:
                          isSelected
                              ? AppColors.primary
                              : const Color(0xFFD3D1C7),
                      width: isSelected ? 2 : 1.5,
                    ),
                  ),
                  child:
                      isSelected
                          ? Center(
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primary,
                              ),
                            ),
                          )
                          : null,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _LangOption {
  final String code;
  final String flag;
  final String name;
  final String subtitle;

  const _LangOption({
    required this.code,
    required this.flag,
    required this.name,
    required this.subtitle,
  });
}
