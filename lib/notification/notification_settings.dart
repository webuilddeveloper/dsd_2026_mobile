import 'package:dsd/blank_page/appbar.dart';
import 'package:dsd/shared/app_strings.dart';
import 'package:dsd/style_theme.dart';
import 'package:flutter/material.dart';
import 'package:dsd/notification/notification_preferences.dart';
import 'package:dsd/shared/locale_provider.dart';
import 'package:provider/provider.dart';

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({super.key, this.preferences});
  final NotificationPreferences? preferences;

  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  late final NotificationPreferences _preferences;

  @override
  void initState() {
    super.initState();
    _preferences = widget.preferences ?? NotificationPreferences.shared;
    _preferences.addListener(_changed);
    _preferences.load();
  }

  void _changed() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _preferences.removeListener(_changed);
    super.dispose();
  }

  Future<void> _toggle(String key, bool value) async {
    try {
      await _preferences.setValue(key, value);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('บันทึกการตั้งค่าไม่สำเร็จ กรุณาลองอีกครั้ง'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final language = AppStrings.of(context);
    final thai = context.watch<LocaleProvider>().locale.languageCode == 'th';
    return Scaffold(
      backgroundColor: AppColors.backgroundMain,
      appBar: appBar(
        title: language.notificationSettings,
        backBtn: true,
        rightBtn: false,
        backAction: () => Navigator.pop(context),
      ),
      body:
          !_preferences.ready
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
                top: false,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
                  children: [
                    // _sectionCard(
                    //   title: language.generalNoti,
                    //   items: [
                    //     _SwitchItem(
                    //       label: language.enablenoti,
                    //       subtitle: language.skipenablenoti,
                    //       value: _preferences.all,
                    //       onChanged: (v) => _toggle('notif_all', v),
                    //     ),
                    //     _SwitchItem(
                    //       label: language.notificationsound,
                    //       subtitle: language.skipnotisound,
                    //       value: _preferences.value('notif_sound'),
                    //       onChanged: _preferences.all ? (v) => _toggle('notif_sound', v) : null,
                    //     ),
                    //     _SwitchItem(
                    //       label: language.vibration,
                    //       subtitle: language.skipvibration,
                    //       value: _preferences.value('notif_vibration'),
                    //       onChanged: _preferences.all ? (v) => _toggle('notif_vibration', v) : null,
                    //     ),
                    //   ],
                    // ),
                    // const SizedBox(height: 12),
                    _sectionCard(
                      title: language.typenoti,
                      items: [
                        for (final type in notificationTypes)
                          _SwitchItem(
                            label: type[thai ? 'name' : 'nameEN']!,
                            subtitle:
                                thai
                                    ? 'แสดงหมวดและรายการแจ้งเตือน${type['name']}'
                                    : 'Show ${type['nameEN']!.toLowerCase()} notifications',
                            value: _preferences.typeEnabled(type['type']!),
                            onChanged: (v) => _toggle(type['key']!, v),
                          ),
                      ],
                    ),
                  ],
                ),
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
          ...items.map((item) => _buildRow(item)),
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
                activeThumbColor: Colors.white,
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
  final ValueChanged<bool>? onChanged;

  const _SwitchItem({
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });
}
