import 'dart:io';
import 'package:dsd/blank_page/dialog_fail.dart';
import 'package:dsd/blank_page/textfield.dart';
import 'package:dsd/shared/api_provider.dart';
import 'package:dsd/shared/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  String category = '';
  XFile? _pickedImage;
  String lineID = '';
  String _facebookID = '';
  String _appleID = '';
  String _googleID = '';
  String _status = '';
  bool _isLoading = false;

  bool get isGuest => category == 'guest';
  bool get hasIdCard => txtIdcard.text.trim().isNotEmpty;
  bool get canEditIdCard => !isGuest && !hasIdCard;

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
    final code = await storage.read(key: 'profileCode');
    final profileCategory = await storage.read(key: 'profileCategory');

    setState(() => category = profileCategory ?? '');

    final value = await postapi('${register}read', {'code': code});

    if (value.isNotEmpty) {
      try {
        final user = value['objectData'][0];
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
          lineID = user['lineID'] ?? '';
          _facebookID = user['facebookID'] ?? '';
          _appleID = user['appleID'] ?? '';
          _googleID = user['googleID'] ?? '';
          _status = user['status'] ?? 'N';
        });
      } catch (_) {}
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final img = await ImagePicker().pickImage(source: source);
    if (img != null) {
      setState(() => _pickedImage = img);
      _upload();
    }
  }

  void _upload() async {
    if (_pickedImage == null) return;
    uploadImage(_pickedImage!)
        .then((res) {
          setState(() => _imageUrl = res);
        })
        .catchError((err) {
          print(err);
        });
  }

  void _showImagePicker() {
    final language = AppStrings.of(context);
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
                  title: Text(language.photo),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_camera_outlined),
                  title: Text(language.camera),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildProfileImage() {
    if (_pickedImage != null && _pickedImage!.path.isNotEmpty) {
      return Image.file(File(_pickedImage!.path), fit: BoxFit.cover);
    } else if (_imageUrl.isNotEmpty) {
      return Image.network(_imageUrl, fit: BoxFit.cover);
    }
    return Image.asset('assets/DSD/imgs/profile.png', fit: BoxFit.cover);
  }

  Future<void> _submitUpdate() async {
    final language = AppStrings.of(context);
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);

    final code = await storage.read(key: 'profileCode');
    await storage.write(key: 'idcard', value: txtIdcard.text);
    try {
      final result = await postapi('${register}update', {
        'code': code,
        'idcard': txtIdcard.text,
        'username': txtUsername.text,
        'password': txtPassword.text,
        'facebookID': _facebookID,
        'appleID': _appleID,
        'googleID': _googleID,
        'lineID': lineID,
        'email': txtEmail.text,
        'imageUrl': _imageUrl,
        'category': category,
        'prefixName': txtPrefixName.text,
        'firstName': txtFirstName.text,
        'lastName': txtLastName.text,
        'phone': txtPhone.text,
        'birthDay': txtBirthday.text,
        'status': _status,
        'platform': Platform.operatingSystem,
        'countUnit': '[]',
      });

      if (!mounted) return;

      final isSuccess = result['status'] == 'S';
      showCustomDialog(
        context,
        title: isSuccess ? language.successfully : language.failed,
        description:
            isSuccess
                ? language.updateSuccess
                : (result['message']?.isNotEmpty == true
                    ? result['message']
                    : language.updateFailed),
        onConfirm: () => Navigator.pop(context),
      );
    } catch (_) {
      if (!mounted) return;
      showCustomDialog(
        context,
        title: language.failed,
        description: language.skipchangePassword5,
        onConfirm: () => Navigator.pop(context),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String? validateId(String? value) {
    if (value == null || value.isEmpty) {
      return 'กรุณากรอกข้อมูล';
    }

    if (!RegExp(r'^\d{13}$').hasMatch(value)) {
      return 'กรุณากรอกเลขบัตรประชาชน 13 หลัก';
    }

    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'กรุณากรอกเบอร์โทรศัพท์';
    }

    if (!RegExp(r'^0\d{9}$').hasMatch(value)) {
      return 'กรุณากรอกเบอร์โทร 10 หลัก';
    }

    return null;
  }

  Widget _sectionLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Text(
      text,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final language = AppStrings.of(context);
    return Scaffold(
      backgroundColor: AppColors.backgroundMain,
      appBar: appBar(
        title: language.useraccount,
        backBtn: true,
        rightBtn: false,
        backAction: () => Navigator.pop(context),
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
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        _sectionLabel(language.personal),
                        const SizedBox(height: 12),
                        buildTextField(
                          controller: txtPrefixName,
                          hint: language.prefix,
                          icon: Icons.person_outline,
                        ),
                        const SizedBox(height: 12),
                        buildTextField(
                          controller: txtFirstName,
                          hint: language.name,
                          icon: Icons.badge_outlined,
                          validator:
                              (v) =>
                                  (v == null || v.isEmpty)
                                      ? "${language.personal}${language.name}"
                                      : null,
                        ),
                        const SizedBox(height: 12),
                        buildTextField(
                          controller: txtLastName,
                          hint: language.lastname,
                          icon: Icons.badge_outlined,
                        ),
                        const SizedBox(height: 12),
                        buildTextField(
                          controller: txtPhone,
                          hint: language.phoneNumber,
                          icon: Icons.phone_outlined,
                          keybord: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          validator: (v) {
                            return validatePhone(v);
                          },
                        ),
                        const SizedBox(height: 12),
                        buildTextField(
                          controller: txtEmail,
                          hint: language.email,
                          icon: Icons.email_outlined,
                          keybord: TextInputType.emailAddress,
                          isSelect: false,
                        ),
                        const SizedBox(height: 12),
                        buildTextField(
                          controller: txtIdcard,
                          hint: language.idcard,
                          icon: Icons.badge_outlined,
                          keybord: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(13),
                          ],
                          isSelect: canEditIdCard, // ✅ ใช้ตัวนี้ตัวเดียวจบ
                          validator: (v) {
                            if (isGuest) return null;
                            return validateId(v);
                          },
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
                              foregroundColor: Colors.black,
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
                                    : Text(
                                      language.save,
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
                              border: Border.all(color: Colors.white, width: 3),
                            ),
                            child: Center(
                              child: Image.asset(
                                'assets/DSD/icon/icons_camera.png',
                                color: Colors.black,
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
}
