import 'package:dio/dio.dart';
import 'package:dsd/blank_page/appbar.dart';
import 'package:dsd/shared/api_provider.dart';
import 'package:dsd/style_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../blank_page/dialog_fail.dart';

class SkillDetailPage extends StatefulWidget {
  final Map<String, dynamic> skill;

  const SkillDetailPage({super.key, required this.skill});

  @override
  State<SkillDetailPage> createState() => _SkillDetailPageState();
}

class _SkillDetailPageState extends State<SkillDetailPage> {
  final _formKey = GlobalKey<FormState>();
  final storage = FlutterSecureStorage();
  String selectedIdType = 'บัตรประจำตัวประชาชน';
  final TextEditingController idController = TextEditingController();

  final List<String> idTypes = ['บัตรประจำตัวประชาชน', 'หนังสือเดินทาง'];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void dispose() {
    idController.dispose();
    super.dispose();
  }

  /// ✅ validator
  String? validateId(String? value) {
    if (value == null || value.isEmpty) {
      return 'กรุณากรอกข้อมูล';
    }

    if (selectedIdType == 'บัตรประจำตัวประชาชน') {
      if (!RegExp(r'^\d{13}$').hasMatch(value)) {
        return 'กรุณากรอกเลขบัตรประชาชน 13 หลัก';
      }
    } else {
      if (!RegExp(r'^[A-Z]{2}\d{7}$').hasMatch(value)) {
        return 'รูปแบบ Passport ไม่ถูกต้อง';
      }
    }

    return null;
  }

  loadData() async {
    final idCode = await storage.read(key: 'idcard');
    // if (!mounted) return;
    setState(() {
      idController.text = idCode ?? '';
    });
  }

  /// ✅ API
  _sendSlll() async {
    var dio = Dio();
    print('##########_skilledLaborApi###########');
    final profileCode = await storage.read(key: 'profileCode');

    var data = {
      "type": selectedIdType,
      "idcard": idController.text,
      "reference": widget.skill['code'],
      "updateBy": profileCode,
      "createBy": profileCode,
    };

    try {
      var response = await dio.post(
        '$sendskill/create',
        data: data,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        showCustomDialog(
          context,
          title: 'สมัครสำเร็จ',
          description:
              "ระบบได้บันทึกใบสมัครของคุณเรียบร้อยแล้ว กรุณารอการตรวจสอบจากเจ้าหน้าที่",
          onConfirm: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        );
      }
    } on DioException {
      showCustomDialog(
        context,
        title: 'เกิดข้อผิดพลาด',
        description: "ไม่สามารถส่งข้อมูลได้ กรุณาลองใหม่อีกครั้ง",
        onConfirm: () => Navigator.pop(context),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.skill;

    return Scaffold(
      appBar: appBar(
        title: "กำหนดการทดสอบมาตรฐานฝีมือแรงงาน",
        backBtn: true,
        rightBtn: false,
        backAction: () => Navigator.pop(context),
      ),
      backgroundColor: const Color(0xffF5F6FA),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            // ✅ สำคัญมาก
            key: _formKey,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    color: Colors.black.withOpacity(0.05),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Title
                    Center(
                      child: Column(
                        children: [
                          const Text(
                            'สมัครฝึกอบรม',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            width: 120,
                            height: 2,
                            color: AppColors.borderColor,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// สาขา
                    const Text(
                      'สาขา',
                      style: TextStyle(color: AppColors.textgrey),
                    ),
                    Text(item['title']),

                    const SizedBox(height: 16),

                    /// หน่วยงาน
                    const Text(
                      'หน่วยงาน',
                      style: TextStyle(color: AppColors.textgrey),
                    ),
                    Text(item['agency']),

                    const SizedBox(height: 16),

                    /// Dropdown
                    const Text('ประเภทบัตร'),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: DropdownButton<String>(
                        value: selectedIdType,
                        isExpanded: true,
                        underline: const SizedBox(),
                        items:
                            idTypes.map((e) {
                              return DropdownMenuItem(value: e, child: Text(e));
                            }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedIdType = value!;
                            idController.clear(); // ✅ reset ค่า
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// Input
                    const Text('หมายเลขบัตร'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: idController, // ✅ สำคัญ
                      keyboardType:
                          selectedIdType == 'หนังสือเดินทาง'
                              ? TextInputType.text
                              : TextInputType.number,
                      inputFormatters:
                          selectedIdType == 'หนังสือเดินทาง'
                              ? [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[A-Z0-9]'),
                                ),
                              ]
                              : [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(13),
                              ],
                      validator: validateId,
                      decoration: InputDecoration(
                        hintText: 'กรอกหมายเลขบัตร',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// Button
                    InkWell(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          _sendSlll();
                        }
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: AppColors.primary,
                        ),
                        child: const Center(
                          child: Text(
                            'ยืนยัน',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    Center(
                      child: Text(
                        'คู่มือระบบสมัครฝึกอบรม',
                        style: TextStyle(color: Colors.red),
                      ),
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
}
