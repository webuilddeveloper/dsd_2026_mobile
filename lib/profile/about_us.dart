import 'package:dsd/blank_page/appbar.dart';
import 'package:dsd/style_theme.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() => _version = info.version);
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('ไม่สามารถเปิดลิงก์ได้')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundMain,
      appBar: appBar(
        title: 'เกี่ยวกับเรา',
        backBtn: true,
        rightBtn: false,
        backAction: () => Navigator.pop(context),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
        children: [
          // ── Logo + App info ──
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
            child: Column(
              children: [
                // Logo
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/DSD/imgs/logo_app.png',
                      width: 48,
                      height: 48,
                      // fallback ถ้าไม่มี asset
                      errorBuilder:
                          (_, __, ___) => const Icon(
                            Icons.layers_outlined,
                            size: 40,
                            color: Colors.white,
                          ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'DSD Application',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Kanit',
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'กรมพัฒนาฝีมือแรงงาน',
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: 'Kanit',
                    color: AppColors.textgrey,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAEEDA),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'เวอร์ชั่น ${_version.isNotEmpty ? _version : '1.0.0'}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Kanit',
                      color: Color(0xFF633806),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // ── Links ──
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _linkRow(
                  icon: Icons.shield_outlined,
                  label: 'นโยบายความเป็นส่วนตัว',
                  onTap:
                      () => _launchUrl(
                        'https://www.dsd.go.th/privacy-policy', // ← เปลี่ยน URL จริง
                      ),
                  isExternal: true,
                ),
                const Divider(height: 1, color: AppColors.backgroundMain),

                const Divider(height: 1, color: AppColors.backgroundMain),
                _linkRow(
                  icon: Icons.chat_bubble_outline_rounded,
                  label: 'ติดต่อเรา',
                  onTap:
                      () => _launchUrl(
                        'https://webuild.co.th/', // ← เปลี่ยน URL จริง
                      ),
                  isExternal: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _linkRow({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isExternal,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFFFAEEDA),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 15, color: const Color(0xFF854F0B)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontFamily: 'Kanit',
                  color: AppColors.textDark,
                ),
              ),
            ),
            Icon(
              isExternal
                  ? Icons.open_in_new_rounded
                  : Icons.chevron_right_rounded,
              size: 16,
              color: AppColors.textgrey,
            ),
          ],
        ),
      ),
    );
  }
}
