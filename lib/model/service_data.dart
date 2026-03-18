import 'package:dsd/Knowledge.dart';
import 'package:dsd/exam_service.dart';
import 'package:dsd/privilege_all.dart';
import 'package:dsd/training_service.dart';
import 'package:flutter/material.dart';

class ServiceItem {
  final String title;
  final String image;
  final Function(BuildContext) onTap; // 👈 เปลี่ยนตรงนี้

  ServiceItem({required this.title, required this.image, required this.onTap});
}

Function(int) globalOnTabChange = (index) {};

final List<ServiceItem> services = [
  ServiceItem(
    title: 'สมัครสอบมาตรฐาน\nที่นั่งทางวิชาชีพ',
    image: 'assets/DSD/imgs/1.png',
    onTap: (context) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ExamService()),
      );
    },
  ),
  ServiceItem(
    title: 'สมัครฝึกอบรม',
    image: 'assets/DSD/imgs/2.png',
    onTap: (context) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TrainingService()),
      );
    },
  ),
  ServiceItem(
    title: 'สมัครรับรองความรู้\nตามมาตรฐาน',
    image: 'assets/DSD/imgs/3.png',
    onTap: (context) {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => PrivilegeAll()),
      // );
    },
  ),
  ServiceItem(
    title: 'ปฏิทินกิจกรรม',
    image: 'assets/DSD/imgs/4.png',
    onTap: (context) {
      globalOnTabChange(1);
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
