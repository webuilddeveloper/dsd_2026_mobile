class KnowledgeData {
  final String title;
  final String date;
  final String time;
  final String image;
  final String description;

  KnowledgeData({
    required this.title,
    required this.date,
    required this.time,
    required this.image,
    required this.description,
  });
}

// ====== Dummy Data ======
final List<KnowledgeData> knowledgeList = [
  KnowledgeData(
    title: 'สถาบันพัฒนาบุคลากรในอุตสาหกรรม',
    date: '2026-03-02',
    time: '12:30 น.',
    image: 'assets/DSD/imgs/new1.jpg',
    description: 'จัดกิจกรรมพัฒนาทักษะแรงงานในภาคอุตสาหกรรม',
  ),
  KnowledgeData(
    title: 'อบรมช่างไฟฟ้ามืออาชีพ',
    date: '2026-03-02',
    time: '09:00 น.',
    image: 'assets/DSD/imgs/new2.jpg',
    description: 'หลักสูตรฝึกอบรมช่างไฟฟ้ามืออาชีพ',
  ),
  KnowledgeData(
    title: 'เทคโนโลยียานยนต์สมัยใหม่',
    date: '2026-03-05',
    time: '10:00 น.',
    image: 'assets/DSD/imgs/new3.jpg',
    description: 'อบรมเทคโนโลยียานยนต์ไฟฟ้า EV สำหรับช่างผู้เชี่ยวชาญ',
  ),
  KnowledgeData(
    title: 'ช่างอิเล็กทรอนิกส์อุตสาหกรรม',
    date: '2026-03-10',
    time: '13:00 น.',
    image: 'assets/DSD/imgs/new4.jpg',
    description: 'ฝึกอบรมวงจรอิเล็กทรอนิกส์และระบบควบคุมอุตสาหกรรม',
  ),
];
