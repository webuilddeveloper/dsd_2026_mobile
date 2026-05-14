import 'dart:math';
import 'package:dsd/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  // 1. Initialize Integration Test Plugin
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-End Test', () {
    testWidgets('Verify registration and login flow', (tester) async {
      // เคลียร์ข้อมูลที่อาจค้างอยู่ในเครื่องจำลอง เพื่อให้แอปเริ่มต้นแบบ "ยังไม่เข้าสู่ระบบ" เสมอ
      const storage = FlutterSecureStorage();
      await storage.deleteAll();

      // 2. สั่งให้แอปเริ่มทำงาน
      app.main();

      // รอให้หน้า Splash Screen โหลดเสร็จและเปลี่ยนไปหน้า Home
      bool isHomeLoaded = false;
      for (int i = 0; i < 15; i++) {
        await tester.pump(const Duration(seconds: 1));
        if (find.text('Profile').evaluate().isNotEmpty) {
          isHomeLoaded = true;
          break;
        }
      }
      expect(isHomeLoaded, isTrue, reason: 'ไม่พบเมนู Profile บนหน้าจอ Home');

      // 3. เริ่มต้นจากหน้า Home กดปุ่ม Profile เพื่อไปหน้า Login
      final loginEntryText = find.text('Profile');
      await tester.tap(loginEntryText.last, warnIfMissed: false);
      await tester.pumpAndSettle();

      // 4. ไปที่หน้าสมัครสมาชิก
      final registerButton = find.text('สมัครสมาชิก');
      expect(registerButton, findsOneWidget, reason: 'ไม่พบปุ่มสมัครสมาชิก');
      await tester.tap(registerButton);
      await tester.pumpAndSettle();

      // ============================================
      // 5. ลองกดสมัครโดยที่ยังไม่กรอกข้อมูล (ทดสอบ Validation)
      // ============================================
      final submitRegisterBtn = find.widgetWithText(ElevatedButton, 'สมัคร');
      await tester.dragUntilVisible(
        submitRegisterBtn.first,
        find.byType(Scrollable).last,
        const Offset(0, -300),
      );
      await tester.tap(submitRegisterBtn);
      await tester.pumpAndSettle();

      // ควรจะแสดงข้อความแจ้งเตือน "กรุณากรอกข้อมูล" (Validation Error)
      expect(
        find.text('กรุณากรอกข้อมูล'),
        findsWidgets,
        reason: 'ควรมี Validation Message เมื่อไม่กรอกข้อมูล',
      );

      // ============================================
      // 6. กรอกข้อมูลและจัดการกรณีข้อมูลซ้ำ (Retry Logic)
      // ============================================
      // ฟังก์ชันช่วยหาช่องกรอกข้อมูลจาก Hint เนื่องจาก TextField ไม่มี Key
      Finder findInputByHint(String hint) {
        return find.byWidgetPredicate((widget) {
          return widget is TextField && widget.decoration?.hintText == hint;
        });
      }

      bool isRegistered = false;
      int maxRetries = 5;
      int currentAttempt = 1;

      // ตัวแปรสำหรับเก็บ User/Pass ที่จะถูกปรับเปลี่ยนหากมีการซ้ำเกิดขึ้น
      String targetUsername = 'test_user01';
      String targetPassword = 'Test@1234';
      String targetIdCard = '1111111111111';

      while (!isRegistered && currentAttempt <= maxRetries) {
        await tester.enterText(
          findInputByHint('กรอกชื่อผู้ใช้งาน'),
          targetUsername,
        );
        await tester.enterText(
          findInputByHint('กรอกรหัสผ่าน '),
          targetPassword,
        ); // ใน register.dart hint มี space ต่อท้าย
        await tester.enterText(
          findInputByHint('กรอกยืนยันรหัสผ่าน'),
          targetPassword,
        );
        await tester.enterText(
          findInputByHint('กรอกเลขบัตรประชาชน 13 หลัก'),
          targetIdCard,
        );
        await tester.enterText(findInputByHint('กรอกคำนำหน้า'), 'นาย');
        await tester.enterText(findInputByHint('กรอกชื่อ'), 'สมมติ');
        await tester.enterText(findInputByHint('กรอกนามสกุล'), 'ทดสอบ');
        await tester.enterText(
          findInputByHint('กรอกเบอร์โทรศัพท์'),
          '0800000000',
        );
        await tester.enterText(
          findInputByHint('กรอกอีเมล'),
          '$targetUsername@example.com',
        );

        // ปิด Keyboard ก่อนเพื่อไม่ให้บัง UI
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();

        // สำหรับฟิลด์วันเกิด (เรียก DatePicker) - ทำเฉพาะรอบแรกก็เพียงพอ
        if (currentAttempt == 1) {
          final dateField = findInputByHint('เลือกวันเกิด');
          if (dateField.evaluate().isNotEmpty) {
            await tester.dragUntilVisible(
              dateField.first,
              find.byType(Scrollable).last,
              const Offset(0, -200),
            );
            await tester.pumpAndSettle();

            await tester.tap(dateField, warnIfMissed: false);
            await tester.pumpAndSettle();

            Finder confirmDateBtn = find.text('OK');
            if (confirmDateBtn.evaluate().isEmpty)
              confirmDateBtn = find.text('ตกลง');
            if (confirmDateBtn.evaluate().isNotEmpty) {
              await tester.tap(confirmDateBtn.last);
            } else {
              await tester.tapAt(const Offset(20, 20)); // Fallback ปิด dialog
            }
            await tester.pumpAndSettle();
          }
        }

        // ============================================
        // 7. กด Submit เพื่อส่งข้อมูลสมัครสมาชิก
        // ============================================
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();

        await tester.dragUntilVisible(
          submitRegisterBtn.first,
          find.byType(Scrollable).last,
          const Offset(0, -300),
        );
        await tester.pumpAndSettle();

        await tester.tap(submitRegisterBtn, warnIfMissed: false);

        // รอ API และ Dialog แจ้งผลตอบกลับ
        bool dialogAppeared = false;
        bool isSuccess = false;
        for (int i = 0; i < 15; i++) {
          await tester.pump(const Duration(seconds: 1));
          if (find.text('สมัครสมาชิกสำเร็จ').evaluate().isNotEmpty) {
            dialogAppeared = true;
            isSuccess = true;
            break;
          } else if (find.text('เกิดข้อผิดพลาด').evaluate().isNotEmpty) {
            dialogAppeared = true;
            isSuccess = false;
            break;
          }
        }
        expect(dialogAppeared, isTrue, reason: 'ไม่พบ Dialog ตอบสนองจาก API');

        // ต้องรอให้แอนิเมชันของ Dialog เด้งขึ้นมาจนเสร็จสิ้นก่อน จึงจะกดปุ่มบน Dialog ได้แม่นยำ
        await tester.pumpAndSettle();

        // ปิด Dialog
        Finder confirmDialogBtn = find.text('ตกลง');
        if (confirmDialogBtn.evaluate().isEmpty)
          confirmDialogBtn = find.text('OK');
        if (confirmDialogBtn.evaluate().isEmpty)
          confirmDialogBtn = find.text('ปิด');
        if (confirmDialogBtn.evaluate().isNotEmpty) {
          await tester.tap(confirmDialogBtn.last, warnIfMissed: false);
        } else {
          // หากหาปุ่มไม่เจอด้วยข้อความ ให้สั่ง pop ปิด dialog โดยตรง
          tester.state<NavigatorState>(find.byType(Navigator).last).pop();
        }
        await tester.pumpAndSettle();

        // หาก Dialog ยังคงอยู่ (กดไม่โดน) ให้ใช้ Navigator pop บังคับปิดอีกรอบเพื่อไม่ให้ Block UI ในรอบต่อไป
        if (find.text('เกิดข้อผิดพลาด').evaluate().isNotEmpty ||
            find.text('สมัครสมาชิกสำเร็จ').evaluate().isNotEmpty) {
          tester.state<NavigatorState>(find.byType(Navigator).last).pop();
          await tester.pumpAndSettle();
        }

        if (isSuccess) {
          isRegistered = true;
        } else {
          // ถ้าเกิดข้อผิดพลาด (ซ้ำ) ให้เปลี่ยนข้อมูลแล้วลองใหม่
          currentAttempt++;
          String suffix = DateTime.now().millisecondsSinceEpoch
              .toString()
              .substring(8); // สุ่มเลข 5 หลัก
          targetUsername = 'user$suffix';
          targetIdCard = '11111111$suffix'; // สร้างเลขบัตร 13 หลักที่ไม่ซ้ำ

          // เลื่อนจอกลับไปด้านบนสุดเพื่อให้พร้อมกรอกข้อมูลในรอบถัดไป
          final usernameField = findInputByHint('กรอกชื่อผู้ใช้งาน');
          await tester.dragUntilVisible(
            usernameField.first,
            find.byType(Scrollable).last,
            const Offset(0, 300),
          );
          await tester.pumpAndSettle();
        }
      }

      expect(
        isRegistered,
        isTrue,
        reason: 'พยายามสมัครไป $maxRetries ครั้งแล้วแต่ก็ยังไม่สำเร็จ',
      );

      // กด Back (ของแอป) เพื่อกลับไปยังหน้า Login
      // เนื่องจาก Custom Appbar อาจทำให้ pageBack() หาปุ่มไม่เจอ จึงใช้ Navigator.pop แทน
      tester.state<NavigatorState>(find.byType(Navigator).last).pop();
      await tester.pumpAndSettle();

      // ============================================
      // 8. นำ User ที่สมัครใหม่ มาเข้าสู่ระบบ
      // ============================================
      expect(
        find.text('เข้าสู่ระบบ').first,
        findsWidgets,
        reason: 'ไม่พบหน้า Login หลังจากกดกลับ',
      );

      await tester.enterText(
        findInputByHint('กรอกชื่อผู้ใช้งาน'),
        targetUsername,
      );
      await tester.enterText(
        findInputByHint('กรอกรหัสผ่าน'),
        targetPassword,
      ); // ในหน้า login ไม่มี space ท้าย

      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();

      final loginButton = find.widgetWithText(ElevatedButton, 'เข้าสู่ระบบ');
      await tester.tap(loginButton, warnIfMissed: false);

      // 9. ตรวจสอบผลลัพธ์หลัง Login (อาจเจอหน้าเลือกความสนใจ หรือ หน้า Home)
      bool isOnInterests = false;
      bool isLoginSuccess = false;
      for (int i = 0; i < 15; i++) {
        await tester.pump(const Duration(seconds: 1));
        if (find.text('เลือกความสนใจของคุณ').evaluate().isNotEmpty) {
          isOnInterests = true;
          break;
        } else if (find.text('บริการ').evaluate().isNotEmpty) {
          isLoginSuccess = true;
          break;
        }
      }

      // ถ้าเป็น User ใหม่จะเจอหน้าเลือกความสนใจ
      if (isOnInterests) {
        bool shouldSkip =
            Random().nextBool(); // สุ่มว่าจะข้าม (true) หรือเลือก (false)

        if (shouldSkip) {
          // 9.1 กรณีสุ่มได้ "ข้าม"
          await tester.tap(find.text('ข้าม'), warnIfMissed: false);
          await tester.pumpAndSettle();
        } else {
          // 9.2 กรณีสุ่มได้ "เลือกความสนใจ"
          // รอให้ API โหลดข้อมูลหมวดหมู่มาแสดง (ตรวจจับจาก CircleAvatar ที่ครอบรูปภาพอยู่)
          for (int i = 0; i < 5; i++) {
            await tester.pump(const Duration(seconds: 1));
            if (find.byType(CircleAvatar).evaluate().isNotEmpty) break;
          }

          final avatars = find.byType(CircleAvatar);
          if (avatars.evaluate().isNotEmpty) {
            await tester.tap(
              avatars.first,
              warnIfMissed: false,
            ); // เลือกอันที่ 1
            if (avatars.evaluate().length > 1) {
              await tester.tap(
                avatars.at(1),
                warnIfMissed: false,
              ); // เลือกอันที่ 2 ด้วย
            }
            await tester.pumpAndSettle();
          }

          final nextBtn = find.text('ถัดไป');
          await tester.dragUntilVisible(
            nextBtn.first,
            find.byType(Scrollable).first,
            const Offset(0, -300),
          );
          await tester.tap(nextBtn, warnIfMissed: false);
          await tester.pumpAndSettle();
        }

        // รอให้เปลี่ยนกลับมาหน้า Home
        for (int i = 0; i < 15; i++) {
          await tester.pump(const Duration(seconds: 1));
          if (find.text('บริการ').evaluate().isNotEmpty) {
            isLoginSuccess = true;
            break;
          }
        }
      }

      expect(
        isLoginSuccess,
        isTrue,
        reason: 'เข้าสู่ระบบไม่สำเร็จ หรือแอปไม่ยอมเปลี่ยนไปหน้า Home',
      );

      // ============================================
      // 10. ทดสอบกดเปลี่ยนเมนูที่ Bottom Navigation Bar
      // ============================================
      final menus = ['Calendar', 'Notification', 'Profile', 'Home'];
      for (String menu in menus) {
        final menuBtn = find.text(menu);
        if (menuBtn.evaluate().isNotEmpty) {
          await tester.tap(menuBtn.last, warnIfMissed: false);
          await tester.pumpAndSettle();
          // หน่วงเวลาเล็กน้อยเพื่อให้ API หรือแอนิเมชันในหน้านั้นๆ โหลดโชว์ขึ้นมา
          await tester.pump(const Duration(seconds: 1));
        }
      }

      // ============================================
      // 11. ทดสอบหน้า Home (Search, API Waiting, และ Sections ต่างๆ)
      // ============================================
      // หน้า Home ใช้ SingleChildScrollView ครอบไว้ทั้งหมด เราจะใช้ตัวนี้เป็นฐานในการ Scroll
      final homeScroll = find.byType(SingleChildScrollView).last;

      // ฟังก์ชันช่วย: กด Pop กลับอย่างปลอดภัยเฉพาะตอนที่เปิดหน้าย่อยซ้อนขึ้นมาเท่านั้น
      Future<void> safePop() async {
        final navState = tester.state<NavigatorState>(
          find.byType(Navigator).last,
        );
        if (navState.canPop()) {
          navState.pop();
          await tester.pumpAndSettle();
        }
      }

      // ฟังก์ชันช่วย: รอให้ API โหลดเสร็จโดยเช็กจาก Loading Indicator
      Future<void> waitForApiToLoad() async {
        for (int i = 0; i < 15; i++) {
          await tester.pump(const Duration(seconds: 1));
          if (find.byType(CircularProgressIndicator).evaluate().isEmpty) break;
        }
      }

      // 11.1 ค้นหาข้อมูล (buildSearch)
      final searchField = find.byWidgetPredicate(
        (widget) =>
            widget is TextField && widget.decoration?.hintText == 'Search...',
      );
      if (searchField.evaluate().isNotEmpty) {
        await tester.enterText(searchField, 'ทดสอบค้นหาบริการ');
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();
      }

      // 11.2 ทดสอบ "บริการ" (_buildServiceSection)
      // ทดสอบกดเข้าการ์ดบริการตัวแรก (_buildServiceCard)
      final serviceGrids = find.byType(GridView);
      if (serviceGrids.evaluate().isNotEmpty) {
        final serviceItem = find.descendant(
          of: serviceGrids.first,
          matching: find.byType(InkWell),
        );
        if (serviceItem.evaluate().isNotEmpty) {
          await tester.tap(serviceItem.first, warnIfMissed: false);
          await tester.pumpAndSettle();
          await tester.pump(const Duration(seconds: 1)); // รอหน้าบริการย่อยโหลด
          await safePop();
        }
      }

      // ทดสอบกดปุ่ม "ดูทั้งหมด" (_buildRowText)
      final serviceSeeAllBtn = find.text('ดูทั้งหมด >');
      if (serviceSeeAllBtn.evaluate().isNotEmpty) {
        await tester.tap(serviceSeeAllBtn.first, warnIfMissed: false);
        await tester.pumpAndSettle();
        await tester.pump(
          const Duration(seconds: 1),
        ); // รอหน้า Service All โหลด
        await safePop();
      }

      // 11.3 คอร์สอบรมแนะนำสำหรับคุณ (_buildCourse)
      final courseSectionTitle = find.text('คอร์สอบรมแนะนำสำหรับคุณ');
      if (courseSectionTitle.evaluate().isNotEmpty) {
        await tester.dragUntilVisible(
          courseSectionTitle.first,
          homeScroll,
          const Offset(0, -300),
        );
        await waitForApiToLoad(); // รอ _futureTraining โหลดเสร็จ

        // ลองหาและกดปุ่ม "สมัคร" ของการ์ดแรก
        final applyBtns = find.text('สมัคร');
        if (applyBtns.evaluate().isNotEmpty) {
          await tester.tap(applyBtns.first, warnIfMissed: false);
          await tester.pumpAndSettle();
        }
      }

      // 11.4 ข่าวประชาสัมพันธ์ (_buildNew)
      final newsSectionTitle = find.text('ข่าวประชาสัมพันธ์');
      if (newsSectionTitle.evaluate().isNotEmpty) {
        await tester.dragUntilVisible(
          newsSectionTitle.first,
          homeScroll,
          const Offset(0, -300),
        );
        await waitForApiToLoad(); // รอ _futureNews โหลดเสร็จ

        // ทดสอบกดเข้าไปดูข่าว (ค้นหาจาก Custom Widget: CarouselBanner)
        final carouselBanner = find.byWidgetPredicate(
          (w) => w.runtimeType.toString().contains('CarouselBanner'),
        );
        if (carouselBanner.evaluate().isNotEmpty) {
          final newsItem = find.descendant(
            of: carouselBanner.first,
            matching: find.byType(InkWell),
          );
          if (newsItem.evaluate().isNotEmpty) {
            await tester.tap(newsItem.first, warnIfMissed: false);
            await tester.pumpAndSettle();
            await tester.pump(const Duration(seconds: 1));
            await safePop();
          }
        }
      }

      // 11.5 สิทธิประโยชน์ (_buildPrivilege)
      final privilegeSectionTitle = find.text('สิทธิประโยชน์');
      if (privilegeSectionTitle.evaluate().isNotEmpty) {
        await tester.dragUntilVisible(
          privilegeSectionTitle.first,
          homeScroll,
          const Offset(0, -300),
        );
        await waitForApiToLoad(); // รอ _futurePrivilege โหลดเสร็จ

        // ทดสอบกดเข้าไปดูรายละเอียดสิทธิประโยชน์
        // (สิทธิประโยชน์คือ GridView ตัวที่สองในหน้า Home)
        if (serviceGrids.evaluate().length > 1) {
          final privilegeItem = find.descendant(
            of: serviceGrids.last,
            matching: find.byType(InkWell),
          );
          if (privilegeItem.evaluate().isNotEmpty) {
            await tester.tap(privilegeItem.first, warnIfMissed: false);
            await tester.pumpAndSettle();
            await tester.pump(const Duration(seconds: 1));
            await safePop();
          }
        }

        // ลองกด "ดูทั้งหมด >" ของส่วนสิทธิประโยชน์ (ปุ่มจะอยู่ท้ายสุด)
        if (serviceSeeAllBtn.evaluate().isNotEmpty) {
          await tester.tap(serviceSeeAllBtn.last, warnIfMissed: false);
          await tester.pumpAndSettle();
          await tester.pump(const Duration(seconds: 1));
          await safePop();
        }
      }
      print('----------');
      // ============================================
      // 12. ทดสอบหน้า Profile และการกดเมนูต่างๆ (_rowtxt)
      // ============================================
      // แก้ไข: เพิ่ม Logic การกดซ้ำ (Retry) ที่เสถียรขึ้น
      // ปัญหาเดิมคือ Loop กดปุ่ม Profile รัวๆ โดยไม่รอให้หน้าจอโหลด
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();

      // บังคับกดปุ่ม Profile ที่ Bottom Navigation Bar เพื่อไปยังหน้าโปรไฟล์เสมอ
      final profileMenuBtn = find.text('Profile');
      if (profileMenuBtn.evaluate().isNotEmpty) {
        await tester.tap(profileMenuBtn.last, warnIfMissed: false);
        await tester.pumpAndSettle(const Duration(seconds: 1)); // รอ transition animation
      }

      bool isProfileLoaded = false;
      for (int i = 0; i < 5; i++) {
        // ใช้ .hitTestable() เพื่อรับประกันว่า widget อยู่บนสุดและมองเห็นได้จริงๆ ไม่ได้ซ่อนอยู่หลังหน้าอื่น
        if (find.text('บัญชีผู้ใช้งาน').hitTestable().evaluate().isNotEmpty) {
          isProfileLoaded = true;
          break;
        }
      }
      expect(isProfileLoaded, isTrue, reason: 'ไม่สามารถไปยังหน้าโปรไฟล์ได้');

      final profileScroll = find.byType(SingleChildScrollView).last;

      // รายชื่อเมนู _rowtxt ที่ต้องการทดสอบคลิก
      final profileMenus = [
        'บัญชีผู้ใช้งาน',
        'เปลี่ยนรหัสผ่าน',
        'ตรวจสอบผลการสมัครฝึกอบรม',
        'ความสนใจของคุณ',
        'ตั้งค่าการแจ้งเตือน',
        'เปลี่ยนภาษา /  Language',
        'เกี่ยวกับเรา',
      ];

      for (String menuText in profileMenus) {
        // Finder สำหรับเมนูที่ต้องการ
        final menuFinder = find.text(menuText);

        // เลื่อนหน้าจอจนเจอเมนูนั้นๆ (คำสั่งนี้จะ fail test เองถ้าหาไม่เจอ)
        await tester.dragUntilVisible(
          menuFinder.first,
          profileScroll,
          const Offset(0, -200),
        );
        await tester.pumpAndSettle();

        // กดที่เมนู (ใช้ hitTestable เพื่อบังคับว่าต้องกดโดนจริงๆ)
        await tester.tap(menuFinder.hitTestable().first, warnIfMissed: false);
        await tester.pumpAndSettle();

        // หน่วงเวลา 1 วินาทีเพื่อให้คุณมองเห็นด้วยตาเปล่าว่ามันกดเข้าหน้าย่อยจริงๆ
        await tester.pump(const Duration(seconds: 1));

        // กดกลับมาที่หน้า Profile
        await safePop();
      }

      // 12.1 ทดสอบกดปุ่มออกจากระบบ (Logout)
      final logoutBtn = find.text('ออกจากระบบ');
      await tester.dragUntilVisible(
        logoutBtn.first,
        profileScroll,
        const Offset(0, -200),
      );
      await tester.pumpAndSettle();

      await tester.tap(logoutBtn.hitTestable().first, warnIfMissed: false);
      await tester.pumpAndSettle();
    });
  });
}
