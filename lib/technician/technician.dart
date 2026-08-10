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
      "site": "กองบริหารทรัพยากรบุคคล",
      "certificates": [
        {
          "course": "ช่างไฟฟ้าภายในอาคาร ระดับ 1",
          "certificateNo": "06-000541/2569",
          "certificateDate": "2025-12-22T02:02:38Z",
          "site": "กองบริหารทรัพยากรบุคคล",
          "pathCer": null,
        },
        {
          "course": "ช่างไฟฟ้าภายในอาคาร ระดับ 2",
          "certificateNo": "06-000389/2568",
          "certificateDate": "2024-06-10T09:00:00Z",
          "site": "สำนักงานพัฒนาฝีมือแรงงาน กรุงเทพมหานคร",
          "pathCer": null,
        },
        {
          "course": "ช่างเดินสายไฟฟ้าแรงสูง",
          "certificateNo": "06-000102/2567",
          "certificateDate": "2023-02-18T09:00:00Z",
          "site": "สำนักงานพัฒนาฝีมือแรงงาน นนทบุรี",
          "pathCer": null,
        },
      ],
    },
    {
      "personalId": "3309900005678",
      "names": "นางสาวสมหญิง บุญมาก",
      "site": "สำนักงานพัฒนาฝีมือแรงงาน เชียงใหม่",
      "certificates": [
        {
          "course": "ช่างเครื่องปรับอากาศในบ้านและการพาณิชย์ขนาดเล็ก",
          "certificateNo": "07-000101/2569",
          "certificateDate": "2025-10-01T09:00:00Z",
          "site": "สำนักงานพัฒนาฝีมือแรงงาน เชียงใหม่",
          "pathCer": null,
        },
        {
          "course": "ช่างซ่อมเครื่องทำความเย็นขนาดเล็ก",
          "certificateNo": "07-000455/2567",
          "certificateDate": "2024-01-25T09:00:00Z",
          "site": "สำนักงานพัฒนาฝีมือแรงงาน เชียงใหม่",
          "pathCer": null,
        },
      ],
    },
    {
      "personalId": "1101200001234",
      "names": "นายสมชาย ใจดี",
      "course": "ช่างไฟฟ้าภายในอาคาร ระดับ 2",
      "certificates": [
        {
          "course": "ช่างเครื่องปรับอากาศในบ้านและการพาณิชย์ขนาดเล็ก",
          "certificateNo": "07-000101/2569",
          "certificateDate": "2025-10-01T09:00:00Z",
          "site": "สำนักงานพัฒนาฝีมือแรงงาน เชียงใหม่",
          "pathCer": null,
        },
      ],
    },
  ];

  List<Map<String, dynamic>> _filteredTechnicians = [];

  @override
  void initState() {
    super.initState();
    _filteredTechnicians = List.from(technicians);
    _searchController.addListener(_searchTechnician);
  }

  // ── ดึงลิสต์ใบเซอร์ + fallback (ตรงกับ logic ของหน้า detail) ──
  List<Map<String, dynamic>> _certsOf(Map<String, dynamic> item) {
    final raw = item["certificates"];

    if (raw is List) {
      return raw
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }

    if (item["course"] != null || item["certificateNo"] != null) {
      return [
        {
          "course": item["course"],
          "certificateNo": item["certificateNo"],
          "certificateDate": item["certificateDate"],
          "site": item["site"],
          "pathCer": item["pathCer"],
        },
      ];
    }

    return [];
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
            final matchTop =
                (item["names"] ?? "").toString().toLowerCase().contains(
                  keyword,
                ) ||
                (item["site"] ?? "").toString().toLowerCase().contains(
                  keyword,
                ) ||
                (item["personalId"] ?? "").toString().contains(keyword);

            if (matchTop) return true;

            // ── เช็คทุกใบเซอร์ของช่างคนนี้ (รวม fallback) ──
            final certs = _certsOf(item);
            return certs.any((cert) {
              return (cert["course"] ?? "").toString().toLowerCase().contains(
                    keyword,
                  ) ||
                  (cert["certificateNo"] ?? "")
                      .toString()
                      .toLowerCase()
                      .contains(keyword) ||
                  (cert["site"] ?? "").toString().toLowerCase().contains(
                    keyword,
                  );
            });
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
    final certCount = _certsOf(item).length;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TechnicianDetailPage(technician: item),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Avatar
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(9.0),
                    child: Image.asset(
                      'assets/DSD/icon/icon_user.png',
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // ── ข้อมูลสำคัญเท่านั้น ──
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item["names"] ?? "-",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.5,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "เลขบัตร: ${item["personalId"] ?? "-"}",
                        style: TextStyle(
                          fontSize: 11.5,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item["site"] ?? "-",
                        style: TextStyle(
                          fontSize: 11.5,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // ── badge จำนวนใบเซอร์ ──
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.workspace_premium_outlined,
                        size: 13,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "$certCount ใบ",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),

                const Icon(
                  Icons.chevron_right,
                  color: AppColors.primary,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
