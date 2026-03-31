import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

const server = 'https://ksp.we-builds.com/ksp-api/';

const dsd_server = 'https://gateway.we-builds.com/dsd-e-api/';

const serverUpload =
    'https://khubdeedlt.we-builds.com/khubdeedlt-document/upload';

//new
const newsApi = "${dsd_server}m/news/";
const newsCategoryApi = '${dsd_server}m/news/category/';
const newsGallery = '${dsd_server}m/news/gallery/';

//Privilege
const privilegeApi = "${dsd_server}m/privilege/";
const privilegeCategoryApi = '${dsd_server}m/privilege/category/';
const privilegeGallery = '${dsd_server}m/privilege/gallery/';

//eventCalendarApi
const eventCalendarApi = '${dsd_server}m/eventCalendar//';
const eventCalendarGallery = '${dsd_server}m/eventcalendar/gallery/';

//knowledge
const knowledgeApi = '${dsd_server}m/knowledge/';
const knowledgeCategoryApi = '${dsd_server}m/knowledge/category/';

//skilledLaborApi
const skilledLaborApi = '${dsd_server}m/skilledLabor/';
const sendskill = '${dsd_server}m/skilledLabor/register/';

//trainingApi
const trainingApi = '${dsd_server}m/training/';
const sendtraining = '${dsd_server}m/training/register/';

//register
const register = '${dsd_server}m/Register/'; 
const registerV2 = '${dsd_server}m/v2/Register/';

Future<dynamic> postDio(String url, dynamic criteria) async {
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

Future<dynamic> postLoginRegister(String url, dynamic criteria) async {
  var body = json.encode(criteria);
  var response = await http.post(
    Uri.parse(url),
    body: body,
    headers: {"Accept": "application/json", "Content-Type": "application/json"},
  );

  print(response.statusCode);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data;
  } else {
    throw Exception('Failed to connect server');
  }
}

Future<String> uploadImage(XFile file) async {
  Dio dio = Dio();

  String fileName = file.path.split('/').last;
  FormData formData = FormData.fromMap({
    "ImageCaption": "flutter",
    "Image": await MultipartFile.fromFile(file.path, filename: fileName),
  });

  var response = await dio.post(serverUpload, data: formData);

  return response.data['imageUrl'];
}
