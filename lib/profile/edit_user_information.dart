import 'dart:io';
import 'package:dsd/blank_page/dialog_fail.dart';
import 'package:dsd/blank_page/textfield.dart';
import 'package:dsd/shared/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dsd/blank_page/appbar.dart';
import 'package:dsd/style_theme.dart';

class EditUserInformationPage extends StatefulWidget {
  const EditUserInformationPage({super.key});

  @override
  State<EditUserInformationPage> createState() =>
      _EditUserInformationPageState();
}

class _EditUserInformationPageState extends State<EditUserInformationPage> {
  final storage = FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();

  String _imageUrl = '';
  XFile? _pickedImage;

  final bool _isLoading = false;

  final txtPrefixName = TextEditingController();
  final txtFirstName = TextEditingController();
  final txtLastName = TextEditingController();
  final txtEmail = TextEditingController();
  final txtPhone = TextEditingController();
  final txtUsername = TextEditingController();
  final txtPassword = TextEditingController();
  final txtIdcard = TextEditingController();
  final txtBirthday = TextEditingController();

  @override
  void initState() {
    super.initState();
    _registerRead();
  }

  @override
  void dispose() {
    txtPrefixName.dispose();
    txtFirstName.dispose();
    txtLastName.dispose();
    txtEmail.dispose();
    txtPhone.dispose();
    txtUsername.dispose();
    txtPassword.dispose();
    txtIdcard.dispose();
    txtBirthday.dispose();
    super.dispose();
  }

  Future<void> _registerRead() async {
    // var value = await storage.read(key: 'dataUserLoginDDPM') ?? ''; // local
    final _code = await storage.read(key: 'profileCode');
    final value = await postLoginRegister('${register}read', {
      "code": _code,
    }); // api

    if (value.isNotEmpty) {
      try {
        var user = value['objectData'][0];
        setState(() {
          _imageUrl = user['imageUrl'] ?? '';
          txtPrefixName.text = user['prefixName'] ?? '';
          txtFirstName.text = user['firstName'] ?? '';
          txtLastName.text = user['lastName'] ?? '';
          txtEmail.text = user['email'] ?? '';

          txtPhone.text = user['phone'] ?? '';
          txtUsername.text = user['username'] ?? '';
          txtPassword.text = user['password'] ?? '';
          txtIdcard.text = user['idcard'] ?? '';
          txtBirthday.text = user['birthDay'] ?? '';
        });
      } catch (_) {}
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final img = await ImagePicker().pickImage(source: source);

    if (img != null) {
      setState(() {
        _pickedImage = img;
      });
      _upload();
    }
  }

  void _upload() async {
    if (_pickedImage == null) return;

    uploadImage(_pickedImage!)
        .then((res) {
          setState(() {
            _imageUrl = res;
          });
        })
        .catchError((err) {
          print(err);
        });
  }

  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (_) => SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_library_outlined),
                  title: const Text('อัลบั้มรูปภาพ'),
                  onTap: () {
                    _pickImage(ImageSource.gallery);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_camera_outlined),
                  title: const Text('กล้องถ่ายรูป'),
                  onTap: () {
                    _pickImage(ImageSource.camera);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildProfileImage() {
    if (_pickedImage != null) {
      return Image.file(File(_pickedImage!.path), fit: BoxFit.cover);
    } else if (_imageUrl.isNotEmpty) {
      return Image.network(_imageUrl, fit: BoxFit.cover);
    } else {
      return Image.asset('assets/DSD/imgs/profile.png', fit: BoxFit.cover);
    }
  }

  Future<void> _submitUpdate() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final code = await storage.read(key: "profileCode");
    print(txtPassword.text);

    try {
      final result = await postLoginRegister('${register}update', {
        'code': code,
        'idcard': txtIdcard.text,
        'username': txtUsername.text,
        'password': txtPassword.text,
        'facebookID': "",
        'appleID': "",
        'googleID': "",
        'lineID': "",
        'email': txtEmail.text,
        'imageUrl': _imageUrl,
        'category': "guest",
        'prefixName': txtPrefixName.text,
        'firstName': txtFirstName.text,
        'lastName': txtLastName.text,
        'phone': txtPhone.text,
        'birthDay': txtBirthday.text,
        'status': "N",
        'platform': Platform.operatingSystem.toString(),
        'countUnit': "[]",
      });

      if (!mounted) return;
      if (result['status'] == 'S') {
        // ✅ สมัครสำเร็จ
        showCustomDialog(
          context,
          title: 'บันทึกสำเร็จ',
          description: "ข้อมูลของคุณได้รับการอัปเดตเรียบร้อยแล้ว",
          onConfirm: () {
            Navigator.pop(context);
          },
        );
      } else {
        showCustomDialog(
          context,
          title: 'เกิดข้อผิดพลาด',
          description:
              (result['message'] != null && result['message'].isNotEmpty)
                  ? result['message']!
                  : 'ไม่สามารถบันทึกข้อมูลได้ กรุณาลองใหม่อีกครั้ง',
          onConfirm: () {
            Navigator.pop(context);
          },
        );
      }
    } catch (e) {
      showCustomDialog(
        context,
        title: 'เกิดข้อผิดพลาด',
        description: 'ไม่สามารถเชื่อมต่อเซิร์ฟเวอร์ได้ กรุณาลองใหม่อีกครั้ง',
        onConfirm: () {
          Navigator.pop(context);
        },
      );
    } finally {
      if (mounted) {
        setState(() {});
      }
    }
  }

  void goBack() => Navigator.pop(context);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundMain,
      appBar: appBar(
        title: 'บัญชีผู้ใช้งาน',
        backBtn: true,
        rightBtn: false,
        backAction: goBack,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: MediaQuery.of(context).size.height * 0.12,
            bottom: MediaQuery.of(context).size.height * 0.1,
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // ─── Card หลัก ───
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
                    left: 20,
                    right: 20,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            '${txtFirstName.text} ${txtLastName.text}',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        _sectionLabel('ข้อมูลส่วนตัว'),
                        const SizedBox(height: 12),
                        buildTextField(
                          controller: txtPrefixName,
                          hint: 'คำนำหน้า เช่น นาย / นาง / นางสาว',
                          icon: Icons.person_outline,
                        ),
                        const SizedBox(height: 12),
                        buildTextField(
                          controller: txtFirstName,
                          hint: 'ชื่อจริง',
                          icon: Icons.badge_outlined,
                          validator:
                              (v) =>
                                  (v == null || v.isEmpty)
                                      ? 'กรุณากรอกชื่อ'
                                      : null,
                        ),
                        const SizedBox(height: 12),
                        buildTextField(
                          controller: txtLastName,
                          hint: 'นามสกุล',
                          icon: Icons.badge_outlined,
                          validator:
                              (v) =>
                                  (v == null || v.isEmpty)
                                      ? 'กรุณากรอกนามสกุล'
                                      : null,
                        ),
                        const SizedBox(height: 12),
                        buildTextField(
                          controller: txtPhone,
                          hint: 'เบอร์โทรศัพท์',
                          icon: Icons.person_outline,
                        ),
                        const SizedBox(height: 12),
                        buildTextField(
                          controller: txtEmail,
                          hint: 'อีเมล',
                          icon: Icons.email_outlined,
                          keybord: TextInputType.emailAddress,
                          isSelect: false,
                        ),
                        const SizedBox(height: 12),
                        buildTextField(
                          controller: txtIdcard,
                          hint: 'หมายเลขบัคร',
                          icon: Icons.email_outlined,
                          keybord: TextInputType.emailAddress,
                          isSelect: false,
                        ),

                        const Divider(
                          color: AppColors.backgroundMain,
                          height: 32,
                        ),

                        const SizedBox(height: 32),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _submitUpdate,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            child:
                                _isLoading
                                    ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                    : const Text(
                                      'บันทึกข้อมูล',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Kanit',
                                      ),
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ─── รูปโปรไฟล์ลอยด้านบน ───
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
                        child: ClipOval(child: _buildProfileImage()),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _showImagePicker,
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Image.asset(
                                'assets/DSD/icon/icons_camera.png',
                                width: 20,
                                height: 20,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Text(
      text,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    ),
  );
}
