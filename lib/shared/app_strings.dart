/// ไฟล์นี้เก็บ string ทุกอย่างที่ต้องแปลภาษา
/// เพิ่ม key ใหม่ได้เลย แล้วเรียกผ่าน AppStrings.of(context).key

import 'package:flutter/material.dart';

class AppStrings {
  final String languagePageTitle;
  final String selectLanguage;
  final String languageChangeNote;
  final String languageThai;
  final String languageEnglish;

  // ── เพิ่ม string อื่นๆ ที่ต้องการแปลได้เลย ──
  final String profile;
  final String changePassword;
  final String trainingHistory;
  final String notificationSettings;
  final String aboutUs;

  const AppStrings({
    required this.languagePageTitle,
    required this.selectLanguage,
    required this.languageChangeNote,
    required this.languageThai,
    required this.languageEnglish,
    required this.profile,
    required this.changePassword,
    required this.trainingHistory,
    required this.notificationSettings,
    required this.aboutUs,
  });

  static const AppStrings th = AppStrings(
    languagePageTitle: 'ภาษา',
    selectLanguage: 'เลือกภาษา',
    languageChangeNote: 'การเปลี่ยนภาษาจะมีผลทันทีกับทุกหน้าในแอปพลิเคชัน',
    languageThai: 'ภาษาไทย',
    languageEnglish: 'English',
    profile: 'โปรไฟล์',
    changePassword: 'เปลี่ยนรหัสผ่าน',
    trainingHistory: 'ประวัติการอบรม',
    notificationSettings: 'ตั้งค่าการแจ้งเตือน',
    aboutUs: 'เกี่ยวกับเรา',
  );

  static const AppStrings en = AppStrings(
    languagePageTitle: 'Language',
    selectLanguage: 'Select Language',
    languageChangeNote:
        'Language change takes effect immediately across the app.',
    languageThai: 'ภาษาไทย',
    languageEnglish: 'English',
    profile: 'Profile',
    changePassword: 'Change Password',
    trainingHistory: 'Training History',
    notificationSettings: 'Notification Settings',
    aboutUs: 'About Us',
  );

  /// เรียกใช้: AppStrings.of(context).profile
  static AppStrings of(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return locale.languageCode == 'en' ? en : th;
  }
}
