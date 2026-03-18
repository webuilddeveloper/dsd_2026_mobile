class NewsData {
  final String title;
  final String date;
  final String shareCount;
  final String Bookmarked;
  final String image;
  final String type;
  final String description; // 👈 เพิ่มตรงนี้

  NewsData({
    required this.title,
    required this.date,
    required this.shareCount,
    required this.Bookmarked,
    required this.image,
    required this.type,
    required this.description, // 👈 เพิ่มตรงนี้
  });
}

/* type 
 1 = ประชาสัมพันธ์
 2 = ข่าวฝึกอบรม
 3 =  ข่าวมาตรฐานฝีมือแรงงาน 
 */
final List<NewsData> newsList = [
  // 🔵 type 1 = ประชาสัมพันธ์
  NewsData(
    title: 'ตรีนุช” เดินหน้าสร้างอาชีพเพื่อคนไทยมีงานทำ มอบชุดเครื่องมือทำกิน',
    date: '12/03/2569',
    shareCount: "9",
    Bookmarked: "7",
    image: 'assets/DSD/imgs/new3.jpg',
    type: "1",
    description:
        'กระทรวงแรงงานเดินหน้าสนับสนุนอาชีพให้ประชาชน โดยมอบชุดเครื่องมือทำกินเพื่อสร้างรายได้อย่างยั่งยืน',
  ),
  NewsData(
    title: 'กรมพัฒนาฝีมือแรงงานจัดงานแนะแนวอาชีพทั่วประเทศ',
    date: '13/03/2569',
    shareCount: "5",
    Bookmarked: "2",
    image: 'assets/DSD/imgs/new1.jpg',
    type: "1",
    description:
        'จัดกิจกรรมแนะแนวอาชีพเพื่อให้ประชาชนและเยาวชนได้ค้นหาทักษะและสายงานที่เหมาะสมกับตนเอง',
  ),

  // 🟡 type 2 = ข่าวฝึกอบรม
  NewsData(
    title: 'WorldSkills Thailand เปิดรับสมัครเยาวชนไทยแข่งขันฝีมือแรงงาน',
    date: '10/03/2569',
    shareCount: "12",
    Bookmarked: "5",
    image: 'assets/DSD/imgs/new1.jpg',
    type: '2',
    description:
        'เปิดโอกาสให้เยาวชนไทยเข้าร่วมแข่งขันฝีมือแรงงานระดับประเทศ เพื่อพัฒนาทักษะสู่เวทีสากล',
  ),
  NewsData(
    title: 'เปิดอบรมหลักสูตรช่างไฟฟ้ามืออาชีพ รุ่นใหม่',
    date: '14/03/2569',
    shareCount: "8",
    Bookmarked: "3",
    image: 'assets/DSD/imgs/new2.jpg',
    type: '2',
    description:
        'หลักสูตรฝึกอบรมช่างไฟฟ้ารุ่นใหม่ เน้นการใช้งานจริงและมาตรฐานความปลอดภัยระดับสากล',
  ),

  // 🔴 type 3 = ข่าวมาตรฐานฝีมือแรงงาน
  NewsData(
    title: 'แรงงานยกระดับทักษะนวดไทยในญี่ปุ่น สู่ระดับสากล',
    date: '11/03/2569',
    shareCount: "10",
    Bookmarked: "6",
    image: 'assets/DSD/imgs/new2.jpg',
    type: '3',
    description:
        'พัฒนาทักษะนวดไทยให้แรงงานไทยในต่างประเทศ ยกระดับมาตรฐานให้เป็นที่ยอมรับในระดับสากล',
  ),
  NewsData(
    title: 'ทดสอบมาตรฐานฝีมือแรงงาน สาขาช่างเชื่อมระดับ 1',
    date: '15/03/2569',
    shareCount: "7",
    Bookmarked: "4",
    image: 'assets/DSD/imgs/new3.jpg',
    type: '3',
    description:
        'จัดทดสอบมาตรฐานฝีมือแรงงานในสาขาช่างเชื่อม เพื่อรับรองความสามารถและเพิ่มโอกาสในการทำงาน',
  ),
];
