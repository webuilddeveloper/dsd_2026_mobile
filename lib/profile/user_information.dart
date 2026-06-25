import 'package:dsd/blank_page/appbar.dart';
import 'package:dsd/blank_page/dialog_fail.dart';
import 'package:dsd/interests.dart';
import 'package:dsd/license/license_page.dart';
import 'package:dsd/notification/notification_settings.dart';
import 'package:dsd/profile/about_us.dart';
import 'package:dsd/profile/change_password.dart';
import 'package:dsd/profile/edit_user_information.dart';
import 'package:dsd/profile/language_page.dart';
import 'package:dsd/shared/api_provider.dart';
import 'package:dsd/shared/app_strings.dart';
import 'package:dsd/shared/line_login.dart';

import 'package:dsd/style_theme.dart';
import 'package:dsd/training/traning_history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserInformationPage extends StatefulWidget {
  final Function(int)? onTabChange;

  const UserInformationPage({super.key, required this.onTabChange});

  @override
  State<UserInformationPage> createState() => _UserInformationPageState();
}

class _UserInformationPageState extends State<UserInformationPage> {
  void goBack() {
    widget.onTabChange?.call(0);
  }

  final storage = FlutterSecureStorage();
  String _imageUrl = '';
  bool? isCert;

  final txtFirstName = TextEditingController();
  final txtLastName = TextEditingController();

  @override
  void initState() {
    super.initState();
    _registerRead();
  }

  @override
  void dispose() {
    txtFirstName.dispose();
    txtLastName.dispose();

    super.dispose();
  }

  Future<void> _registerRead() async {
    // var value = await storage.read(key: 'dataUserLoginDDPM') ?? ''; // local
    final _code = await storage.read(key: 'profileCode');
    final value = await postapi('${register}read', {"code": _code}); // api

    if (value.isNotEmpty) {
      try {
        var user = value['objectData'][0];

        setState(() {
          _imageUrl = user['imageUrl'] ?? '';
          txtFirstName.text = user['firstName'] ?? '';
          txtLastName.text = user['lastName'] ?? '';
          isCert = user['isCert'] ?? '';
        });
      } catch (_) {}
    }
  }

  logout(BuildContext context) async {
    final storage = FlutterSecureStorage();
    storage.deleteAll();
    var profileCategory = await storage.read(key: 'profileCategory');
    if (profileCategory != '' && profileCategory != null) {
      switch (profileCategory) {
        case 'facebook':
          // logoutFacebook();
          // logoutFacebook();
          break;
        case 'google':
          // logoutGoogle();
          break;
        case 'line':
          logoutLine();
          break;
        default:
      }
    }
    widget.onTabChange?.call(0);
  }

  Future<void> deleteAccount(BuildContext context) async {
    final storage = FlutterSecureStorage();
    final code = await storage.read(key: 'profileCode');
    final response = await postapi('${register}delete', {"code": code});

    if (response != null && response['status'] == 'S') {
      print("✅ Delete success");
      await storage.deleteAll();
      widget.onTabChange?.call(0);
    } else {
      print("❌ Delete failed: ${response?['message']}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final language = AppStrings.of(context); // ← ดึง strings ตาม locale

    return Scaffold(
      backgroundColor: AppColors.backgroundMain,
      appBar: appBar(
        title: language.titlerofile,
        backBtn: true,
        rightBtn: false,
        backAction: () => goBack(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: MediaQuery.of(context).size.height * 0.12,
            bottom: MediaQuery.of(context).size.height * 0.15,
          ),
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none, // ให้วงกลมล้นออกมาได้
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 90,
                        bottom: 30,
                        left: 16,
                        right: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: AlignmentGeometry.center,
                            child: Text(
                              '${txtFirstName.text} ${txtLastName.text}',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(
                            // 'บัญชีของฉัน',
                            language.titleaccount,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 16),
                          _rowtxt(
                            title: language.useraccount,
                            ontap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => EditUserInformationPage(),
                                ),
                              ).then((_) {
                                _registerRead(); // เรียกใหม่ตอนกลับมา
                              });
                            },
                          ),
                          SizedBox(height: 8),
                          isCert == true
                              ? _rowtxt(
                                title: language.workhistory,
                                ontap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PageLicense(),
                                    ),
                                  );
                                },
                              )
                              : SizedBox(),
                          SizedBox(height: 8),
                          const Divider(color: AppColors.backgroundMain),
                          SizedBox(height: 8),
                          _rowtxt(
                            title: language.changePassword,
                            ontap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChangePassword(),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 32),
                          Text(
                            language.activities,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          // SizedBox(height: 16),
                          // _rowtxt(title: 'การถูกใจ', ontap: () {}),
                          // SizedBox(height: 8),
                          // const Divider(color: AppColors.backgroundMain),
                          SizedBox(height: 8),
                          _rowtxt(
                            title: language.trainingapplication,
                            ontap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TrainingHistory(),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 8),
                          _rowtxt(
                            title: language.interest,
                            ontap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Interests(isEdit: true),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 8),
                          const Divider(color: AppColors.backgroundMain),
                          SizedBox(height: 8),
                          SizedBox(height: 32),
                          Text(
                            language.settings,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 16),
                          _rowtxt(
                            title: language.setupnoti,
                            ontap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NotificationSettings(),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 8),
                          const Divider(color: AppColors.backgroundMain),
                          SizedBox(height: 8),
                          _rowtxt(
                            title: language.changelanguage,
                            ontap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LanguagePage(),
                                ),
                              );
                            },
                          ),

                          SizedBox(height: 8),
                          const Divider(color: AppColors.backgroundMain),
                          SizedBox(height: 8),
                          _rowtxt(
                            title: language.aboutUs,
                            ontap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AboutUs(),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 8),
                          const Divider(color: AppColors.backgroundMain),
                          SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),

                  // รูปโปรไฟล์
                  Positioned(
                    top: -70,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            height: 140,
                            width: 140,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(75),
                              border: Border.all(width: 6, color: Colors.white),
                              color: AppColors.primary,
                            ),
                            child: ClipOval(
                              child:
                                  _imageUrl.isNotEmpty && _imageUrl != ''
                                      ? Image.network(
                                        _imageUrl,
                                        fit: BoxFit.cover,
                                      )
                                      : Image.asset(
                                        'assets/DSD/imgs/profile.png',
                                        fit: BoxFit.cover,
                                      ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    showCustomDialog(
                      context,
                      title: language.confirmDeleteAccountTitle,
                      description: language.confirmDeleteAccountDescription,
                      onConfirm: () {
                        deleteAccount(context);
                      },
                    );
                  },
                  child: Text(
                    language.deleteaccount,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  logout(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFF6C4099), width: 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: EdgeInsetsGeometry.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    child: Text(
                      language.logout,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6C4099),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InkWell _rowtxt({required String title, required VoidCallback ontap}) {
    return InkWell(
      onTap: () => ontap(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
          ),
          Icon(Icons.arrow_forward_ios, color: AppColors.primary),
        ],
      ),
    );
  }
}
