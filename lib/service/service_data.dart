import 'package:dsd/blank_page/dialog_fail.dart';
import 'package:dsd/calendar/calendar_page.dart';
import 'package:dsd/certification.dart';
import 'package:dsd/knowledge/Knowledge.dart';
import 'package:dsd/login.dart';
import 'package:dsd/profile/edit_user_information.dart';
import 'package:dsd/shared/app_strings.dart';
import 'package:dsd/skilledLabor/skill.dart';
import 'package:dsd/privilege/privilege_all.dart';
import 'package:dsd/skilledLabor/skill_2.dart';
import 'package:dsd/training/training.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ServiceItem {
  final String title;
  final String image;
  final Function(BuildContext, Function(int)?) onTap;

  ServiceItem({required this.title, required this.image, required this.onTap});
}

Future<void> handleAuthNavigation(BuildContext context, Widget page) async {
  final storage = FlutterSecureStorage();
  final profileCode = await storage.read(key: 'profileCode');
  final idcard = await storage.read(key: 'idcard');

  // if (profileCode == null || profileCode.isEmpty) {
  //   Navigator.push(context, MaterialPageRoute(builder: (_) => LoginPage()));
  // } else if (idcard == null || idcard.isEmpty) {
  //   showCustomDialog(
  //     context,
  //     title: 'กรุณากรอกข้อมูล',
  //     description:
  //         "คุณยังไม่ได้กรอกเลขบัตรประชาชน กรุณาอัพเดตข้อมูลเพื่อใช้งานฟังก์ชันนี้",
  //     onConfirm: () {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (_) => EditUserInformationPage()),
  //       );
  //     },
  //   );
  // } else {
  Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  // }
}

List<ServiceItem> services(BuildContext context) {
  final language = AppStrings.of(context);

  return [
    ServiceItem(
      title: language.trainingapp,
      image: 'assets/DSD/imgs/2.png',
      onTap: (context, onTabChange) async {
        await handleAuthNavigation(context, TrainingService());
        // await handleAuthNavigation(context, Skill1Page());
      },
    ),

    ServiceItem(
      title: language.standtest,
      image: 'assets/DSD/imgs/1.png',
      onTap: (context, onTabChange) async {
        await handleAuthNavigation(context, SkillPage());
      },
    ),

    ServiceItem(
      title: language.certifiedTitle,
      image: 'assets/DSD/imgs/3.png',
      onTap: (context, onTabChange) {
        Navigator.push(context, MaterialPageRoute(builder: (_) => Cert()));
      },
    ),

    ServiceItem(
      title: language.calendar,
      image: 'assets/DSD/imgs/4.png',
      onTap: (context, onTabChange) {
        if (Navigator.canPop(context)) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (_) => CalendarPage(
                    onTabChange: onTabChange,
                    pushedFromPage: true,
                  ),
            ),
          );
        } else {
          onTabChange?.call(1);
        }
      },
    ),

    ServiceItem(
      title: language.knowledge,
      image: 'assets/DSD/imgs/5.png',
      onTap: (context, onTabChange) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => KnowledgePage()),
        );
      },
    ),

    ServiceItem(
      title: language.privilege,
      image: 'assets/DSD/imgs/6.png',
      onTap: (context, onTabChange) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => PrivilegeAll()),
        );
      },
    ),
  ];
}
