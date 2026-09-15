import 'package:dsd/blank_page/appbar.dart';
import 'package:dsd/shared/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';

/// Displays PDFs directly instead of relying on platform WebView PDF support.
class PdfViewerPage extends StatefulWidget {
  const PdfViewerPage({super.key, required this.url, required this.title});

  final String url;
  final String title;

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  bool _failed = false;
  int _attempt = 0;

  Future<void> _openExternally() async {
    try {
      if (await launchUrl(
        Uri.parse(widget.url),
        mode: LaunchMode.externalApplication,
      )) {
        return;
      }
    } catch (_) {
      // Keep the reader open so the user can retry.
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
    final attempt = _attempt;
    return Scaffold(
      appBar: appBar(
        title: widget.title,
        backBtn: true,
        rightBtn: false,
        backAction: () => Navigator.pop(context),
      ),
      body: SafeArea(
        child:
            _failed
                ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.picture_as_pdf_outlined, size: 48),
                        const SizedBox(height: 16),
                        Text(
                          thai
                              ? 'โหลดไฟล์ PDF ไม่สำเร็จ'
                              : 'Unable to load PDF',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        FilledButton(
                          onPressed:
                              () => setState(() {
                                _failed = false;
                                _attempt++;
                              }),
                          child: Text(thai ? 'ลองใหม่' : 'Retry'),
                        ),
                        TextButton(
                          onPressed: _openExternally,
                          child: Text(
                            thai ? 'เปิดด้วยแอปอื่น' : 'Open externally',
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                : SfPdfViewer.network(
                  widget.url,
                  key: ValueKey(attempt),
                  canShowPageLoadingIndicator: true,
                  onDocumentLoadFailed: (_) {
                    if (!mounted || attempt != _attempt) return;
                    setState(() => _failed = true);
                  },
                ),
      ),
    );
  }
}
