import 'package:dsd/blank_page/appbar.dart';
import 'package:dsd/blank_page/dialog_fail.dart' show showCustomDialog;
import 'package:dsd/blank_page/textfield.dart';
import 'package:dsd/shared/api_provider.dart';
import 'package:dsd/style_theme.dart';
import 'package:flutter/material.dart';

class ForgotPage extends StatefulWidget {
  const ForgotPage({super.key});

  @override
  State<ForgotPage> createState() => _ForgotPageState();
}

class _ForgotPageState extends State<ForgotPage> {
  void goBack() => Navigator.pop(context);

  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: appBar(
        title: 'ลืมรหัสผ่าน',
        backBtn: true,
        rightBtn: false,
        backAction: () => goBack(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: screenHeight * 0.04,
          bottom: screenHeight * 0.06,
        ),
        child: Form(
          key: _formKey,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 44, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Title
                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 22,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'ลืมรหัสผ่าน',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                          fontFamily: 'Kanit',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  /// ✅ ปรับ copy ให้เข้าใจง่าย
                  Padding(
                    padding: const EdgeInsets.only(left: 14),
                    child: Text(
                      'กรอกอีเมลที่คุณใช้สมัคร\nเราจะส่งลิงก์ตั้งรหัสผ่านใหม่ให้คุณ',
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Kanit',
                        color: AppColors.textDark.withOpacity(0.45),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// Email
                  const Text(
                    'อีเมล',
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.w500,
                      color: AppColors.textDark,
                    ),
                  ),

                  const SizedBox(height: 8),

                  buildTextField(
                    controller: emailController,
                    hint: 'example@email.com',
                    icon: Icons.email_outlined,
                    obscure: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณากรอกอีเมล';
                      }
                      if (!RegExp(
                        r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$',
                      ).hasMatch(value)) {
                        return 'รูปแบบอีเมลไม่ถูกต้อง';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 32),
                  const Divider(height: 1, color: Color(0xFFF0F0F0)),
                  const SizedBox(height: 28),

                  /// Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _onPressSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: AppColors.primary.withOpacity(
                          0.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child:
                          _isLoading
                              ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                              : const Text(
                                'ยืนยันอีเมล',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Kanit',
                                ),
                              ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 👉 กดปุ่ม
  void _onPressSubmit() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    /// ✅ Dialog ยืนยันก่อนส่ง
    showCustomDialog(
      context,
      title: 'ยืนยันการส่ง',
      description:
          'เราจะส่งลิงก์รีเซ็ตรหัสผ่านไปยังอีเมลนี้\nคุณต้องการดำเนินการต่อหรือไม่?',
      cencelable: true,
      onConfirm: _submitEmail,
    );
  }

  Future<void> _submitEmail() async {
    setState(() => _isLoading = true);

    try {
      final value = await postapi('${register}forgot/password', {
        "email": emailController.text.trim(),
      });

      /// ✅ success
      if (value['status'] == 'S') {
        showCustomDialog(
          context,
          title: 'ส่งสำเร็จ',
          description:
              'เราได้ส่งลิงก์รีเซ็ตรหัสผ่านไปยังอีเมลของคุณแล้ว\n\nกรุณาตรวจสอบอีเมลเพื่อดำเนินการต่อ',
          onConfirm: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        );
      } else {
        /// ❌ กรณี email ไม่เจอ / fail จาก server
        showCustomDialog(
          context,
          title: 'ไม่พบอีเมล',
          description: 'ไม่พบบัญชีที่ใช้อีเมลนี้\nกรุณาตรวจสอบอีกครั้ง',
          onConfirm: () {},
        );
      }
    } catch (e) {
      /// ❌ network error / server error
      showCustomDialog(
        context,
        title: 'เกิดข้อผิดพลาด',
        description: 'ไม่สามารถเชื่อมต่อเซิร์ฟเวอร์ได้\nกรุณาลองใหม่อีกครั้ง',
        onConfirm: () {},
      );
    } finally {
      /// ✅ กัน loading ค้าง (สำคัญมาก)
      setState(() => _isLoading = false);
    }
  }
}
