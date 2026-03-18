class Calendar {
  final String title;
  final String date; // เช่น 2026-03-02
  final String time;
  final String image;
  final String description; // 👈 เพิ่มตรงนี้

  Calendar({
    required this.title,
    required this.date,
    required this.time,
    required this.image,
    required this.description, // 👈 เพิ่ม
  });
}

final List<Calendar> calendarList = [
  Calendar(
    title: 'สถาบันพัฒนาบุคลากรในอุตสาหกรรม',
    date: '2026-03-02',
    time: '12:30 น.',
    image: 'assets/DSD/imgs/new1.jpg',
    description:
        'จัดกิจกรรมพัฒนาทักษะแรงงานในภาคอุตสาหกรรม เพื่อเพิ่มขีดความสามารถและรองรับตลาดแรงงานในอนาคต',
  ),
  Calendar(
    title: 'อบรมช่างไฟฟ้ามืออาชีพ',
    date: '2026-03-02',
    time: '09:00 น.',
    image: 'assets/DSD/imgs/new2.jpg',
    description:
        'หลักสูตรฝึกอบรมช่างไฟฟ้ามืออาชีพ เน้นทั้งภาคทฤษฎีและปฏิบัติ เพื่อให้สามารถทำงานได้จริง',
  ),
];
