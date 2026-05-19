import 'package:dsd/blank_page/appbar.dart';
import 'package:dsd/blank_page/dialog_fail.dart';
import 'package:dsd/blank_page/textfield.dart';
import 'package:dsd/shared/api_provider.dart';
import 'package:dsd/shared/app_strings.dart';
import 'package:dsd/style_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final storage = FlutterSecureStorage();
  final txtOldPassword = TextEditingController();
  final txtPassword = TextEditingController();
  final txtConfirmPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscureOld = true;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;
  String _passwordValue = '';

  @override
  void initState() {
    super.initState();
    txtPassword.addListener(() {
      setState(() => _passwordValue = txtPassword.text);
    });
  }

  // 0=empty, 1=weak, 2=medium, 3=strong
  int _getStrength(String value) {
    if (value.isEmpty) return 0;
    int score = 0;
    if (value.length >= 8) score++;
    if (value.contains(RegExp(r'[A-Z]'))) score++;
    if (value.contains(RegExp(r'[0-9]'))) score++;
    return score;
  }

  Widget _buildStrengthBar(String value) {
    final strength = _getStrength(value);
    final language = AppStrings.of(context);
    if (strength == 0) return const SizedBox.shrink();

    final labels = [
      '',
      (language.labelstrength1),
      (language.labelstrength2),
      (language.labelstrength3),
    ];
    final colors = [
      Colors.transparent,
      Colors.redAccent,
      Colors.orange,
      const Color(0xFF4CAF50),
    ];

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(3, (i) {
              final active = i < strength;
              return Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 4,
                  margin: EdgeInsets.only(right: i < 2 ? 6 : 0),
                  decoration: BoxDecoration(
                    color: active ? colors[strength] : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 6),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Text(
              '${language.strength}: ${labels[strength]}',
              key: ValueKey(strength),
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'Kanit',
                color: colors[strength],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void goBack() => Navigator.pop(context);

  Future<void> _submitUpdate() async {
    FocusScope.of(context).unfocus();
    final language = AppStrings.of(context);

    if (!_formKey.currentState!.validate()) return;
    final _code = await storage.read(key: 'profileCode');

    setState(() => _isLoading = true);

    try {
      final value = await postapi('${register}change', {
        "code": _code.toString(),
        "password": txtOldPassword.text.trim(),
        "newpassword": txtPassword.text.trim(),
      });

      if (value['status'] == 'S') {
        showCustomDialog(
          context,
          title: language.changePassword + language.successfully,
          description: language.skipchangePassword3,
          onConfirm: () {
            Navigator.pop(context);
          },
        );
      } else {
        showCustomDialog(
          context,
          title: language.failed,
          description: language.skipchangePassword4,
          onConfirm: () {},
        );
      }
    } catch (e) {
      showCustomDialog(
        context,
        title: language.failed,
        description: language.skipchangePassword5,
        onConfirm: () {},
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String? _validateOldPassword(String? value) {
    final language = AppStrings.of(context);
    if (value == null || value.trim().isEmpty) {
      return language.please + language.password;
    }
    if (value.length < 6) {
      return language.skipchangePassword;
    }

    return null;
  }

  String? _validatePassword(String? value) {
    final language = AppStrings.of(context);
    if (value == null || value.trim().isEmpty) {
      return language.please + language.password;
    }
    if (value.length < 6) {
      return language.skipchangePassword;
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return language.skipchangePassword1;
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return language.skipchangePassword2;
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    final language = AppStrings.of(context);
    if (value == null || value.trim().isEmpty) {
      return language.please + language.confirmNewpassword;
    }
    if (value != txtPassword.text) {
      return language.passwordsnotmatch;
    }
    return null;
  }

  @override
  void dispose() {
    txtOldPassword.dispose();
    txtPassword.dispose();
    txtConfirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final language = AppStrings.of(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundMain,
      appBar: appBar(
        title: language.changePassword,
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
                      Text(
                        language.changePassword,
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
                  Padding(
                    padding: const EdgeInsets.only(left: 14),
                    child: Text(
                      language.skipchangePassword,
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Kanit',
                        color: AppColors.textDark.withOpacity(0.45),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    language.currentPassword,
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.w500,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  buildTextField(
                    controller: txtOldPassword,
                    hint: language.please + language.currentPassword,
                    icon: Icons.lock_outline,
                    obscure: _obscureOld,
                    validator: _validateOldPassword,
                    suffix: IconButton(
                      icon: Icon(
                        _obscureOld
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 20,
                        color: AppColors.textgrey,
                      ),
                      onPressed:
                          () => setState(() {
                            _obscureOld = !_obscureOld;
                          }),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Password field
                  Text(
                    language.newPassword,
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.w500,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  buildTextField(
                    controller: txtPassword,
                    hint: language.please + language.newPassword,
                    icon: Icons.lock_outline,
                    obscure: _obscurePassword,
                    validator: _validatePassword,
                    suffix: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 20,
                        color: AppColors.textgrey,
                      ),
                      onPressed:
                          () => setState(() {
                            _obscurePassword = !_obscurePassword;
                          }),
                    ),
                  ),
                  _buildStrengthBar(_passwordValue),
                  const SizedBox(height: 18),

                  // Confirm password field
                  Text(
                    language.confirmNewpassword,
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.w500,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  buildTextField(
                    controller: txtConfirmPassword,
                    hint: language.please + language.confirmNewpassword,
                    icon: Icons.lock_outline,
                    obscure: _obscureConfirm,
                    validator: _validateConfirmPassword,
                    suffix: IconButton(
                      icon: Icon(
                        _obscureConfirm
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 20,
                        color: AppColors.textgrey,
                      ),
                      onPressed:
                          () => setState(() {
                            _obscureConfirm = !_obscureConfirm;
                          }),
                    ),
                  ),
                  const SizedBox(height: 32),

                  const Divider(height: 1, color: Color(0xFFF0F0F0)),
                  const SizedBox(height: 28),

                  // Submit button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitUpdate,
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
                              : Text(
                                language.save,
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
}
