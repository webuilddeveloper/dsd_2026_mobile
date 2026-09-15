import 'package:dsd/blank_page/appbar.dart';
import 'package:dsd/calendar/calendar_source.dart';
import 'package:dsd/shared/app_strings.dart';
import 'package:dsd/shared/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CalendarDetail extends StatefulWidget {
  final CalendarEvent event;
  const CalendarDetail({super.key, required this.event});

  @override
  State<CalendarDetail> createState() => _CalendarDetailState();
}

class _CalendarDetailState extends State<CalendarDetail> {
  final _source = CalendarSource();
  CalendarEvent? _detail;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _source.close();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final detail = await _source.readDetail(widget.event);
      if (!mounted) return;
      setState(() {
        _detail = detail;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  Future<void> _openLink(String? href) async {
    if (href == null) return;
    final uri = CalendarSource.baseUri.resolve(href);
    if (!['https', 'http', 'tel', 'mailto'].contains(uri.scheme)) return;
    try {
      if (await launchUrl(uri, mode: LaunchMode.externalApplication)) return;
    } catch (_) {
      // Report failures without losing the event detail.
    }
    if (!mounted) return;
    final thai = context.read<LocaleProvider>().locale.languageCode == 'th';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(thai ? 'ไม่สามารถเปิดลิงก์ได้' : 'Unable to open link'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final thai = context.watch<LocaleProvider>().locale.languageCode == 'th';
    final event = _detail ?? widget.event;
    return Scaffold(
      appBar: appBar(
        title: AppStrings.of(context).calendar,
        backBtn: true,
        rightBtn: false,
        backAction: () => Navigator.pop(context),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            event.title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            calendarDate(event.start, thai) +
                (event.end == null
                    ? ''
                    : ' – ${calendarDate(event.end!, thai)}'),
          ),
          if (_loading)
            const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_detail == null) ...[
            const SizedBox(height: 16),
            Text(
              thai
                  ? 'โหลดรายละเอียดจากเว็บไซต์ไม่สำเร็จ'
                  : 'Unable to load event details',
            ),
            TextButton(
              onPressed: _load,
              child: Text(thai ? 'ลองใหม่' : 'Retry'),
            ),
          ] else ...[
            if (event.department.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(event.department),
            ],
            const Divider(height: 32),
            Html(
              data: event.description,
              onLinkTap: (url, _, _) => _openLink(url),
            ),
          ],
          TextButton.icon(
            onPressed: () => _openLink(CalendarSource.baseUri.toString()),
            icon: const Icon(Icons.open_in_new),
            label: Text(
              thai ? 'ดูปฏิทินบนเว็บไซต์ DSD' : 'Open DSD website calendar',
            ),
          ),
        ],
      ),
    );
  }
}
