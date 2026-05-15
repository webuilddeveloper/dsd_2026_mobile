import 'dart:async';

import 'package:dsd/blank_page/appbar.dart';
import 'package:dsd/shared/api_provider.dart';
import 'package:dsd/style_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  String _version = '';
  late Future<List<Map<String, dynamic>>> about;

  @override
  void initState() {
    super.initState();
    _loadVersion();
    about = aboutApi();
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

  Future<List<Map<String, dynamic>>> aboutApi() async {
    final data = await postDio('${aboutUs}read', {});
    return (data as List).cast<Map<String, dynamic>>();
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
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: about,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }
          if (snapshot.hasError) {
            return const Center(child: Text('โหลดข้อมูลไม่สำเร็จ'));
          }

          final item = snapshot.data!.first;

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
            children: [
              _buildHeroCard(item),
              const SizedBox(height: 24),

              _sectionLabel('เกี่ยวกับแอป'),
              const SizedBox(height: 8),
              _buildAppLinksCard(item),
              const SizedBox(height: 24),

              _sectionLabel('ข้อมูลการติดต่อ'),
              const SizedBox(height: 8),
              _buildContactCard(item),
              const SizedBox(height: 24),

              _sectionLabel('ช่องทางออนไลน์'),
              const SizedBox(height: 8),
              _buildSocialCard(item),
              const SizedBox(height: 24),

              _buildMapPlaceholder(item),
            ],
          );
        },
      ),
    );
  }

  // ── Hero: icon + ชื่อ + version ───────────────────
  Widget _buildHeroCard(Map<String, dynamic> item) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
      child: Column(
        children: [
          // logo มุมโค้ง
          ClipRRect(
            // borderRadius: BorderRadius.circular(18),
            child: Image.network(
              item['imageLogoUrl'],
              height: MediaQuery.of(context).size.height * 0.15,
              fit: BoxFit.cover,
              errorBuilder:
                  (_, __, ___) => Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(
                      Icons.business_rounded,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            item['title'],
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              fontFamily: 'Kanit',
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'เวอร์ชัน $_version',
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'Kanit',
              color: Colors.white.withOpacity(0.65),
            ),
          ),
        ],
      ),
    );
  }

  // ── เกี่ยวกับแอป ──────────────────────────────────
  Widget _buildAppLinksCard(Map<String, dynamic> item) {
    return _card([
      _externalRow(
        icon: Icons.shield_outlined,
        iconColor: AppColors.primary,
        iconBg: AppColors.primaryShade,
        label: 'นโยบายความเป็นส่วนตัว',
        onTap: () => _launchUrl(item['policyUrl']),
        isFirst: true,
      ),
      _divider(),
      _externalRow(
        icon: Icons.chat_bubble_outline_rounded,
        iconColor: AppColors.primary,
        iconBg: AppColors.primaryShade,
        label: 'ติดต่อเรา',
        onTap: () => _launchUrl(item['site']),
        isLast: true,
      ),
    ]);
  }

  // ── ข้อมูลการติดต่อ ───────────────────────────────
  Widget _buildContactCard(Map<String, dynamic> item) {
    return _card([
      _infoRow(
        icon: Icons.phone_outlined,
        iconColor: AppColors.primary,
        iconBg: AppColors.primaryShade,
        title: 'โทรศัพท์',
        value: item['telephone'],
        onTap: () => _launchUrl('tel:${item['telephone']}'),
        isFirst: true,
      ),
      _divider(),
      _infoRow(
        icon: Icons.mail_outline_rounded,
        iconColor: AppColors.primary,
        iconBg: AppColors.primaryShade,
        title: 'อีเมล',
        value: item['email'],
        onTap: () => _launchUrl('mailto:${item['email']}'),
      ),
      _divider(),
      _infoRow(
        icon: Icons.location_on_outlined,
        iconColor: AppColors.primary,
        iconBg: AppColors.primaryShade,
        title: 'ที่อยู่',
        value: item['address'],
        onTap: () {},
        isLast: true,
      ),
    ]);
  }

  // ── ช่องทางออนไลน์ (compact list) ────────────────
  Widget _buildSocialCard(Map<String, dynamic> item) {
    final socials = [
      _SocialItem(
        icon: Icons.facebook_rounded,
        iconColor: const Color(0xFF1877F2),
        iconBg: const Color(0xFFE8F0FD),
        label: 'Facebook',
        url: item['facebook'] ?? '',
        isFirst: true,
      ),
      _SocialItem(
        icon: Icons.play_circle_filled_rounded,
        iconColor: const Color(0xFFEE0000),
        iconBg: const Color(0xFFFEECEC),
        label: 'YouTube',
        url: item['youtube'] ?? '',
      ),
      _SocialItem(
        icon: Icons.language_rounded,
        iconColor: AppColors.primary,
        iconBg: AppColors.primaryShade,
        label: 'เว็บไซต์',
        url: item['site'] ?? '',
        isLast: true,
      ),
    ];

    return _card(
      socials
          .expand(
            (s) => [
              InkWell(
                onTap: () => _launchUrl(s.url),
                borderRadius: BorderRadius.vertical(
                  top: s.isFirst ? const Radius.circular(16) : Radius.zero,
                  bottom: s.isLast ? const Radius.circular(16) : Radius.zero,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: s.iconBg,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(s.icon, size: 17, color: s.iconColor),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          s.label,
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Kanit',
                            color: AppColors.textDark,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.open_in_new_rounded,
                        size: 15,
                        color: AppColors.textgrey,
                      ),
                    ],
                  ),
                ),
              ),
              if (!s.isLast) _divider(),
            ],
          )
          .toList(),
    );
  }

  // ── Map placeholder ───────────────────────────────
  Widget _buildMapPlaceholder(Map<String, dynamic> item) {
    LatLng position = LatLng(
      double.tryParse(item['latitude'].toString()) ?? 0.0,
      double.tryParse(item['longitude'].toString()) ?? 0.0,
    );

    // Controller สำหรับกลับไปหา marker
    final Completer<GoogleMapController> _mapController = Completer();

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(target: position, zoom: 14),
              onMapCreated: (controller) {
                if (!_mapController.isCompleted) {
                  _mapController.complete(controller);
                }
              },
              markers: {
                Marker(markerId: const MarkerId('bangkok'), position: position),
              },

              // gesture
              zoomGesturesEnabled: true,
              scrollGesturesEnabled: true,
              rotateGesturesEnabled: true,
              tiltGesturesEnabled: true,
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                Factory<OneSequenceGestureRecognizer>(
                  () => EagerGestureRecognizer(),
                ),
              },

              // UI
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false, // ปิด เพราะชนกับปุ่มเรา
              compassEnabled: true,
              mapToolbarEnabled: false, // ปิด เพราะชนกับปุ่มเรา

              mapType: MapType.normal,
            ),
          ),

          // ปุ่มกลับหา Marker
          Positioned(
            bottom: 15,
            right: 15,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () async {
                final controller = await _mapController.future;
                controller.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(target: position, zoom: 14),
                  ),
                );
              },
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white60,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.my_location_rounded,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
            ),
          ),

          // ปุ่มนำทาง
          Positioned(
            bottom: 15,
            right: 70,
            left: 15,
            child: ElevatedButton.icon(
              onPressed: () {
                final lat = position.latitude;
                final lng = position.longitude;
                final url =
                    'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng';
                _launchUrl(url);
              },
              icon: const Icon(Icons.navigation_rounded, size: 20),
              label: const Text(
                'นำทาง',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  letterSpacing: 0.5,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primarysecond,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 4,
                shadowColor: AppColors.primarysecond.withOpacity(0.45),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shared helpers ────────────────────────────────
Widget _card(List<Widget> children) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(children: children),
  );
}

Widget _divider() =>
    const Divider(height: 1, indent: 62, color: AppColors.backgroundMain);

Widget _sectionLabel(String text) => Text(
  text,
  style: const TextStyle(
    fontSize: 12,
    fontFamily: 'Kanit',
    fontWeight: FontWeight.w500,
    color: AppColors.textgrey,
    letterSpacing: 0.3,
  ),
);

Widget _infoRow({
  required IconData icon,
  required Color iconColor,
  required Color iconBg,
  required String title,
  required String value,
  required VoidCallback onTap,
  bool isFirst = false,
  bool isLast = false,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.vertical(
      top: isFirst ? const Radius.circular(16) : Radius.zero,
      bottom: isLast ? const Radius.circular(16) : Radius.zero,
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    fontFamily: 'Kanit',
                    fontWeight: FontWeight.w500,
                    color: AppColors.textgrey,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'Kanit',
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _externalRow({
  required IconData icon,
  required Color iconColor,
  required Color iconBg,
  required String label,
  required VoidCallback onTap,
  bool isFirst = false,
  bool isLast = false,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.vertical(
      top: isFirst ? const Radius.circular(16) : Radius.zero,
      bottom: isLast ? const Radius.circular(16) : Radius.zero,
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'Kanit',
                color: AppColors.textDark,
              ),
            ),
          ),
          const Icon(
            Icons.open_in_new_rounded,
            size: 15,
            color: AppColors.textgrey,
          ),
        ],
      ),
    ),
  );
}

// ── Models ────────────────────────────────────────
class _SocialItem {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String label;
  final String url;
  final bool isFirst;
  final bool isLast;

  const _SocialItem({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.label,
    required this.url,
    this.isFirst = false,
    this.isLast = false,
  });
}
