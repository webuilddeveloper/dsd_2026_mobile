import 'package:dsd/blank_page/appbar.dart';
import 'package:dsd/blank_page/dialog_fail.dart';
import 'package:dsd/model/training_service_data.dart';
import 'package:dsd/style_theme.dart';
import 'package:flutter/material.dart';

class TraningDetail extends StatefulWidget {
  final TrainingModel item;

  const TraningDetail({super.key, required this.item});

  @override
  State<TraningDetail> createState() => _TraningDetailState();
}

class _TraningDetailState extends State<TraningDetail> {
  String selectedIdType = 'บัตรประจำตัวประชาชน';
  final TextEditingController idController = TextEditingController();
  final List<String> idTypes = ['บัตรประจำตัวประชาชน', 'หนังสือเดินทาง'];

  @override
  void initState() {
    super.initState();
    idController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    idController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    void goBack() {
      Navigator.pop(context, false);
    }

    return Scaffold(
      appBar: appBar(
        title: "หลักสูตรฝึกอบรม",
        backBtn: true,
        backAction: () => goBack(),
      ),
      backgroundColor: const Color(0xffF5F6FA),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
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
                  /// Title Center
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
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textgrey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.title,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),

                  const SizedBox(height: 16),

                  /// หน่วยงาน
                  const Text(
                    'หน่วยงาน',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textgrey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.organization,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),

                  const SizedBox(height: 16),

                  /// Dropdown
                  const Text(
                    'ประเภทบัตร',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textgrey,
                    ),
                  ),
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
                            return DropdownMenuItem(
                              value: e,
                              child: Text(
                                e,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textgrey,
                                ),
                              ),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedIdType = value!;
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// TextField
                  const Text(
                    'หมายเลขบัตร',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textgrey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: idController,
                    decoration: InputDecoration(
                      hintText: 'กรอกหมายเลขบัตร',
                      hintStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textgrey,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// Button
                  InkWell(
                    onTap:
                        idController.text.isNotEmpty
                            ? () {
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
                            : null,
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: AppColors.primary,
                      ),
                      child: const Center(
                        child: Text(
                          'ยืนยัน',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// Footer
                  Center(
                    child: Text(
                      'คู่มือระบบสมัครฝึกอบรม',
                      style: TextStyle(color: Colors.red.shade400),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
