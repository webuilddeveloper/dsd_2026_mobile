import 'package:dsd/blank_page/dialog_fail.dart';
import 'package:dsd/certification.dart';
import 'package:dsd/knowledge/Knowledge.dart';
import 'package:dsd/calendar/calendar_page.dart';
import 'package:dsd/login.dart';
import 'package:dsd/profile/edit_user_information.dart';
import 'package:dsd/skilledLabor/skill.dart';
import 'package:dsd/privilege/privilege_all.dart';
import 'package:dsd/training/training.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ServiceItem {
  final String title;
  final String image;
  final Function(BuildContext) onTap;

  ServiceItem({required this.title, required this.image, required this.onTap});
}

Future<void> handleAuthNavigation(BuildContext context, Widget page) async {
  final storage = FlutterSecureStorage();
  final profileCode = await storage.read(key: 'profileCode');
  final idcard = await storage.read(key: 'idcard');
  print(profileCode);
  print(idcard);

  if (profileCode == null || profileCode.isEmpty) {
    // ส่งไปหน้า LoginPage และไม่ push page อื่นซ้อน
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
    );
  } else if (idcard == null || idcard.isEmpty) {
    // ส่งไปหน้าแก้ไขข้อมูล ถ้ามี profileCode แต่ idcard ว่าง
    showCustomDialog(
      context,
      title: 'กรุณากรอกข้อมูล',
      description:
          "คุณยังไม่ได้กรอกเลขบัตรประชาชน กรุณาอัพเดตข้อมูลเพื่อใช้งานฟังก์ชันนี้",
      onConfirm: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => EditUserInformationPage()),
        );
      },
    );
  } else {
    // ปกติ มี profileCode และ idcard
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => page));
  }
}

final List<ServiceItem> services = [
  ServiceItem(
    title: 'สมัครสอบมาตรฐาน\nที่นั่งทางวิชาชีพ',
    image: 'assets/DSD/imgs/1.png',
    onTap: (context) async {
      await handleAuthNavigation(context, SkillPage());
    },
  ),
  ServiceItem(
    title: 'สมัครฝึกอบรม',
    image: 'assets/DSD/imgs/2.png',
    onTap: (context) async {
      await handleAuthNavigation(context, TrainingService());
    },
  ),
  ServiceItem(
    title: 'สมัครรับรองความรู้\nตามมาตรฐาน',
    image: 'assets/DSD/imgs/3.png',
    onTap: (context) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Cert()));
    },
  ),

  ServiceItem(
    title: 'ปฏิทินกิจกรรม',
    image: 'assets/DSD/imgs/4.png',
    onTap: (context) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CalendarPage(pushedFromPage: true), // ✅
        ),
      );
    },
  ),
  ServiceItem(
    title: 'คลังความรู้',
    image: 'assets/DSD/imgs/5.png',
    onTap: (context) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => KnowledgePage()),
      );
    },
  ),
  ServiceItem(
    title: 'สิทธิประโยชน์',
    image: 'assets/DSD/imgs/6.png',
    onTap: (context) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PrivilegeAll()),
      );
    },
  ),
];
