// ignore_for_file: deprecated_member_use

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
}) {
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
