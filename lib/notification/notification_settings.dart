import 'package:dsd/blank_page/appbar.dart';
import 'package:dsd/style_theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({super.key});

  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  // ── General ──
  bool _allNotifications = true;
  bool _sound = true;
  bool _vibration = false;

  // ── Type ──
  bool _training = true;
  bool _news = false;
  bool _system = true;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _allNotifications = prefs.getBool('notif_all') ?? true;
      _sound = prefs.getBool('notif_sound') ?? true;
      _vibration = prefs.getBool('notif_vibration') ?? false;
      _training = prefs.getBool('notif_training') ?? true;
      _news = prefs.getBool('notif_news') ?? false;
      _system = prefs.getBool('notif_system') ?? true;
    });
  }

  Future<void> _savePrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notif_all', _allNotifications);
    await prefs.setBool('notif_sound', _sound);
    await prefs.setBool('notif_vibration', _vibration);
    await prefs.setBool('notif_training', _training);
    await prefs.setBool('notif_news', _news);
    await prefs.setBool('notif_system', _system);
  }

  void _toggle(bool value, void Function(bool) setter) {
    setState(() => setter(value));
    _savePrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundMain,
      appBar: appBar(
        title: 'ตั้งค่าการแจ้งเตือน',
        backBtn: true,
        rightBtn: false,
        backAction: () => Navigator.pop(context),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
        children: [
          _sectionCard(
            title: 'การแจ้งเตือนทั่วไป',
            items: [
              _SwitchItem(
                label: 'รับการแจ้งเตือนทั้งหมด',
                subtitle: 'เปิด/ปิดการแจ้งเตือนทั้งหมด',
                value: _allNotifications,
                onChanged: (v) => _toggle(v, (x) => _allNotifications = x),
              ),
              _SwitchItem(
                label: 'เสียงแจ้งเตือน',
                subtitle: 'เล่นเสียงเมื่อมีการแจ้งเตือน',
                value: _sound,
                onChanged: (v) => _toggle(v, (x) => _sound = x),
              ),
              _SwitchItem(
                label: 'การสั่น',
                subtitle: 'สั่นเมื่อมีการแจ้งเตือน',
                value: _vibration,
                onChanged: (v) => _toggle(v, (x) => _vibration = x),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _sectionCard(
            title: 'ประเภทการแจ้งเตือน',
            items: [
              _SwitchItem(
                label: 'การอบรม',
                subtitle: 'แจ้งเตือนหลักสูตรใหม่และกำหนดการ',
                value: _training,
                onChanged: (v) => _toggle(v, (x) => _training = x),
              ),
              _SwitchItem(
                label: 'ข่าวสารและประกาศ',
                subtitle: 'ข่าวสารจากหน่วยงาน',
                value: _news,
                onChanged: (v) => _toggle(v, (x) => _news = x),
              ),
              _SwitchItem(
                label: 'การแจ้งเตือนระบบ',
                subtitle: 'อัปเดตและการบำรุงรักษาระบบ',
                value: _system,
                onChanged: (v) => _toggle(v, (x) => _system = x),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    required List<_SwitchItem> items,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 16,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Kanit',
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),
          ...items.map((item) => _buildRow(item)).toList(),
        ],
      ),
    );
  }

  Widget _buildRow(_SwitchItem item) {
    return Column(
      children: [
        const Divider(height: 1, color: AppColors.backgroundMain),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.label,
                      style: const TextStyle(
                        fontSize: 13,
                        fontFamily: 'Kanit',
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.subtitle,
                      style: const TextStyle(
                        fontSize: 11,
                        fontFamily: 'Kanit',
                        color: AppColors.textgrey,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: item.value,
                onChanged: item.onChanged,
                activeColor: Colors.white,
                activeTrackColor: AppColors.primary,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: const Color(0xFFD3D1C7),
                trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SwitchItem {
  final String label;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchItem({
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });
}
