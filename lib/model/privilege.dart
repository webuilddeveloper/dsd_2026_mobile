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
    title: 'ส่วนลดตรวจสุขภาพเฉพาะทางสายอาชีพ',
    image: 'assets/DSD/imgs/pri01.png',
    bookmark: "5",
    date: "10/03/2569",
    type: 'เอกชน',
    description:
        'ดีลกับโรงพยาบาลเพื่อจัดแพ็กเกจตรวจการได้ยิน (สำหรับช่างเคาะพ่นสี/โรงงาน), ตรวจปอดและทางเดินหายใจ (สำหรับช่างเชื่อม/ช่างก่อสร้าง) หรือตรวจสมรรถภาพกล้ามเนื้อในราคาพิเศษ',
    onTap: () {},
  ),
  PrivilegeItem(
    title: 'ส่วนลดเครื่องมือและอุปกรณ์ช่าง',
    image: 'assets/DSD/imgs/pri02.png',
    bookmark: "3",
    date: "11/03/2569",
    type: 'รัฐ',
    description:
        'จับมือกับร้านฮาร์ดแวร์หรือแบรนด์เครื่องมือชั้นนำ มอบส่วนลด 10-20% สำหรับการซื้อสว่าน เครื่องเจียร หรือเครื่องมือไฟฟ้าส่วนตัว',
    onTap: () {},
  ),
  PrivilegeItem(
    title: 'สวัสดิการชุดยูนิฟอร์มและอุปกรณ์เซฟตี้ฟรี',
    image: 'assets/DSD/imgs/pri03.png',
    bookmark: "3",
    date: "11/03/2569",
    type: 'รัฐ',
    description:
        'แจกเสื้อช็อป กางเกงทำงานที่ทนทาน และรองเท้าคอมแบตเซฟตี้คุณภาพดีปีละ 2 ชุด เพื่อลดภาระค่าใช้จ่ายในการแต่งกาย',
    onTap: () {},
  ),
  PrivilegeItem(
    title: 'ส่วนลดค่าน้ำมันและค่าบำรุงรักษาพาหนะ',
    image: 'assets/DSD/imgs/pri04.png',
    bookmark: "3",
    date: "11/03/2569",
    type: 'รัฐ',
    description:
        'บัตรเติมน้ำมันราคาพิเศษหรือส่วนลดการเปลี่ยนถ่ายน้ำมันเครื่อง/ยางรถยนต์ เพราะช่างส่วนใหญ่ต้องใช้รถส่วนตัวเดินทางไปหน้างาน',
    onTap: () {},
  ),
  PrivilegeItem(
    title: 'เงินสนับสนุนการสอบใบเซอร์ (Certification Subsidy)',
    image: 'assets/DSD/imgs/p2.png',
    bookmark: "3",
    date: "11/03/2569",
    type: 'รัฐ',
    description:
        'ช่วยจ่ายค่าธรรมเนียมหรือส่วนลดค่าอบรมในการสอบใบอนุญาตประกอบวิชาชีพ (เช่น ช่างไฟฟ้าในอาคาร) เพื่ออัปเกรดค่าตัว',
    onTap: () {},
  ),
  PrivilegeItem(
    title: 'ประกันอุบัติเหตุกลุ่มวงเงินสูง',
    image: 'assets/DSD/imgs/p2.png',
    bookmark: "3",
    date: "11/03/2569",
    type: 'รัฐ',
    description:
        'สวัสดิการคุ้มครองค่ารักษาพยาบาลจากอุบัติเหตุจากการทำงาน รวมถึงเงินชดเชยรายวันกรณีต้องหยุดงานเพื่อรักษาตัว',
    onTap: () {},
  ),
  PrivilegeItem(
    title: 'ส่วนลดซื้ออะไหล่และวัสดุอุปกรณ์',
    image: 'assets/DSD/imgs/p2.png',
    bookmark: "3",
    date: "11/03/2569",
    type: 'รัฐ',
    description:
        'สิทธิในการซื้อวัสดุก่อสร้าง อะไหล่แอร์ หรืออุปกรณ์ไฟฟ้าในราคาส่ง (Wholesale Price) สำหรับนำไปใช้รับงานส่วนตัวหรือซ่อมแซมบ้านตัวเอง',
    onTap: () {},
  ),
  PrivilegeItem(
    title: 'เงินกู้ยืมสวัสดิการดอกเบี้ยต่ำ',
    image: 'assets/DSD/imgs/p2.png',
    bookmark: "3",
    date: "11/03/2569",
    type: 'รัฐ',
    description:
        'ระบบเงินกู้ฉุกเฉินสำหรับช่างที่มีความจำเป็นต้องใช้เงินด่วน เพื่อป้องกันการไปกู้หนี้นอกระบบที่ดอกเบี้ยสูง',
    onTap: () {},
  ),
  PrivilegeItem(
    title: 'โบนัสตามผลงานและไร้อุบัติเหตุ (Safety & Quality Bonus)',
    image: 'assets/DSD/imgs/p2.png',
    bookmark: "3",
    date: "11/03/2569",
    type: 'รัฐ',
    description:
        'เงินพิเศษรายเดือนหรือรายโปรเจกต์ หากทำงานได้ตามเป้าหมายโดยไม่มีงานตีกลับ (Defect) และไม่มีอุบัติเหตุเกิดขึ้นในหน้างาน',
    onTap: () {},
  ),
  PrivilegeItem(
    title: 'ส่วนลดค่าที่พักและเบี้ยเลี้ยงกรณีไปต่างจังหวัด',
    image: 'assets/DSD/imgs/p2.png',
    bookmark: "3",
    date: "11/03/2569",
    type: 'รัฐ',
    description:
        'กรณีต้องไปคุมงานไกลๆ ควรมีสวัสดิการส่วนลดโรงแรมพาร์ทเนอร์ หรือค่าเบี้ยเลี้ยงรายวันที่ครอบคลุมค่ากินอยู่ได้จริง',
    onTap: () {},
  ),
];
