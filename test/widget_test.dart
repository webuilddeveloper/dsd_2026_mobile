import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dsd/blank_page/textfield.dart';

void main() {
  group('Widget Unit Tests', () {
    testWidgets('ตรวจสอบการทำงานของ buildTextField', (WidgetTester tester) async {
      // สร้าง Controller จำลอง
      final controller = TextEditingController();

      // เรนเดอร์ Widget ที่ต้องการทดสอบ
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: buildTextField(
            key: const Key('test_field'),
            controller: controller,
            hint: 'กรอกข้อมูล',
            icon: Icons.person,
          ),
        ),
      ));

      // 1. ตรวจสอบว่ามีช่องกรอกข้อมูลโผล่ขึ้นมาบนจอ
      final textField = find.byKey(const Key('test_field'));
      expect(textField, findsOneWidget);

      // 2. ลองพิมพ์ข้อความลงไป แล้วเช็คว่า Controller รับค่าถูกต้องไหม
      await tester.enterText(textField, 'Hello DSD');
      expect(controller.text, 'Hello DSD');
    });
  });
}
