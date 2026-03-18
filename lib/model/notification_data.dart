class NotificationModel {
  final String id;
  final String title;
  final String description;
  final String image;
  final String date;
  bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.date,
    this.isRead = false,
  });
}

List<NotificationModel> notifications = [
  NotificationModel(
    id: '1',
    title: 'ข่าวประชาสัมพันธ์',
    description:
        'ช่างไฟฟ้าต้องมีใบอนุญาต... ไม่ขึ้นชั้นอาชีพรอง เสี่ยงปรับสูงสุด',
    image: 'assets/DSD/imgs/noti1.jpg',
    date: '25/02/2026',
    isRead: false,
  ),
  NotificationModel(
    id: '2',
    title: 'ข่าวประชาสัมพันธ์',
    description: 'กรมพัฒนาฝีมือแรงงานยกระดับช่างแอร์มืออาชีพ...',
    image: 'assets/DSD/imgs/noti2.jpg',
    date: '19/02/2026',
    isRead: true,
  ),
  NotificationModel(
    id: '3',
    title: 'ข่าวประชาสัมพันธ์',
    description: 'กรมพัฒนาฝีมือแรงงาน จับมือ บริษัท พัฒนา...',
    image: 'assets/DSD/imgs/noti3.jpg',
    date: '18/02/2026',
    isRead: false,
  ),
  NotificationModel(
    id: '4',
    title: 'ข่าวประชาสัมพันธ์',
    description:
        'ช่างไฟฟ้าต้องมีใบอนุญาต... ไม่ขึ้นชั้นอาชีพรอง เสี่ยงปรับสูงสุด',
    image: 'assets/DSD/imgs/noti1.jpg',
    date: '25/02/2026',
    isRead: false,
  ),
];
