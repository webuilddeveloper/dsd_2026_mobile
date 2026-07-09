import 'package:dsd/blank_page/appbar.dart';
import 'package:dsd/shared/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final String url;
  final String title;

  const WebViewPage({super.key, required this.url, required this.title});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController controller;

  void goBack() {
    Navigator.pop(context, false);
  }

  @override
  void initState() {
    super.initState();

    controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    final language = AppStrings.of(context);
    return Scaffold(
      appBar: appBar(
        title: widget.title,
        backBtn: true,
        rightBtn: false,
        backAction: () => goBack(),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
