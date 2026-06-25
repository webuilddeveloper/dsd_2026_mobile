import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:dsd/blank_page/appbar.dart';
import 'package:dsd/shared/api_provider.dart';
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
          title: 'ยืนยัตัวตนด้วย ThaID',
          rightBtn: false,
          backAction: () => Navigator.pop(context),
        ),
        body: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom,
            left: 20,
            right: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              Center(
                child: Image.asset(
                  'assets/images/verify_thai_id.png',
                  height: 166,
                  width: 205,
                ),
              ),

              const SizedBox(height: 28),

              const Text(
                'ยืนยันตัวตน\nด้วยแอปพลิเคชัน ThaiD',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                  height: 1.35,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'ยืนยันตัวตนเพื่อใช้งานดูใบรับรอง (Certificate) หรือเข้าร่วมการทดสอบและอบรมออนไลน์',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textgrey,
                  height: 1.75,
                ),
              ),

              const Spacer(),

              Stack(
                children: [
                  GestureDetector(
                    onTap: _loadingSubmit ? null : _callThaiID,
                    child: Container(
                      height: 52,
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color:
                            _loadingSubmit
                                ? AppColors.primaryShade
                                : AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'ยืนยันตัวตน',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                  ),
                  if (_loadingSubmit)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primaryShade.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(12),
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

              const SizedBox(height: 24),
            ],
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
      String client_secret =
          'UVpJMVZhUWN4dXBDNk9wY0xJNm9tcjJKZHFTZUJCZXVGOUlISDRKRw';
      String redirectUri = 'https://gateway.we-builds.com/dsd/thaid';
      String base = 'https://imauth.bora.dopa.go.th/api/v2/oauth2/auth/';
      // Random string for state, '1' for login.
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
      ); // Set state to 'login' instead of 'create'
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

      // Prepare data for login instead of registration
      var _userData = {};

      _userData['thaiID'] = {
        'pid': idData['pid'],
        'name': idData['given_name'],
        'lastname': idData['family_name'],
      };

      _userData['firstName'] = idData['given_name'];
      _userData['lastName'] = idData['family_name'];
      // _userData['sex'] = idData['gender'];
      _userData['idcard'] = idData['pid'];

      print('##################################');
      print(_userData);
      print(_userData.runtimeType);

      Update(model: _userData['thaiID']);
    } catch (e) {
      await prefs.remove('thaiDCode');
      await prefs.remove('thaiDState');
      Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด');
    }
  }

  Future<void> Update({required Map<String, dynamic> model}) async {
    final code = await storage.read(key: 'profileCode');
    try {
      final result = await postapi('${registerV2}update', {
        'code': code,
        'idcard': model['idcard'],
        'username': '',
        'password': '',
        'facebookID': '',
        'appleID': '',
        'googleID': '',
        'lineID': '',
        'email': '',
        'imageUrl': '',
        'category': '',
        'prefixName': '',
        'firstName': model['name'] ?? '',
        'lastName': model['lastname'] ?? '',
        'phone': '',
        'birthDay': '',
        'status': '',
        'platform': Platform.operatingSystem,
        'countUnit': '[]',
      });

      if (!mounted) return;

      final isSuccess = result['status'] == 'S';
      print('--------> isSuccess');
      // showCustomDialog(
      //   context,
      //   title: isSuccess ? language.successfully : language.failed,
      //   description:
      //       isSuccess
      //           ? language.updateSuccess
      //           : (result['message']?.isNotEmpty == true
      //               ? result['message']
      //               : language.updateFailed),
      //   onConfirm: () => Navigator.pop(context),
      // );
    } catch (_) {
      if (!mounted) return;
      // showCustomDialog(
      //   context,
      //   title: language.failed,
      //   description: language.skipchangePassword5,
      //   onConfirm: () => Navigator.pop(context),
      // );
    } finally {
      // if (mounted) setState(() => _isLoading = false);
    }
  }
}
