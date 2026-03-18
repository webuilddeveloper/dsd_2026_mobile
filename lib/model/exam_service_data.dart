class ExamServiceModel {
  final String id;
  final String title;
  final String batch;
  final String organization;
  final String examDate;
  final bool isFull;

  ExamServiceModel({
    required this.id,
    required this.title,
    required this.batch,
    required this.organization,
    required this.examDate,
    required this.isFull,
  });
}

class ExamServiceData {
  static List<ExamServiceModel> getExamList() {
    return [
      ExamServiceModel(
        id: '1',
        title: 'ช่างเชื่อมพื้นฐาน',
        batch: 'รุ่นที่ 4',
        organization: 'สำนักงานพัฒนาฝีมือแรงงานชัยภูมิ',
        examDate: '12/03/2569',
        isFull: true,
      ),
      ExamServiceModel(
        id: '2',
        title: 'ช่างไฟฟ้าภายในอาคาร',
        batch: 'รุ่นที่ 6',
        organization: 'สถาบันพัฒนาฝีมือแรงงาน 27 สมุทรสาคร',
        examDate: '17/03/2569',
        isFull: false,
      ),
      ExamServiceModel(
        id: '3',
        title: 'พนักงานควบคุมเครื่องจักรกลไฟฟ้า',
        batch: 'รุ่นที่ 1',
        organization: 'สถาบันพัฒนาฝีมือแรงงาน 31 สระบุรี',
        examDate: '23/03/2569',
        isFull: false,
      ),
    ];
  }
}
