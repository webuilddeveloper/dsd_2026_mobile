// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:dsd/blank_page/dialog_fail.dart';
import 'package:dsd/blank_page/textfield.dart';
import 'package:dsd/forgot.dart';
import 'package:dsd/interests.dart';
import 'package:dsd/menu.dart';
import 'package:dsd/policy.dart';
import 'package:dsd/register.dart';
import 'package:dsd/shared/api_provider.dart';
import 'package:dsd/shared/app_strings.dart';
// import 'package:dsd/shared/apple_login.dart';
// import 'package:dsd/shared/line_login.dart';
import 'package:dsd/style_theme.dart';
import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final storage = FlutterSecureStorage();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  late final AnimationController _animCtrl;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;
  bool isInterests = true;
  bool _loadingSubmit = false;
  String _thiaDCode = '';

  @override
  void initState() {
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
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut));
    _animCtrl.forward();
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _animCtrl.dispose();
    super.dispose();
  }

  final bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bottomPad = MediaQuery.of(context).padding.bottom;
    final language = AppStrings.of(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundMain,
      body: Stack(
        children: [
          // ─── Header background ────────────────────────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: size.height * 0.38,
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(36),
                  bottomRight: Radius.circular(36),
                ),
              ),
            ),
          ),

          // ─── Scrollable content ───────────────────────────────────────
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    24,
                    size.height * 0.025,
                    24,
                    bottomPad + 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // ── Logo + Title ──────────────────────────────────
                      Column(
                        children: [
                          Image.asset(
                            'assets/DSD/imgs/logo.png',
                            color: Colors.white,
                            width: 180,
                          ),
                          const SizedBox(height: 14),
                        ],
                      ),

                      // ── Login Card ────────────────────────────────────
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.07),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 4,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  language.login,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textDark,
                                    fontFamily: 'Kanit',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // Username
                            _buildLabel(language.user),
                            const SizedBox(height: 6),
                            buildTextField(
                              controller: _usernameController,
                              hint: language.please + language.user,
                              icon: Icons.person_outline_rounded,
                            ),
                            const SizedBox(height: 16),

                            // Password
                            _buildLabel(language.password),
                            const SizedBox(height: 6),
                            buildTextField(
                              controller: _passwordController,
                              hint: language.please + language.password,
                              icon: Icons.lock_outline_rounded,
                              obscure: _obscurePassword,
                              suffix: GestureDetector(
                                onTap:
                                    () => setState(
                                      () =>
                                          _obscurePassword = !_obscurePassword,
                                    ),
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    size: 18,
                                    color: AppColors.textgrey,
                                  ),
                                ),
                              ),
                            ),

                            // Forgot password
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ForgotPage(),
                                    ),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  '${language.forgot}?',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontFamily: 'Kanit',
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),

                            // Login button
                            SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                onPressed: _handleLogin,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  language.login,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Kanit',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              _callThaiID();
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              height: 50,
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: Color(0xFF0C0F4F),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    'assets/DSD/icon/iocn_thaid.png',
                                    width: 40,
                                    height: 40,
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    'เข้าสู่ระบบด้วย ThaID',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Kanit',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      // const SizedBox(height: 28),
                      // // ── Divider ───────────────────────────────────────
                      // Row(
                      //   children: [
                      //     const Expanded(
                      //       child: Divider(
                      //         color: AppColors.borderColor,
                      //         thickness: 1,
                      //       ),
                      //     ),
                      //     Padding(
                      //       padding: const EdgeInsets.symmetric(horizontal: 14),
                      //       child: Text(
                      //         'หรือเข้าสู่ระบบด้วย',
                      //         style: TextStyle(
                      //           color: AppColors.textgrey,
                      //           fontSize: 12,
                      //           fontFamily: 'Kanit',
                      //         ),
                      //       ),
                      //     ),
                      //     const Expanded(
                      //       child: Divider(
                      //         color: AppColors.borderColor,
                      //         thickness: 1,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // const SizedBox(height: 20),
                      // // ── Social buttons ────────────────────────────────
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     _buildSocialButton(
                      //       imagePath: 'assets/images/facebook.png',
                      //       onTap: () {},
                      //     ),
                      //     const SizedBox(width: 14),
                      //     _buildSocialButton(
                      //       imagePath: 'assets/images/google.png',
                      //       onTap: () {},
                      //     ),
                      //     const SizedBox(width: 14),
                      //     _buildSocialButton(
                      //       imagePath: 'assets/images/line.png',
                      //       onTap: () async {
                      //         final result = await loginLine();

                      //         final model = {
                      //           "username": result.userProfile?.userId ?? "",
                      //           "lineID": result.userProfile?.userId ?? "",
                      //           "email": result.accessToken.email ?? "",
                      //           "imageUrl":
                      //               result.userProfile?.pictureUrl ?? "",
                      //           "firstName":
                      //               result.userProfile?.displayName ?? "",
                      //           "lastName": "",
                      //         };

                      //         if (result.userProfile != null) {
                      //           // ยิง API ได้เลย
                      //           _handleSocail(model: model, category: "line");
                      //         } else {
                      //           print("Login failed");
                      //         }
                      //       },
                      //     ),
                      //     if (Platform.isIOS) ...[
                      //       const SizedBox(width: 14),
                      //       _buildSocialButton(
                      //         imagePath: 'assets/images/apple.png',
                      //         onTap: () async {
                      //           final credential = await loginApple();

                      //           if (credential != null) {
                      //             final model = {
                      //               "userId": credential.userIdentifier ?? "",
                      //               "email": credential.email,
                      //               "firstName": credential.givenName,
                      //               "lastName": credential.familyName,
                      //             };
                      //             _handleSocail(
                      //               model: model,
                      //               category: "apple",
                      //             );
                      //           } else {
                      //             print("Login failed");
                      //           }
                      //         },
                      //       ),
                      //     ],
                      //   ],
                      // ),
                      const SizedBox(height: 28),
                      // ── Sign up row ───────────────────────────────────
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            language.noAccount,
                            style: TextStyle(
                              color: AppColors.textgrey,
                              fontFamily: 'Kanit',
                              fontSize: 14,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RegsiterPage(),
                                ),
                              );
                            },
                            child: Text(
                              language.signUp,
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Kanit',
                                fontSize: 14,
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
        ],
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: GestureDetector(
            onTap: _isLoading ? null : () => Navigator.pop(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 13,
                  color: AppColors.textgrey,
                ),
                const SizedBox(width: 4),
                Text(
                  language.backToPreviousPage,
                  style: TextStyle(
                    color: AppColors.textgrey,
                    fontFamily: 'Kanit',
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    final storage = FlutterSecureStorage();
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    final language = AppStrings.of(context);
    if (username.isEmpty) {
      showDialogFail(
        context,
        title: language.failed,
        description: language.please + language.user,
        onConfirm: () {
          Navigator.pop(context);
        },
      );
      return;
    }

    if (password.isEmpty) {
      showDialogFail(
        context,

        title: language.failed,
        description: language.please + language.password,
        onConfirm: () {
          Navigator.pop(context);
        },
      );
      return;
    }

    try {
      final url = '${register}login';

      final result = await postapi(url, {
        'username': username,
        'password': password,
        'category': 'guest',
      });

      if (!mounted) return;

      // ✅ LOGIN SUCCESS
      if (result['status'] == 'S') {
        final data = result['objectData'] ?? {};

        await storage.write(key: 'token', value: result['jsonData']);
        await storage.write(key: 'dataUserLoginDDPM', value: jsonEncode(data));
        await storage.write(key: 'profileCode', value: data['code'] ?? '');
        await storage.write(key: 'username', value: data['username'] ?? '');
        await storage.write(
          key: 'profileImageUrl',
          value: data['imageUrl'] ?? '',
        );
        await storage.write(key: 'idcard', value: data['idcard'] ?? '');
        await storage.write(key: 'profileCategory', value: 'guest');
        await storage.write(
          key: 'profileFirstName',
          value: data['firstName'] ?? '',
        );
        await storage.write(
          key: 'profileLastName',
          value: data['lastName'] ?? '',
        );

        await readRegister();
        _goToPolicy();
      } else {
        // ❌ LOGIN FAIL
        showDialogFail(
          context,
          title: language.failed,
          description:
              (result['message'] != null &&
                      result['message'].toString().isNotEmpty)
                  ? result['message']
                  : language.loginFailed,
          onConfirm: () {
            Navigator.pop(context);
          },
        );
      }
    } catch (e) {
      print("LOGIN ERROR: $e");

      // ❌ NETWORK ERROR
      showDialogFail(
        context,
        title: language.failed,
        description: language.skipchangePassword5,
        onConfirm: () {
          Navigator.pop(context);
        },
      );
    } finally {
      if (mounted) {}
    }
  }

  Future<void> readRegister() async {
    print('------------- readRegister');
    final storage = FlutterSecureStorage();
    final profileCode = await storage.read(key: 'profileCode') ?? '';
    final result = await postapi('${registerV2}read', {"code": profileCode});
    print('profileCode : ${profileCode}');
    print('------------- readRegister status : ${result['status']}');
    if (result['status'] == 'S') {
      final data = result['objectData'];
      print(data);
      if (data.isNotEmpty) {
        isInterests = data[0]['isInterest'];
      }
    }
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

      _userData['idcard'] = idData['pid'];

      print('##################################');
      print(_userData);
      print(_userData.runtimeType);

      // Use _login instead of _register for login process
      _handleSocail(category: "thaid", model: _userData['thaiID']);
      // _login(_userData);
    } catch (e) {
      await prefs.remove('thaiDCode');
      await prefs.remove('thaiDState');
      Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด');
    }
  }

  _handleSocail({
    required Map<String, dynamic> model,
    required String category,
  }) async {
    final body = {
      "idcard": model['idcard'],
      "firstName": model['name'] ?? '',
      "lastName": model['lastname'] ?? '',
    };

    print('======================>> _handleSocail');
    final result = await postapi('$registerV2$category/login', body);

    if (result['status'] == 'S') {
      final data = result['objectData'] ?? {};

      await storage.write(key: 'token', value: result['jsonData']);
      await storage.write(key: 'dataUserLoginDDPM', value: jsonEncode(data));
      await storage.write(key: 'profileCode', value: data['code'] ?? '');
      await storage.write(key: 'username', value: data['username'] ?? '');
      await storage.write(
        key: 'profileImageUrl',
        value: data['imageUrl'] ?? '',
      );
      await storage.write(key: 'idcard', value: data['idcard'] ?? '');
      await storage.write(key: 'profileCategory', value: 'guest');
      await storage.write(
        key: 'profileFirstName',
        value: data['firstName'] ?? '',
      );
      await storage.write(
        key: 'profileLastName',
        value: data['lastName'] ?? '',
      );

      await readRegister();

      _goToPolicy();
    }
  }

  void _goToPolicy() {
    final nextPage = isInterests == false ? Interests(isEdit: false) : Menu();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => PolicyPage(nextPage: nextPage)),
      (route) => false,
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
        fontFamily: 'Kanit',
      ),
    );
  }

  Widget _buildSocialButton({
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Center(
          child: Image.asset(
            imagePath,
            width: 24,
            height: 24,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
