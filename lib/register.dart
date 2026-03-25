import 'dart:io';
import 'package:dsd/blank_page/appbar.dart';
import 'package:dsd/blank_page/textfield.dart';
import 'package:dsd/shared/api_provider.dart';
import 'package:dsd/style_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../blank_page/dialog_fail.dart';

class RegsiterPage extends StatefulWidget {
  const RegsiterPage({super.key});

  @override
  State<RegsiterPage> createState() => _RegsiterPageState();
}

class _RegsiterPageState extends State<RegsiterPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late AnimationController _controller;

  // ── Controllers ─────────────────────────────────────────────────────────
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPassController = TextEditingController();
  final _idCardController = TextEditingController();
  final _prefixController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  void goBack() => Navigator.pop(context);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPassController.dispose();
    _idCardController.dispose();
    _prefixController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _birthDateController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _controller.dispose();
    super.dispose();
  }

  // ── Validation ───────────────────────────────────────────────────────────
  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'กรุณากรอกข้อมูล' : null;

  // String? _validatePassword(String? v) {
  //   if (v == null || v.isEmpty) return 'กรุณากรอกรหัสผ่าน';
  //   if (v.length < 8) return 'รหัสผ่านต้องมีอย่างน้อย 8 ตัวอักษร';
  //   return null;
  // }

  String? _validateConfirmPass(String? v) {
    if (v == null || v.isEmpty) return 'กรุณายืนยันรหัสผ่าน';
    if (v != _passwordController.text) return 'รหัสผ่านไม่ตรงกัน';
    return null;
  }

  String? _validateIdCard(String? v) {
    if (v == null || v.isEmpty) return 'กรุณากรอกเลขบัตรประชาชน';
    if (v.length != 13) return 'เลขบัตรประชาชนต้องมี 13 หลัก';
    return null;
  }

  String? _validatePhone(String? v) {
    if (v == null || v.isEmpty) return 'กรุณากรอกเบอร์โทรศัพท์';
    if (v.length != 10) return 'เบอร์โทรศัพท์ต้องมี 10 หลัก';
    return null;
  }

  String? _validateEmail(String? v) {
    if (v == null || v.isEmpty) return 'กรุณากรอกอีเมล';
    final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(v)) return 'รูปแบบอีเมลไม่ถูกต้อง';
    return null;
  }

  String? _validateDate(String? v) =>
      (v == null || v.trim().isEmpty) ? 'กรุณาเลือกวันเกิด' : null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        title: 'สมัครสมาชิก',
        backBtn: true,
        rightBtn: false,
        backAction: () => goBack(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.07),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // ── Section: ข้อมูลผู้ใช้งาน ──────────────────────
                      _sectionTitle('ข้อมูลผู้ใช้งาน'),
                      const SizedBox(height: 24),

                      _buildLabel('ชื่อผู้ใช้งาน'),
                      const SizedBox(height: 6),
                      buildTextField(
                        controller: _usernameController,
                        hint: 'กรอกชื่อผู้ใช้งาน',
                        icon: Icons.person_outline_rounded,
                        validator: _required,
                      ),
                      const SizedBox(height: 16),

                      _buildLabel('รหัสผ่าน'),
                      const SizedBox(height: 6),
                      buildTextField(
                        controller: _passwordController,
                        hint: 'กรอกรหัสผ่าน ',
                        icon: Icons.lock_outline_rounded,
                        obscure: _obscurePassword,
                        // validator: _validatePassword,
                        suffix: _eyeIcon(
                          _obscurePassword,
                          () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      _buildLabel('ยืนยันรหัสผ่าน'),
                      const SizedBox(height: 6),
                      buildTextField(
                        controller: _confirmPassController,
                        hint: 'กรอกยืนยันรหัสผ่าน',
                        icon: Icons.lock_outline_rounded,
                        obscure: _obscureConfirmPassword,
                        validator: _validateConfirmPass,
                        suffix: _eyeIcon(
                          _obscureConfirmPassword,
                          () => setState(
                            () =>
                                _obscureConfirmPassword =
                                    !_obscureConfirmPassword,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),
                      Divider(color: AppColors.backgroundMain, height: 10),
                      const SizedBox(height: 24),

                      // ── Section: ข้อมูลส่วนตัว ─────────────────────────
                      _sectionTitle('ข้อมูลส่วนตัว'),
                      const SizedBox(height: 24),

                      _buildLabel('เลขบัตรประชาชน'),
                      const SizedBox(height: 6),
                      buildTextField(
                        controller: _idCardController,
                        hint: 'กรอกเลขบัตรประชาชน 13 หลัก',
                        icon: Icons.credit_card_outlined,
                        keybord: TextInputType.number,
                        validator: _validateIdCard,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(13),
                        ],
                      ),
                      const SizedBox(height: 16),

                      _buildLabel('คำนำหน้า'),
                      const SizedBox(height: 6),
                      buildTextField(
                        controller: _prefixController,
                        hint: 'กรอกคำนำหน้า',
                        icon: Icons.person_outline_rounded,
                        validator: _required,
                      ),
                      const SizedBox(height: 16),

                      _buildLabel('ชื่อ'),
                      const SizedBox(height: 6),
                      buildTextField(
                        controller: _firstNameController,
                        hint: 'กรอกชื่อ',
                        icon: Icons.person_outline_rounded,
                        validator: _required,
                      ),
                      const SizedBox(height: 16),

                      _buildLabel('นามสกุล'),
                      const SizedBox(height: 6),
                      buildTextField(
                        controller: _lastNameController,
                        hint: 'กรอกนามสกุล',
                        icon: Icons.person_outline_rounded,
                        validator: _required,
                      ),
                      const SizedBox(height: 16),

                      _buildLabel('วันเกิด'),
                      const SizedBox(height: 6),
                      buildDateField(
                        context: context,
                        controller: _birthDateController,
                        hint: 'เลือกวันเกิด',
                        validator: _validateDate,
                      ),
                      const SizedBox(height: 16),

                      _buildLabel('เบอร์โทรศัพท์ (10 หลัก)'),
                      const SizedBox(height: 6),
                      buildTextField(
                        controller: _phoneController,
                        hint: 'กรอกเบอร์โทรศัพท์',
                        icon: Icons.phone_outlined,
                        keybord: TextInputType.phone,
                        validator: _validatePhone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                      ),
                      const SizedBox(height: 16),

                      _buildLabel('อีเมล'),
                      const SizedBox(height: 6),
                      buildTextField(
                        controller: _emailController,
                        hint: 'กรอกอีเมล',
                        icon: Icons.email_outlined,
                        keybord: TextInputType.emailAddress,
                        validator: _validateEmail,
                      ),
                      const SizedBox(height: 24),

                      // ── Submit ─────────────────────────────────────────
                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _handleSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'สมัคร',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Kanit',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      final result = await postLoginRegister('${register}create', {
        'idcard': _idCardController.text,
        'username': _usernameController.text,
        'password': _passwordController.text,
        'facebookID': "",
        'appleID': "",
        'googleID': "",
        'lineID': "",
        'email': _emailController.text,
        'imageUrl': "",
        'category': "guest",
        'prefixName': _prefixController.text,
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'phone': _phoneController.text,
        'birthDay': _birthDateController.text,
        'status': "N",
        'platform': Platform.operatingSystem.toString(),
        'countUnit': "[]",
      });

      if (!mounted) return;

      if (result['status'] == 'S') {
        // ✅ สมัครสำเร็จ
        showCustomDialog(
          context,
          title: 'สมัครสมาชิกสำเร็จ',
          description: "บัญชีของคุณพร้อมใช้งานแล้ว",
          onConfirm: () {
            Navigator.pop(context);

            // 👉 ตัวเลือก: ไปหน้า Login หรือ Home
            // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginPage()));
          },
        );
      } else {
        showCustomDialog(
          context,
          title: 'เกิดข้อผิดพลาด',
          description:
              (result['message'] != null && result['message'].isNotEmpty)
                  ? result['message']!
                  : 'ไม่สามารถสมัครสมาชิกได้ กรุณาลองใหม่อีกครั้ง',
          onConfirm: () {
            Navigator.pop(context);
          },
        );
      }
    } catch (e) {
      showCustomDialog(
        context,
        title: 'เกิดข้อผิดพลาด',
        description: 'ไม่สามารถเชื่อมต่อเซิร์ฟเวอร์ได้ กรุณาลองใหม่อีกครั้ง',
        onConfirm: () {
          Navigator.pop(context);
        },
      );
    } finally {
      if (mounted) {
        setState(() {});
      }
    }
  }

  // ── Helpers ──────────────────────────────────────────────────────────────
  Widget _sectionTitle(String text) {
    return Row(
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
        Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
            fontFamily: 'Kanit',
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
        fontFamily: 'Kanit',
      ),
    );
  }

  Widget _eyeIcon(bool obscure, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: Icon(
          obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          size: 18,
          color: AppColors.textgrey,
        ),
      ),
    );
  }
}
