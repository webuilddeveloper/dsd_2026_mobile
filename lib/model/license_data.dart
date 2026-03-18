class LicenseData {
  final String title;
  final String issueDate;
  final String branch;
  final String status;

  LicenseData({
    required this.title,
    required this.issueDate,
    required this.branch,
    required this.status,
  });
}

final List<LicenseData> licenseList = [
  LicenseData(
    title: 'ช่างไฟฟ้าภายในอาคาร ระดับ 2',
    issueDate: '11/01/2564',
    branch: 'สาขาอาชีพช่างไฟฟ้า อิเล็กทรอนิกส์และคอมพิวเตอร์',
    status: 'ผ่าน',
  ),
  LicenseData(
    title: 'ช่างสีตกแต่ง',
    issueDate: '21/06/2565',
    branch: 'สาขาอาชีพช่างไฟฟ้า อิเล็กทรอนิกส์และคอมพิวเตอร์',
    status: 'ผ่าน',
  ),
  LicenseData(
    title: 'ช่างเครื่องทำความเย็นในบ้านและการพาณิชย์',
    issueDate: '01/09/2565',
    branch: 'สาขาอาชีพช่างไฟฟ้า อิเล็กทรอนิกส์และคอมพิวเตอร์',
    status: 'ผ่าน',
  ),
];
