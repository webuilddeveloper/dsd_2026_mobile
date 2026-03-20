import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';

const server = 'https://ksp.we-builds.com/ksp-api/';
const dsd_server = 'https://gateway.we-builds.com/dsd-e-api/';

//new
const newsApi = "${dsd_server}m/news/";
const newsCategoryApi = '${dsd_server}m/news/category/';

//Privilege
const privilegeApi = "${server}m/privilege/";
const privilegeCategoryApi = '${server}m/privilege/category/';

//eventCalendarApi
const eventCalendarApi = '${dsd_server}m/eventCalendar//';

Future<dynamic> postDio(String url, dynamic criteria) async {
  // print(url);
  // print(criteria);
  final storage = FlutterSecureStorage();
  final profileCode = await storage.read(key: 'profileCode9');

  if (profileCode != '' && profileCode != null) {
    criteria = {'profileCode': profileCode, ...criteria};
  }

  Dio dio = Dio();
  var response = await dio.post(url, data: criteria);
  // print(response.data.toString());
  // print(response.data['objectData'].toString());
  return Future.value(response.data['objectData']);
}
