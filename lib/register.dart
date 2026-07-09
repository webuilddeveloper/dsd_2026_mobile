import 'dart:io';
import 'package:dsd/blank_page/appbar.dart';
import 'package:dsd/blank_page/textfield.dart';
import 'package:dsd/shared/api_provider.dart';
import 'package:dsd/shared/app_strings.dart';
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
  String? _required(String? v) {
    final language = AppStrings.of(context);

    return (v == null || v.trim().isEmpty)
        ? language.pleaseEnterInformation
        : null;
  }

  String? _validatePassword(String? value) {
    final language = AppStrings.of(context);
    if (value == null || value.trim().isEmpty) {
      return language.please + language.password;
    }
    if (value.length < 6) {}
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return language.skipchangePassword1;
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return language.skipchangePassword2;
    }
    return null;
  }

  String? _validateConfirmPass(String? v) {
    final language = AppStrings.of(context);
    if (v == null || v.isEmpty) {
      return language.please + language.confirmpassword;
    }
    if (v != _passwordController.text) return language.passwordsnotmatch;
    return null;
  }

  String? _validateIdCard(String? v) {
    final language = AppStrings.of(context);
    if (v == null || v.isEmpty) return language.pleaseEnterIdCardNumber;
    if (v.length != 13) return language.idCardNumberMustBe13Digits;
    return null;
  }

  String? _validatePhone(String? v) {
    final language = AppStrings.of(context);
    if (v == null || v.isEmpty) return language.please + language.phoneNumber;
    if (v.length != 10) return language.phoneNumberMustBe10Digits;
    return null;
  }

  String? _validateDate(String? v) {
    final language = AppStrings.of(context);
    return (v == null || v.trim().isEmpty)
        ? language.please + language.dateOfBirth
        : null;
  }

  String? _validateEmail(String? v) {
    final language = AppStrings.of(context);
    if (v == null || v.isEmpty) return language.please + language.email;
    final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(v)) return language.invalidemail;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final language = AppStrings.of(context); // ← ดึง strings ตาม locale
    return Scaffold(
      appBar: appBar(
        title: language.signUp,
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
                      _sectionTitle(language.userInformation),
                      const SizedBox(height: 24),

                      _buildLabel(language.email),
                      const SizedBox(height: 6),
                      buildTextField(
                        controller: _usernameController,
                        // hint: language.please + language.email,
                        hint: "example@gmail.com",
                        icon: Icons.person_outline_rounded,
                        // validator: _required,
                        validator: _validateEmail,
                      ),
                      const SizedBox(height: 16),

                      _buildLabel(language.password),
                      const SizedBox(height: 6),
                      buildTextField(
                        controller: _passwordController,
                        // hint: language.please + language.password,
                        hint: "Example1234",
                        icon: Icons.lock_outline_rounded,
                        obscure: _obscurePassword,
                        validator: _validatePassword,
                        suffix: _eyeIcon(
                          _obscurePassword,
                          () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      _buildLabel(language.confirmpassword),
                      const SizedBox(height: 6),
                      buildTextField(
                        controller: _confirmPassController,
                        hint: language.confirmpassword,
                        // hint: "กรอกรหัสผ่านอีกครั้ง",
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

                      const SizedBox(height: 16),
                      _buildLabel(language.name),
                      const SizedBox(height: 6),
                      buildTextField(
                        controller: _firstNameController,
                        // hint: " กรุณากรอกชื่อ",
                        hint: language.please + language.name,
                        icon: Icons.person_outline_rounded,
                        validator: _required,
                      ),

                      const SizedBox(height: 24),
                      Divider(color: AppColors.backgroundMain, height: 10),
                      const SizedBox(height: 24),

                      // ── Section: ข้อมูลส่วนตัว ─────────────────────────
                      // _sectionTitle(language.personal),
                      // const SizedBox(height: 24),

                      // _buildLabel(language.idcardNumber),
                      // const SizedBox(height: 6),
                      // buildTextField(
                      //   controller: _idCardController,
                      //   hint: language.please + language.idcardNumber,
                      //   icon: Icons.credit_card_outlined,
                      //   keybord: TextInputType.number,
                      //   validator: _validateIdCard,
                      //   inputFormatters: [
                      //     FilteringTextInputFormatter.digitsOnly,
                      //     LengthLimitingTextInputFormatter(13),
                      //   ],
                      // ),
                      // const SizedBox(height: 16),

                      // _buildLabel(language.titlePrefix),
                      // const SizedBox(height: 6),
                      // buildTextField(
                      //   controller: _prefixController,
                      //   hint: language.prefix,
                      //   icon: Icons.person_outline_rounded,
                      //   validator: _required,
                      // ),
                      // const SizedBox(height: 16),

                      // _buildLabel(language.name),
                      // const SizedBox(height: 6),
                      // buildTextField(
                      //   controller: _firstNameController,
                      //   hint: language.please + language.name,
                      //   icon: Icons.person_outline_rounded,
                      //   validator: _required,
                      // ),
                      // const SizedBox(height: 16),

                      // _buildLabel(language.lastname),
                      // const SizedBox(height: 6),
                      // buildTextField(
                      //   controller: _lastNameController,
                      //   hint: language.please + language.lastname,
                      //   icon: Icons.person_outline_rounded,
                      //   validator: _required,
                      // ),
                      // const SizedBox(height: 16),

                      // _buildLabel(language.dateOfBirth),
                      // const SizedBox(height: 6),
                      // buildDateField(
                      //   context: context,
                      //   controller: _birthDateController,
                      //   hint: language.please + language.dateOfBirth,
                      //   validator: _validateDate,
                      // ),
                      // const SizedBox(height: 16),

                      // _buildLabel(language.phoneNumber),
                      // const SizedBox(height: 6),
                      // buildTextField(
                      //   controller: _phoneController,
                      //   hint: language.please + language.phoneNumber,
                      //   icon: Icons.phone_outlined,
                      //   keybord: TextInputType.phone,
                      //   validator: _validatePhone,
                      //   inputFormatters: [
                      //     FilteringTextInputFormatter.digitsOnly,
                      //     LengthLimitingTextInputFormatter(10),
                      //   ],
                      // ),
                      // const SizedBox(height: 16),

                      // _buildLabel(language.email),
                      // const SizedBox(height: 6),
                      // buildTextField(
                      //   controller: _emailController,
                      //   hint: language.please + language.email,
                      //   icon: Icons.email_outlined,
                      //   keybord: TextInputType.emailAddress,
                      //   validator: _validateEmail,
                      // ),
                      // const SizedBox(height: 24),

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
                          child: Text(
                            language.signUp,
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
    final language = AppStrings.of(context);
    if (!_formKey.currentState!.validate()) return;
    try {
      final result = await postapi('${register}create', {
        // 'idcard': _idCardController.text ,
        'idcard': '',
        'username': _usernameController.text,
        'password': _passwordController.text,
        'facebookID': "",
        'appleID': "",
        'googleID': "",
        'lineID': "",
        // 'email': _emailController.text,
        'email': _usernameController.text,
        'imageUrl': "",
        'category': "guest",
        // 'prefixName': _prefixController.text,
        'prefixName': "",
        'firstName': _firstNameController.text,
        // 'lastName': _lastNameController.text,
        'lastName': "",
        // 'phone': _phoneController.text,
        'phone': "",
        // 'birthDay': _birthDateController.text,
        'birthDay': "",
        'status': "N",
        'platform': Platform.operatingSystem.toString(),
        'countUnit': "[]",
      });
      print('result : ${result}');

      if (!mounted) return;

      if (result['status'] == 'S') {
        showCustomDialog(
          context,
          title: language.registerSuccess,
          description: language.accountReady,
          onConfirm: () {
            Navigator.pop(context);
            // 👉 ตัวเลือก: ไปหน้า Login หรือ Home
            // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginPage()));
          },
        );
      } else {
        showCustomDialog(
          context,
          title: language.failed,
          description:
              (result['message'] != null && result['message'].isNotEmpty)
                  ? result['message']!
                  : language.registerFailed,
          onConfirm: () {
            Navigator.pop(context);
          },
        );
      }
    } catch (e) {
      showCustomDialog(
        context,
        title: language.failed,
        description: language.skipchangePassword5,
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
