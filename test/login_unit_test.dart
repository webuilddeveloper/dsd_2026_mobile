import 'package:flutter_test/flutter_test.dart';

// ---------------------------------------------------------
// 1. นี่คือ Logic ที่ควรถูกแยกออกมาจากหน้า UI (เช่นนำไปไว้ใน AuthService หรือ Validator)
// ---------------------------------------------------------
String? validateLoginInput(String username, String password) {
  if (username.isEmpty) {
    return 'กรุณากรอกชื่อผู้ใช้';
  }
  if (password.isEmpty) {
    return 'กรุณากรอกรหัสผ่าน';
  }
  return null; // ข้อมูลถูกต้อง
}

// ---------------------------------------------------------
// 2. ส่วนนี้คือการเขียน Unit Test
// ---------------------------------------------------------
void main() {
  group('Login Validation Unit Tests', () {
    
    test('ต้องคืนค่าข้อผิดพลาด "กรุณากรอกชื่อผู้ใช้" ถ้าไม่กรอก Username', () {
      final result = validateLoginInput('', 'password123');
      expect(result, 'กรุณากรอกชื่อผู้ใช้');
    });

    test('ต้องคืนค่าข้อผิดพลาด "กรุณากรอกรหัสผ่าน" ถ้าไม่กรอก Password', () {
      final result = validateLoginInput('myUser', '');
      expect(result, 'กรุณากรอกรหัสผ่าน');
    });

    test('ต้องคืนค่า null (ผ่าน) ถ้ากรอกข้อมูลครบถ้วน', () {
      final result = validateLoginInput('myUser', 'password123');
      expect(result, isNull);
    });
    
  });
}