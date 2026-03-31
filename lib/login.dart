import 'dart:convert';
import 'dart:io';
import 'package:dsd/blank_page/dialog_fail.dart';
import 'package:dsd/blank_page/textfield.dart';
import 'package:dsd/menu.dart';
import 'package:dsd/register.dart';
import 'package:dsd/shared/api_provider.dart';
import 'package:dsd/shared/line.dart';
import 'package:dsd/style_theme.dart';
import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final storage = FlutterSecureStorage();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  late final AnimationController _animCtrl;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();

    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut));
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _animCtrl.dispose();
    super.dispose();
  }

  final bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.backgroundMain,
      body: Stack(
        children: [
          // ─── Header background ────────────────────────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: size.height * 0.38,
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(36),
                  bottomRight: Radius.circular(36),
                ),
              ),
            ),
          ),

          // ─── Scrollable content ───────────────────────────────────────
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    24,
                    size.height * 0.025,
                    24,
                    bottomPad + 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // ── Logo + Title ──────────────────────────────────
                      Column(
                        children: [
                          Image.asset(
                            'assets/DSD/imgs/logo.png',
                            color: Colors.white,
                            width: 180,
                          ),
                          const SizedBox(height: 14),
                        ],
                      ),

                      // ── Login Card ────────────────────────────────────
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
                                  'เข้าสู่ระบบ',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textDark,
                                    fontFamily: 'Kanit',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // Username
                            _buildLabel('ชื่อผู้ใช้งาน'),
                            const SizedBox(height: 6),
                            buildTextField(
                              controller: _usernameController,
                              hint: 'กรอกชื่อผู้ใช้งาน',
                              icon: Icons.person_outline_rounded,
                            ),
                            const SizedBox(height: 16),

                            // Password
                            _buildLabel('รหัสผ่าน'),
                            const SizedBox(height: 6),
                            buildTextField(
                              controller: _passwordController,
                              hint: 'กรอกรหัสผ่าน',
                              icon: Icons.lock_outline_rounded,
                              obscure: _obscurePassword,
                              suffix: GestureDetector(
                                onTap:
                                    () => setState(
                                      () =>
                                          _obscurePassword = !_obscurePassword,
                                    ),
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    size: 18,
                                    color: AppColors.textgrey,
                                  ),
                                ),
                              ),
                            ),

                            // Forgot password
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text(
                                  'ลืมรหัสผ่าน?',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontFamily: 'Kanit',
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),

                            // Login button
                            SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                onPressed: _handleLogin,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'เข้าสู่ระบบ',
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

                      const SizedBox(height: 28),

                      // ── Divider ───────────────────────────────────────
                      Row(
                        children: [
                          const Expanded(
                            child: Divider(
                              color: AppColors.borderColor,
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Text(
                              'หรือเข้าสู่ระบบด้วย',
                              style: TextStyle(
                                color: AppColors.textgrey,
                                fontSize: 12,
                                fontFamily: 'Kanit',
                              ),
                            ),
                          ),
                          const Expanded(
                            child: Divider(
                              color: AppColors.borderColor,
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // ── Social buttons ────────────────────────────────
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildSocialButton(
                            imagePath: 'assets/images/facebook.png',
                            onTap: () {},
                          ),
                          const SizedBox(width: 14),
                          _buildSocialButton(
                            imagePath: 'assets/images/google.png',
                            onTap: () {},
                          ),
                          const SizedBox(width: 14),
                          _buildSocialButton(
                            imagePath: 'assets/images/line.png',
                            onTap: () async {
                              try {
                                final result = await loginLine();
                                print("RESULT: $result");

                                final model = {
                                  "username": result.userProfile?.userId ?? "",
                                  "lineID": result.userProfile?.userId ?? "",
                                  "email": result.accessToken.email ?? "",
                                  "imageUrl":
                                      result.userProfile?.pictureUrl ?? "",
                                  "firstName":
                                      result.userProfile?.displayName ?? "",
                                  "lastName": "",
                                };
                                if (result.userProfile != null) {
                                  _handleSocail(model: model, category: "line");
                                } else {
                                  print("Login failed (no profile)");
                                }
                              } catch (e) {
                                print("LINE LOGIN ERROR: $e");
                              }
                            },
                          ),
                          if (Platform.isIOS) ...[
                            const SizedBox(width: 14),
                            _buildSocialButton(
                              imagePath: 'assets/images/apple.png',
                              onTap: () {},
                            ),
                          ],
                        ],
                      ),

                      const SizedBox(height: 28),

                      // ── Sign up row ───────────────────────────────────
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'ยังไม่มีบัญชี? ',
                            style: TextStyle(
                              color: AppColors.textgrey,
                              fontFamily: 'Kanit',
                              fontSize: 14,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RegsiterPage(),
                                ),
                              );
                            },
                            child: const Text(
                              'สมัครสมาชิก',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Kanit',
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: GestureDetector(
            onTap: _isLoading ? null : () => Navigator.pop(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 13,
                  color: AppColors.textgrey,
                ),
                const SizedBox(width: 4),
                Text(
                  'กลับหน้าก่อนหน้า',
                  style: TextStyle(
                    color: AppColors.textgrey,
                    fontFamily: 'Kanit',
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _handleSocail({
    required Map<String, dynamic> model,
    required String category,
  }) async {
    final result = await postLoginRegister('${registerV2}${category}/login', {
      'username': model['username'],
      'lineID': model['lineID'],
      'email': model['email'],
      'imageUrl': model['imageUrl'],
      'firstName': model['firstName'],
      'lastName': model['lastName'],
    });

    if (result['status'] == 'S') {
      final data = result['objectData'] ?? {};
      await storage.write(key: 'profileCode', value: data['code'] ?? '');
      await storage.write(key: 'profileCategory', value: category);
      
      // await storage.write(key: 'token', value: result['jsonData']);
      // await storage.write(key: 'dataUserLoginDDPM', value: jsonEncode(data));

      // await storage.write(key: 'username', value: data['username'] ?? '');
      // await storage.write(
      //   key: 'profileImageUrl',
      //   value: data['imageUrl'] ?? '',
      // );
      // await storage.write(key: 'idcard', value: data['idcard'] ?? '');

      // await storage.write(
      //   key: 'profileFirstName',
      //   value: data['firstName'] ?? '',
      // );
      // await storage.write(
      //   key: 'profileLastName',
      //   value: data['lastName'] ?? '',
      // );

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => Menu()),
        (route) => false,
      );
    }
  }

  Future<void> _handleLogin() async {
    final storage = FlutterSecureStorage();

    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty) {
      showDialogFail(
        context,
        title: 'เกิดข้อผิดพลาด',
        description: 'กรุณากรอกชื่อผู้ใช้',
        onConfirm: () {
          Navigator.pop(context);
        },
      );
      return;
    }

    if (password.isEmpty) {
      showDialogFail(
        context,
        title: 'เกิดข้อผิดพลาด',
        description: 'กรุณากรอกรหัสผ่าน',
        onConfirm: () {
          Navigator.pop(context);
        },
      );
      return;
    }

    try {
      final url = '${register}login';

      final result = await postLoginRegister(url, {
        'username': username,
        'password': password,
        'category': 'guest',
      });

      if (!mounted) return;

      // ✅ LOGIN SUCCESS
      if (result['status'] == 'S') {
        final data = result['objectData'] ?? {};

        await storage.write(key: 'token', value: result['jsonData']);
        await storage.write(key: 'dataUserLoginDDPM', value: jsonEncode(data));
        await storage.write(key: 'profileCode', value: data['code'] ?? '');
        await storage.write(key: 'username', value: data['username'] ?? '');
        await storage.write(
          key: 'profileImageUrl',
          value: data['imageUrl'] ?? '',
        );
        await storage.write(key: 'idcard', value: data['idcard'] ?? '');
        await storage.write(key: 'profileCategory', value: 'guest');
        await storage.write(
          key: 'profileFirstName',
          value: data['firstName'] ?? '',
        );
        await storage.write(
          key: 'profileLastName',
          value: data['lastName'] ?? '',
        );

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => Menu()),
          (route) => false,
        );
      } else {
        // ❌ LOGIN FAIL
        showDialogFail(
          context,
          title: 'เกิดข้อผิดพลาด',
          description:
              (result['message'] != null &&
                      result['message'].toString().isNotEmpty)
                  ? result['message']
                  : 'เข้าสู่ระบบไม่สำเร็จ',
          onConfirm: () {
            Navigator.pop(context);
          },
        );
      }
    } catch (e) {
      print("LOGIN ERROR: $e");

      // ❌ NETWORK ERROR
      showDialogFail(
        context,
        title: 'เกิดข้อผิดพลาด',
        description: 'ไม่สามารถเชื่อมต่อเซิร์ฟเวอร์ได้ กรุณาลองใหม่อีกครั้ง',
        onConfirm: () {
          Navigator.pop(context);
        },
      );
    } finally {
      if (mounted) {}
    }
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

  Widget _buildSocialButton({
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Center(
          child: Image.asset(
            imagePath,
            width: 24,
            height: 24,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
