class TrainingModel {
  final String id;
  final String title;
  final String batch;
  final String organization;
  final DateTime startDate;
  final DateTime endDate;
  final String duration;
  final bool isFull;

  TrainingModel({
    required this.id,
    required this.title,
    required this.batch,
    required this.organization,
    required this.startDate,
    required this.endDate,
    required this.duration,
    required this.isFull,
  });
}

class TrainingDataService {
  static List<TrainingModel> getTraList() {
    return [
      TrainingModel(
        id: '1',
        title: 'การวิเคราะห์ข้อมูลด้วย Excel และ Power BI',
        batch: 'ปกติ',
        organization: 'สถาบันพัฒนาฝีมือแรงงาน 15 พระนครศรีอยุธยา',
        startDate: DateTime(2026, 4, 1),
        endDate: DateTime(2026, 4, 5),
        isFull: true,
        duration: '30',
      ),
      TrainingModel(
        id: '2',
        title: 'การวิเคราะห์ข้อมูลด้วย Excel และ Power BI',
        batch: 'ปกติ',
        organization: 'สถาบันพัฒนาฝีมือแรงงาน 15 พระนครศรีอยุธยา',
        startDate: DateTime(2026, 4, 10),
        endDate: DateTime(2026, 4, 15),
        isFull: false,
        duration: '30',
      ),
    ];
  }
}
