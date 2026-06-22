import 'package:url_launcher/url_launcher.dart';

Future<void> launchURL(String? url) async {
  if (url == null || url.isEmpty) return;

  Uri uri = Uri.parse(url);

  if (!uri.isAbsolute) {
    uri = Uri.parse('https://$url');
    LaunchMode.inAppBrowserView;
  }

  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $uri';
  }
}

/*============================>> BUILD DSD URL <<============================ */
String buildDsdUrl(Map<String, dynamic> item) {
  final uri =
      Uri.https('www.dsd.go.th', '/DSD/EserviceWebRegister/TrainSkillCard', {
        'PERIOD': item['period'].toString(),
        'TRAINING_ID': item['trainingId'],
        'SITE': item['site'],
        'NAME_THAI': item['course'],
        'DATESTART': item['dsdStartDate'],
        'ENDDATE': item['dsdEndDate'],
      });

  return uri.toString();
}
