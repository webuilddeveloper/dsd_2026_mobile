import 'dart:io';
import 'package:dsd/menu.dart';
import 'package:dsd/style_theme.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.pageIndex});
  final int? pageIndex;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
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
                            _buildTextField(
                              controller: _usernameController,
                              hint: 'กรอกชื่อผู้ใช้งาน',
                              icon: Icons.person_outline_rounded,
                            ),
                            const SizedBox(height: 16),

                            // Password
                            _buildLabel('รหัสผ่าน'),
                            const SizedBox(height: 6),
                            _buildTextField(
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
                          _buildSocialButton('assets/images/facebook.png'),
                          const SizedBox(width: 14),
                          _buildSocialButton('assets/images/google.png'),
                          const SizedBox(width: 14),
                          _buildSocialButton('assets/images/line.png'),
                          if (Platform.isIOS) ...[
                            const SizedBox(width: 14),
                            _buildSocialButton('assets/images/apple.png'),
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
                            onTap: () {},
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
    );
  }

  void _handleLogin() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => Menu(pageIndex: null)),
      (Route<dynamic> route) => false,
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffix,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(
        fontFamily: 'Kanit',
        fontSize: 14,
        color: AppColors.textDark,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          fontFamily: 'Kanit',
          fontSize: 13,
          color: AppColors.textgrey,
        ),
        prefixIcon: Icon(icon, size: 18, color: AppColors.textgrey),
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: AppColors.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: AppColors.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
      ),
    );
  }

  Widget _buildSocialButton(String imagePath) {
    return Container(
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
    );
  }
}
