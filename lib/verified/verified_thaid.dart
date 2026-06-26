import 'dart:convert';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:dsd/blank_page/appbar.dart';
import 'package:dsd/style_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class verifiedThaiID extends StatefulWidget {
  const verifiedThaiID({super.key});

  @override
  State<verifiedThaiID> createState() => _verifiedThaiIDState();
}

class _verifiedThaiIDState extends State<verifiedThaiID>
    with SingleTickerProviderStateMixin {
  String _thiaDCode = '';
  bool _loadingSubmit = false;
  final storage = FlutterSecureStorage();

  @override
  void initState() {
    print('---------->>_verifiedThaiIDState');
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      setState(() {
        _thiaDCode = prefs.getString('thaiDCode') ?? '';
        if (_thiaDCode.isNotEmpty) {
          _loadingSubmit = true;
          _getToken();
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.backgroundMain,
        appBar: appBar(
          title: 'ยืนยันตัวตนด้วย ThaiD',
          rightBtn: false,
          backAction: () => Navigator.pop(context),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              20,
              20,
              MediaQuery.of(context).padding.bottom + 20,
            ),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.05),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    Center(
                      child: Image.asset(
                        'assets/images/verify_thai_id.png',
                        height: 140,
                      ),
                    ),

                    const SizedBox(height: 28),

                    const Text(
                      'ยืนยันตัวตน\nด้วยแอปพลิเคชัน ThaiD',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        height: 1.35,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      'เพื่อเข้าใช้งาน ดูใบรับรอง (Certificate)\nและเข้าร่วมการทดสอบหรืออบรมออนไลน์',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.7,
                        color: AppColors.textDark.withOpacity(.65),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Step
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xffF8F9FC),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),

                              const SizedBox(width: 12),
                              const Expanded(
                                child: Text(
                                  "กดปุ่ม \"ยืนยันตัวตน\"",
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  "ระบบจะเปิดแอป ThaiD",
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    Stack(
                      children: [
                        GestureDetector(
                          onTap: _loadingSubmit ? null : _callThaiID,
                          child: Container(
                            height: 56,
                            width: double.infinity,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color:
                                  _loadingSubmit
                                      ? AppColors.primaryShade
                                      : AppColors.primary,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(.25),
                                  blurRadius: 12,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: const Text(
                              'ยืนยันตัวตน',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),

                        if (_loadingSubmit)
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.primaryShade.withOpacity(.6),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              alignment: Alignment.center,
                              child: const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor: AlwaysStoppedAnimation(
                                    AppColors.textDark,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String getRandomString({int length = 10}) {
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length)),
      ),
    );
  }

  _callThaiID() async {
    print('---------->>_verified _callThaiID');
    try {
      String responseType = 'code';
      String clientId = 'b1lzRU9NcmxEWjFTdXRTMEtaZDhXaHFSTk0xc1hyc00';
      // String client_secret =
      //     'UVpJMVZhUWN4dXBDNk9wY0xJNm9tcjJKZHFTZUJCZXVGOUlISDRKRw';
      String redirectUri = 'https://gateway.we-builds.com/dsd/thaid';
      String base = 'https://imauth.bora.dopa.go.th/api/v2/oauth2/auth/';

      String state = '1${getRandomString()}';
      // String state = 'mobile';
      String scope = 'pid given_name family_name openid';
      String parameter =
          '?response_type=$responseType&client_id=$clientId&redirect_uri=$redirectUri&scope=$scope&state=$state';
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('thaiDState', state);
      await prefs.setString(
        'thaiDAction',
        'login',
      ); //verify รอแก้ Api ใช้ login ชั่วคร่าว
      await launchUrl(
        Uri.parse('$base$parameter'),

        mode: LaunchMode.externalApplication,
      );
      print('==================');
      print('$base$parameter');
      // _callLogin();
    } catch (ex) {
      Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด');
    }
  }

  _getToken() async {
    print('---------->>_verified _getToken');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      await prefs.remove('thaiDCode');
      await prefs.remove('thaiDState');

      String clientId = 'b1lzRU9NcmxEWjFTdXRTMEtaZDhXaHFSTk0xc1hyc00';
      String clientSecret =
          'UVpJMVZhUWN4dXBDNk9wY0xJNm9tcjJKZHFTZUJCZXVGOUlISDRKRw';
      String credentials = "$clientId:$clientSecret";
      String encoded = base64Url.encode(utf8.encode(credentials));

      Dio dio = Dio();

      var formData = FormData.fromMap({
        "grant_type": "authorization_code",
        "redirect_uri": 'https://gateway.we-builds.com/dsd/thaid',
        "code": _thiaDCode,
      });

      var res = await dio.post(
        'https://imauth.bora.dopa.go.th/api/v2/oauth2/token/',
        data: formData,
        options: Options(
          validateStatus: (_) => true,
          contentType: 'application/x-www-form-urlencoded',
          responseType: ResponseType.json,
          headers: {
            'Content-type': 'application/x-www-form-urlencoded',
            'Authorization': 'Basic $encoded',
          },
        ),
      );

      // Decode token to get user info
      Map<String, dynamic> idData = JwtDecoder.decode(res.data['id_token']);

      print('################# ID Data #################');
      print(idData);

      var _userData = {};

      _userData['thaiID'] = {
        'pid': idData['pid'],
        'name': idData['given_name'],
        'lastname': idData['family_name'],
      };

      _userData['firstName'] = idData['given_name'];
      _userData['lastName'] = idData['family_name'];

      _userData['idcard'] = idData['pid'];

      print('##################################');
      print(_userData);
      print(_userData.runtimeType);

      update(model: _userData['thaiID']);
    } catch (e) {
      await prefs.remove('thaiDCode');
      await prefs.remove('thaiDState');
      Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด');
    }
  }

  Future<void> update({required Map<String, dynamic> model}) async {
    final code = await storage.read(key: 'profileCode');
    print('code : ${code}');
    try {
      // final result = await postapi('${registerV2}update', {
      //   'code': code,
      //   'idcard': model['idcard'],
      //   'username': '',
      //   'password': '',
      //   'facebookID': '',
      //   'appleID': '',
      //   'googleID': '',
      //   'lineID': '',
      //   'email': '',
      //   'imageUrl': '',
      //   'category': '',
      //   'prefixName': '',
      //   'firstName': model['name'] ?? '',
      //   'lastName': model['lastname'] ?? '',
      //   'phone': '',
      //   'birthDay': '',
      //   'status': '',
      //   'platform': Platform.operatingSystem,
      //   'countUnit': '[]',
      // });

      // if (!mounted) return;
      // print('-----1-----> ${result['status']}');
      // if (result['status'] == 'S') {
      //   print('------2----> ${result['status']}');
      //   Navigator.of(context).pushAndRemoveUntil(
      //     MaterialPageRoute(builder: (_) => Menu()),
      //     (route) => false,
      //   );
      // } else {
      //   print('------3----> ${result['status']}');
      //   Fluttertoast.showToast(msg: 'อัปเดตข้อมูลไม่สำเร็จ');
      //   setState(() => _loadingSubmit = false);
      // }
    } catch (_) {
      print('------4----> ');
      if (!mounted) return;
      Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด');
      setState(() => _loadingSubmit = false);
    } finally {
      // if (mounted) setState(() => _isLoading = false);
    }
  }
}
