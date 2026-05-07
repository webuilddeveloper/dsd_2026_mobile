import 'package:url_launcher/url_launcher.dart';

Future<void> launchURL(String? url) async {
  if (url == null || url.isEmpty) return;

  Uri uri = Uri.parse(url);

  if (!uri.isAbsolute) {
    uri = Uri.parse('https://$url');
  }

  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $uri';
  }
}
