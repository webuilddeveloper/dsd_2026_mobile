import 'package:dsd/blank_page/appbar.dart';
import 'package:dsd/blank_page/textfield.dart';
import 'package:dsd/style_theme.dart';
import 'package:dsd/technician/technician_detail.dart';
import 'package:flutter/material.dart';

class TechnicianPage extends StatefulWidget {
  const TechnicianPage({super.key});

  @override
  State<TechnicianPage> createState() => _TechnicianPageState();
}

class _TechnicianPageState extends State<TechnicianPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> technicians = [
    {
      "personalId": "4700800001962",
      "names": "นายสุวัฒน์ เจริญพิบูลย์",
      "course": "ช่างไฟฟ้าภายในอาคาร ระดับ 1",
      "certificateNo": "06-000541/2569",
      "certificateDate": "2025-12-22T02:02:38Z",
      "site": "กองบริหารทรัพยากรบุคคล",

      "pathCer": null,
    },
    {
      "personalId": "1101200001234",
      "names": "นายสมชาย ใจดี",
      "course": "ช่างไฟฟ้าภายในอาคาร ระดับ 2",
      "certificateNo": "06-000542/2569",
      "certificateDate": "2025-11-10T09:00:00Z",
      "site": "สำนักงานพัฒนาฝีมือแรงงาน กรุงเทพมหานคร",

      "pathCer": null,
    },
    {
      "personalId": "3309900005678",
      "names": "นางสาวสมหญิง บุญมาก",
      "course": "ช่างเครื่องปรับอากาศในบ้านและการพาณิชย์ขนาดเล็ก",
      "certificateNo": "07-000101/2569",
      "certificateDate": "2025-10-01T09:00:00Z",
      "site": "สำนักงานพัฒนาฝีมือแรงงาน เชียงใหม่",

      "pathCer": null,
    },
    {
      "personalId": "4102300011111",
      "names": "นายอนันต์ พัฒนา",
      "course": "ช่างเชื่อมไฟฟ้า",
      "certificateNo": "08-000321/2569",
      "certificateDate": "2025-09-15T09:00:00Z",
      "site": "สำนักงานพัฒนาฝีมือแรงงาน ชลบุรี",

      "pathCer": null,
    },
    {
      "personalId": "5204400022222",
      "names": "นายกิตติชัย สุขใจ",
      "course": "ช่างซ่อมรถยนต์",
      "certificateNo": "09-000555/2569",
      "certificateDate": "2025-08-20T09:00:00Z",
      "site": "สำนักงานพัฒนาฝีมือแรงงาน ขอนแก่น",

      "pathCer": null,
    },
    {
      "personalId": "8306600033333",
      "names": "นายธนพล ดีพร้อม",
      "course": "ช่างซ่อมรถจักรยานยนต์",
      "certificateNo": "10-000121/2569",
      "certificateDate": "2025-07-12T09:00:00Z",
      "site": "สำนักงานพัฒนาฝีมือแรงงาน ภูเก็ต",

      "pathCer": null,
    },
    {
      "personalId": "2407700044444",
      "names": "นางสาวพิชญา ศรีสุข",
      "course": "ช่างเดินระบบประปา",
      "certificateNo": "11-000888/2569",
      "certificateDate": "2025-06-30T09:00:00Z",
      "site": "สำนักงานพัฒนาฝีมือแรงงาน ระยอง",

      "pathCer": null,
    },
    {
      "personalId": "3608800055555",
      "names": "นายวรชัย มั่นคง",
      "course": "ช่างก่ออิฐ ฉาบปูน",
      "certificateNo": "12-000412/2569",
      "certificateDate": "2025-05-22T09:00:00Z",
      "site": "สำนักงานพัฒนาฝีมือแรงงาน นครราชสีมา",

      "pathCer": null,
    },
    {
      "personalId": "9201100066666",
      "names": "นายภาคิน รุ่งเรือง",
      "course": "ช่างติดตั้งระบบโซลาร์เซลล์",
      "certificateNo": "13-000201/2569",
      "certificateDate": "2025-04-18T09:00:00Z",
      "site": "สำนักงานพัฒนาฝีมือแรงงาน สงขลา",

      "pathCer": null,
    },
    {
      "personalId": "1509900077777",
      "names": "นางสาวศิริพร แสงทอง",
      "course": "ช่างซ่อมเครื่องใช้ไฟฟ้าภายในบ้าน",
      "certificateNo": "14-000654/2569",
      "certificateDate": "2025-03-10T09:00:00Z",
      "site": "สำนักงานพัฒนาฝีมือแรงงาน พระนครศรีอยุธยา",

      "pathCer": null,
    },
  ];

  List<Map<String, dynamic>> _filteredTechnicians = [];

  @override
  void initState() {
    super.initState();

    _filteredTechnicians = List.from(technicians);

    _searchController.addListener(_searchTechnician);
  }

  void _searchTechnician() {
    final keyword = _searchController.text.trim().toLowerCase();

    setState(() {
      if (keyword.isEmpty) {
        _filteredTechnicians = List.from(technicians);
        return;
      }

      _filteredTechnicians =
          technicians.where((item) {
            return (item["names"] ?? "").toString().toLowerCase().contains(
                  keyword,
                ) ||
                (item["course"] ?? "").toString().toLowerCase().contains(
                  keyword,
                ) ||
                (item["certificateNo"] ?? "").toString().toLowerCase().contains(
                  keyword,
                ) ||
                (item["site"] ?? "").toString().toLowerCase().contains(
                  keyword,
                ) ||
                (item["personalId"] ?? "").toString().contains(keyword);
          }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundMain,
      appBar: appBar(
        title: 'ค้นหาช่างที่ได้รับการรับรอง',
        rightBtn: false,
        backAction: () => Navigator.pop(context),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildSearch(
              controller: _searchController,
              hintText: "ค้นหาชื่อ เลขรับรอง จังหวัด...",
              onChanged: (value) {
                _searchTechnician();
              },
            ),
            const SizedBox(height: 16),

            const SizedBox(height: 12),

            Expanded(
              child:
                  _filteredTechnicians.isEmpty
                      ? const Center(child: Text("ไม่พบข้อมูลช่าง"))
                      : ListView.builder(
                        itemCount: _filteredTechnicians.length,
                        itemBuilder: (context, index) {
                          return _buildTechnicianCard(
                            _filteredTechnicians[index],
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTechnicianCard(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          // onTap: () {
          //   // TODO: ไปหน้ารายละเอียดช่าง
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => TechnicianDetailPage(technician: item),
          //     ),
          //   );
          // },
          onTap: () {
            showGeneralDialog(
              context: context,
              barrierDismissible: true,
              barrierLabel: '',
              barrierColor: Colors.black45,
              transitionDuration: const Duration(milliseconds: 250),
              pageBuilder: (_, __, ___) {
                return Center(child: TechnicianDetailDialog(technician: item));
              },
              transitionBuilder: (_, animation, __, child) {
                return FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(
                    scale: Tween<double>(begin: .92, end: 1).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutCubic,
                      ),
                    ),
                    child: child,
                  ),
                );
              },
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/DSD/icon/icon_user.png',
                      width: 28,
                      height: 28,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                // ข้อมูล
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ชื่อ + แท็กประเภท
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item["names"] ?? "-",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundMain,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          item["course"] ?? "-",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      _buildInfoRow(
                        Icons.badge_outlined,
                        "เลขรับรอง",
                        item["certificateNo"],
                      ),
                      const SizedBox(height: 4),
                      _buildInfoRow(
                        Icons.business_outlined,
                        "หน่วยงาน",
                        item["site"],
                      ),
                      const SizedBox(height: 4),
                      // _buildInfoRow(
                      //   Icons.location_on_outlined,
                      //   "จังหวัด",
                      //   item["province"],
                      // ),
                    ],
                  ),
                ),

                const Icon(
                  Icons.chevron_right,
                  color: AppColors.primary,
                  size: 28,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, dynamic value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 15, color: Colors.grey.shade500),
        const SizedBox(width: 6),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "$label : ",
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
                TextSpan(
                  text: "${value ?? "-"}",
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
