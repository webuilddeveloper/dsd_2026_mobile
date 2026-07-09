// ignore_for_file: deprecated_member_use

import 'package:dsd/blank_page/textfield.dart';
import 'package:dsd/shared/app_strings.dart' show AppStrings;
import 'package:dsd/splash.dart';
import 'package:dsd/style_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

dialogFail(
  BuildContext context, {
  String title = 'การเชื่อมต่อมีปัญหากรุณาลองใหม่อีกครั้ง',
  bool reloadApp = false,
}) {
  return WillPopScope(
    onWillPop: () {
      return Future.value(reloadApp);
    },
    child: Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.white,
      child: CupertinoAlertDialog(
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Sarabun',
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
        ),
        content: Text(" "),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text(
              "ตกลง",
              style: TextStyle(
                fontSize: 13,
                fontFamily: 'Sarabun',
                color: Color(0xFFFF7514),
                fontWeight: FontWeight.normal,
              ),
            ),
            onPressed: () {
              reloadApp
                  ? Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => SplashPage()),
                    (Route<dynamic> route) => false,
                  )
                  : Navigator.pop(context, false);
            },
          ),
        ],
      ),
    ),
  );
}

void showCustomDialog(
  BuildContext context, {
  required String title,
  required String description,
  required VoidCallback onConfirm,
  bool cencelable = false,
}) {
  final language = AppStrings.of(context);
  showDialog(
    context: context,
    barrierDismissible: false, // กดนอกไม่ปิด
    barrierColor: Color(0xffE7C882).withOpacity(0.5),
    builder: (context) {
      return WillPopScope(
        onWillPop: () async => false, // กันกด back
        child: CupertinoAlertDialog(
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'Sarabun',
              color: Colors.black,
            ),
          ),

          content: Text(
            description,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'Sarabun',
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),

          actions: [
            // ❌ ยกเลิก
            CupertinoDialogAction(
              child: Text(
                language.cancel,
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Sarabun',
                  color: Colors.grey,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),

            // ✅ ยืนยัน
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text(
                language.confirm,
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Sarabun',
                  color: AppColors.primary,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                onConfirm();
              },
            ),
          ],
        ),
      );
    },
  );
}

void showDialogFail(
  BuildContext context, {
  required String title,
  required String description,
  required VoidCallback onConfirm,
}) {
  showDialog(
    context: context,
    barrierDismissible: false, // กดนอกไม่ปิด
    // barrierColor: Color(0xffE7C882).withOpacity(0.5),
    builder: (context) {
      return WillPopScope(
        onWillPop: () async => false, // กันกด back
        child: CupertinoAlertDialog(
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'Sarabun',
              color: Colors.black,
            ),
          ),

          content: Text(
            description,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'Sarabun',
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),

          actions: [
            // ❌ ยกเลิก
            CupertinoDialogAction(
              child: const Text(
                "ยกเลิก",
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Sarabun',
                  color: Colors.grey,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),

            // ✅ ยืนยัน
            CupertinoDialogAction(
              isDefaultAction: true,
              child: const Text(
                "ยืนยัน",
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Sarabun',
                  color: AppColors.primary,
                ),
              ),
              onPressed: () {
                onConfirm();
              },
            ),
          ],
        ),
      );
    },
  );
}

void showAddInterestDialog(
  BuildContext context, {
  required TextEditingController controller,
  required VoidCallback onConfirm,
}) {
  final language = AppStrings.of(context);
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.4), // เปลี่ยนจากสีทอง
    builder: (context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: Dialog(
          backgroundColor: Colors.white, // เพิ่มตรงนี้
          surfaceTintColor: Colors.white, // กัน Material3 tint
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'เพิ่มความสนใจ',
                  style: TextStyle(
                    fontFamily: 'Sarabun',
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'ระบุความสนใจที่ต้องการเพิ่ม',
                  style: TextStyle(
                    fontFamily: 'Sarabun',
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),
                buildTextField(
                  controller: controller,
                  hint: 'กรอกความสนใจ',
                  icon: Icons.favorite_border,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          foregroundColor: Colors.grey.shade600,
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          language.cancel,
                          style: const TextStyle(fontFamily: 'Sarabun'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          // final interest = controller.text.trim();
                          // if (interest.isEmpty) return;
                          Navigator.pop(context);
                          // onConfirm();
                        },
                        child: Text(
                          language.confirm,
                          style: const TextStyle(
                            fontFamily: 'Sarabun',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

void showDownloadSuccessDialog(
  BuildContext context, {
  required VoidCallback onSaveFile, // เปลี่ยนชื่อจาก onOpenFile
}) {
  final language = AppStrings.of(context);
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Color(0xffE7C882).withOpacity(0.5),
    builder: (context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: CupertinoAlertDialog(
          title: const Text(
            'ดาวน์โหลดสำเร็จ',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Sarabun',
              color: Colors.black,
            ),
          ),
          content: const Text(
            'บันทึกไฟล์เอกสารลงเครื่องเรียบร้อยแล้ว',
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'Sarabun',
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
          actions: [
            // ปิด
            CupertinoDialogAction(
              child: Text(
                language.cancel,
                style: const TextStyle(
                  fontSize: 13,
                  fontFamily: 'Sarabun',
                  color: Colors.grey,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            // บันทึกเอกสาร
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text(
                'บันทึกเอกสาร',
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Sarabun',
                  color: AppColors.primary,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                onSaveFile();
              },
            ),
          ],
        ),
      );
    },
  );
}
