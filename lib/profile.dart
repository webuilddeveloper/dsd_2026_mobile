import 'package:dsd/blank_page/appbar.dart';

import 'package:dsd/style_theme.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final Function(int)? onTabChange;

  const ProfilePage({super.key, required this.onTabChange});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void goBack() {
    widget.onTabChange?.call(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundMain,
      appBar: appBar(
        title: "โปรไฟล์",
        backBtn: true,
        rightBtn: false,
        backAction: () => goBack(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: MediaQuery.of(context).size.height * 0.12,
            bottom: MediaQuery.of(context).size.height * 0.15,
          ),
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none, // ให้วงกลมล้นออกมาได้
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 90,
                        bottom: 30,
                        left: 16,
                        right: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'ออกแบบ ทดลอง',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.edit,
                                  size: 25,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'บัญชีของฉัน',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 16),
                          _rowtxt(title: 'บัญชีผู้ใช้งาน', ontap: () {}),
                          SizedBox(height: 16),
                          _rowtxt(title: 'ใบอนุญาติ', ontap: () {}),
                          SizedBox(height: 8),
                          const Divider(color: AppColors.backgroundMain),
                          SizedBox(height: 8),
                          _rowtxt(title: 'เปลี่ยนรหัสผ่าน', ontap: () {}),
                          SizedBox(height: 32),
                          Text(
                            'กิจกรรมของคุณ',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 16),
                          _rowtxt(title: 'การถูกใจ', ontap: () {}),
                          SizedBox(height: 8),
                          const Divider(color: AppColors.backgroundMain),
                          SizedBox(height: 8),
                          _rowtxt(title: 'ประวัติการอบรม', ontap: () {}),
                          SizedBox(height: 8),
                          const Divider(color: AppColors.backgroundMain),
                          SizedBox(height: 8),
                          SizedBox(height: 32),
                          Text(
                            'ตั้งค่า',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 16),
                          _rowtxt(title: 'ตั้งค่าการแจ้งเตือน', ontap: () {}),
                          SizedBox(height: 8),
                          const Divider(color: AppColors.backgroundMain),
                          SizedBox(height: 8),
                          _rowtxt(
                            title: 'เปลี่ยนภาษา /  Language',
                            ontap: () {},
                          ),

                          SizedBox(height: 8),
                          const Divider(color: AppColors.backgroundMain),
                          SizedBox(height: 8),
                          _rowtxt(title: 'เกี่ยวกับเรา', ontap: () {}),
                          SizedBox(height: 8),
                          const Divider(color: AppColors.backgroundMain),
                          SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),

                  // รูปโปรไฟล์
                  Positioned(
                    top: -70,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            height: 140,
                            width: 140,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(75),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/DSD/imgs/profile.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          // ปุ่มกล้อง (ผูกกับมุมล่างขวาของรูป)
                          Positioned(
                            bottom: 0, // ลอยออกมานิดนึง (ดูมีมิติ)
                            right: 0,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  // TODO: ใส่ action เปิดกล้อง
                                },
                                borderRadius: BorderRadius.circular(30),
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.15),
                                        blurRadius: 6,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Image.asset(
                                      'assets/DSD/icon/icons_camera.png',
                                      width: 20,
                                      height: 20,
                                      fit: BoxFit.contain, // ✅ ไม่บีบภาพ
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary, width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: EdgeInsetsGeometry.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  child: Text(
                    'ออกจากระบบ',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InkWell _rowtxt({required String title, required VoidCallback ontap}) {
    return InkWell(
      onTap: () => ontap(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
          ),
          Icon(Icons.arrow_forward_ios, color: AppColors.primary),
        ],
      ),
    );
  }
}
