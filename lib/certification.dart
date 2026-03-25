import 'package:dsd/blank_page/appbar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Cert extends StatefulWidget {
  const Cert({super.key});

  @override
  State<Cert> createState() => _CertState();
}

class _CertState extends State<Cert> with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  static const _androidUrl =
      'https://play.google.com/store/apps/details?id=th.go.dsd.skill';
  static const _iosUrl =
      'https://apps.apple.com/th/app/dsd-skill/id6741143064?l=th';

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    );
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeIn);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.07),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut));
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        title: 'สมัครรับรองความรู้ตามมาตรฐาน',
        rightBtn: false,
        backAction: () => Navigator.pop(context),
      ),
      backgroundColor: const Color(0xFFF4F7FB),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SlideTransition(
            position: _slideAnim,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _downloadCard(),
                  const SizedBox(height: 20),
                  _requirementsCard(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Download Card ──────────────────────────────────────────────────────────
  Widget _downloadCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: const Text(
              'คู่มือการใช้งานสำหรับประชาชน',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E),
              ),
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
          _storeRow(
            icon: Icons.android_rounded,
            iconColor: const Color(0xFF3DDC84),
            bgColors: [const Color(0xFFE8F5E9), const Color(0xFFF1F8E9)],
            storeLabel: 'GET IT ON',
            storeName: 'Google Play',
            qrPath: 'assets/DSD/imgs/dsd_playstore.png',
            qrCaption: 'สแกนสำหรับ Android',
            onTap: () => _launch(_androidUrl),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Divider(height: 1, color: Color(0xFFF5F5F5)),
          ),
          _storeRow(
            icon: Icons.apple_rounded,
            iconColor: const Color(0xFF1A1A2E),
            bgColors: [const Color(0xFFF5F5F7), const Color(0xFFECECF0)],
            storeLabel: 'Download on the',
            storeName: 'App Store',
            qrPath: 'assets/DSD/imgs/dsd_appstroe.png',
            qrCaption: 'สแกนสำหรับ iOS',
            onTap: () => _launch(_iosUrl),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _storeRow({
    required IconData icon,
    required Color iconColor,
    required List<Color> bgColors,
    required String storeLabel,
    required String storeName,
    required String qrPath,
    required String qrCaption,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          // Store button
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: bgColors),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: iconColor.withOpacity(0.15)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, color: iconColor, size: 28),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          storeLabel,
                          style: const TextStyle(
                            fontSize: 9,
                            color: Color(0xFF757575),
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          storeName,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1A1A2E),
                            letterSpacing: -0.3,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Divider
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                Container(width: 1, height: 28, color: const Color(0xFFE0E0E0)),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    'หรือ',
                    style: TextStyle(fontSize: 11, color: Color(0xFF9E9E9E)),
                  ),
                ),
                Container(width: 1, height: 28, color: const Color(0xFFE0E0E0)),
              ],
            ),
          ),
          // QR
          Column(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFE0E0E0),
                    width: 1.5,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(qrPath, fit: BoxFit.contain),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                qrCaption,
                style: const TextStyle(fontSize: 9, color: Color(0xFF9E9E9E)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Requirements Card ──────────────────────────────────────────────────────
  Widget _requirementsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8F0FE), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A73E8).withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          const Text(
            'ข้อกำหนดเบื้องต้นของการใช้งานระบบ',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 10),
          // Paragraph
          RichText(
            text: const TextSpan(
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF424242),
                height: 1.8,
              ),
              children: [
                TextSpan(
                  text:
                      'การเข้าใช้งานแพลตฟอร์มระบบ Mobile Application รับรองความรู้ความสามารถสำหรับประชาชน สามารถใช้งานผ่านโทรศัพท์มือถือเคลื่อนที่ (Smart Phone) หรือแท็บเล็ต บนระบบปฏิบัติการ iOS เวอร์ชั่น 13.0 ขึ้นไป และระบบปฏิบัติการ Android เวอร์ชั่น 8.0 ขึ้นไป โดยสามารถดาวโหลดได้จากแพลตฟอร์ม ',
                ),
                TextSpan(
                  text: 'App Store',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                TextSpan(text: ' และ '),
                TextSpan(
                  text: 'Google Play',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                TextSpan(text: ' และจำเป็นที่จะต้องมี Application '),
                TextSpan(
                  text: 'ThaID',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFE65100),
                  ),
                ),
                TextSpan(
                  text:
                      ' เพื่อยืนยันตัวตนเข้าสู่ระบบสำหรับกลุ่มผู้ใช้งานประชาชน',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
