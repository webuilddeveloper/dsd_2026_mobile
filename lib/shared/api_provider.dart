import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

// ignore: constant_identifier_names
// const dsd_server = 'https://untoasted-float-roving.ngrok-free.dev/';
const dsd_server = 'https://gateway.we-builds.com/dsd-e-api/';
// const dsd_server = 'http://localhost:8700/';

const serverUpload =
    'https://khubdeedlt.we-builds.com/khubdeedlt-document/upload';

//splash
const splash = "$dsd_server/splash/";

// Getcert
const getCert = "$dsd_server/m/Register/GetCret";
const getCretTraining = "$dsd_server/m/Register/GetCretTraining";
const getCretTesting = "$dsd_server/m/Register/GetCretTesting";
const getCretEvaluations = "$dsd_server/m/Register/GetCretKnowledge";

//new
const newsApi = "${dsd_server}m/news/";
const newsCategoryApi = '${dsd_server}m/news/category/';
const newsGallery = '${dsd_server}m/news/gallery/';

//Privilege
const privilegeApi = "${dsd_server}m/privilege/";
const privilegeCategoryApi = '${dsd_server}m/privilege/category/';
const privilegeGallery = '${dsd_server}m/privilege/gallery/';

//eventCalendarApi
const eventCalendarApi = '${dsd_server}m/eventCalendar/';
const eventCalendarGallery = '${eventCalendarApi}gallery/';
const eventCalendarCategory = '${eventCalendarApi}category/';

//knowledge
const knowledgeApi = '${dsd_server}m/knowledge/';
const knowledgeCategoryApi = '${dsd_server}m/knowledge/category/';

//skilledLaborApi
const skilledLaborApi = '${dsd_server}m/skilledLabor/';
const sendskill = '${dsd_server}m/skilledLabor/register/';

//trainingApi
const trainingApi = '${dsd_server}m/training/';
const sendtraining = '${dsd_server}m/training/register/';
const trainingCategoryApi = '${trainingApi}category/';

//testingApi
const testingApi = '${dsd_server}m/Testing/';
const sendtesting = '${dsd_server}m/testing/register/';
const testingCategoryApi = '${testingApi}category/';

//register
const register = '${dsd_server}m/Register/';
const registerV2 = '${dsd_server}m/v2/Register/';

// aboutUs
const aboutUs = '${dsd_server}aboutUs/';

// policy
const policyApi = '${dsd_server}m/policy/';

Future<dynamic> postDio(String url, Map<String, dynamic> criteria) async {
  const storage = FlutterSecureStorage();
  final profileCode = await storage.read(key: 'profileCode9');

  final requestData = {
    if (profileCode != null && profileCode.isNotEmpty)
      'profileCode': profileCode,
    ...criteria,
  };

  try {
    final dio = Dio();

    final response = await dio.post(url, data: requestData);

    final data = response.data;

    // debugPrint('✅ postDio: $url - $requestData');
    // debugPrint('✅ HTTP status: ${response.statusCode}');
    // debugPrint('✅ API status: ${data['status']}');

    if (data is! Map) {
      throw Exception('รูปแบบข้อมูลจาก API ไม่ถูกต้อง');
    }

    if (data['status'] == 'S') {
      return data['objectData'];
    }

    final message = data['message']?.toString() ?? 'ไม่สามารถดำเนินการได้';

    throw Exception(message);
  } on DioException catch (error) {
    final responseData = error.response?.data;

    final message =
        responseData is Map ? responseData['message']?.toString() : null;

    throw Exception(message ?? 'ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ได้');
  }
}


Future<dynamic> postapi(String url, dynamic criteria) async {
  var body = json.encode(criteria);
  var response = await http.post(
    Uri.parse(url),
    body: body,
    headers: {"Accept": "application/json", "Content-Type": "application/json"},
  );

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
