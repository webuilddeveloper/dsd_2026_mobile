import 'dart:ui';

class PrivilegeItem {
  final String title;
  final String image;
  final String bookmark;
  final String date;
  final String type;
  final String description; // 👈 เพิ่มตรงนี้
  final VoidCallback onTap;

  PrivilegeItem({
    required this.title,
    required this.image,
    required this.bookmark,
    required this.date,
    required this.type,
    required this.description, // 👈 เพิ่มตรงนี้
    required this.onTap,
  });
}

final List<PrivilegeItem> privileges = [
  PrivilegeItem(
    title: 'น้ำชงและท็อปปิง ลด 30 บาท',
    image: 'assets/DSD/imgs/p1.jpg',
    bookmark: "5",
    date: "10/03/2569",
    type: 'เอกชน',
    description:
        'รับส่วนลดทันที 30 บาท สำหรับเมนูน้ำชงและท็อปปิงที่ร่วมรายการ เมื่อแสดงสิทธิ์ก่อนชำระเงิน',
    onTap: () {},
  ),
  PrivilegeItem(
    title: 'จัดเต็มยกเซต เพียง 199 บาท',
    image: 'assets/DSD/imgs/p2.png',
    bookmark: "3",
    date: "11/03/2569",
    type: 'รัฐ',
    description:
        'โปรโมชั่นพิเศษจากหน่วยงานภาครัฐ จัดเซตอาหารสุดคุ้มในราคาเพียง 199 บาท สำหรับผู้ถือสิทธิ์',
    onTap: () {},
  ),
];
