// ignore_for_file: use_build_context_synchronously

import 'package:dsd/blank_page/dialog_fail.dart';
import 'package:dsd/login.dart';
import 'package:dsd/shared/api_provider.dart';
import 'package:dsd/style_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PolicyPage extends StatefulWidget {
  const PolicyPage({super.key, required this.nextPage});

  final Widget nextPage;

  @override
  State<PolicyPage> createState() => _PolicyPageState();
}

class _PolicyPageState extends State<PolicyPage> {
  final storage = FlutterSecureStorage();

  bool isLoading = true;
  bool isSubmitting = false;
  String policyCode = '';
  String policyTitle = 'เงื่อนไขการใช้งาน';
  String policyContent = '';

  @override
  void initState() {
    super.initState();
    readPolicy();
  }

  Future<void> readPolicy() async {
    try {
      final result = await postapi('${policyApi}read', {});
      final data = _extractPolicyData(result);

      if (!mounted) return;
      setState(() {
        policyCode = _readFirstString(data, ['code']);
        policyTitle = _readFirstString(data, [
          'title',
          'name',
          'subject',
        ], fallback: policyTitle);
        policyContent = _readFirstString(data, [
          'description',
          'detail',
          'content',
          'html',
          'policy',
          'policyDetail',
          'policyDescription',
        ]);
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      showDialogFail(
        context,
        title: 'เกิดข้อผิดพลาด',
        description: 'ไม่สามารถโหลดเงื่อนไขการใช้งานได้',
        onConfirm: () {
          Navigator.pop(context);
        },
      );
    }
  }

  dynamic _extractPolicyData(dynamic result) {
    if (result is Map) {
      final objectData = result['objectData'];
      if (objectData is List && objectData.isNotEmpty) {
        return objectData.first;
      }
      if (objectData != null) {
        return objectData;
      }
    }
    if (result is List && result.isNotEmpty) {
      return result.first;
    }
    return result;
  }

  String _readFirstString(
    dynamic data,
    List<String> keys, {
    String fallback = '',
  }) {
    if (data is String && data.trim().isNotEmpty) return data;
    if (data is Map) {
      for (final key in keys) {
        final value = data[key];
        if (value != null && value.toString().trim().isNotEmpty) {
          return value.toString();
        }
      }
    }
    return fallback;
  }

  Future<void> acceptPolicy() async {
    if (isSubmitting) return;
    setState(() => isSubmitting = true);

    try {
      final profileCode = await storage.read(key: 'profileCode') ?? '';
      final profileFirstName =
          await storage.read(key: 'profileFirstName') ?? '';
      final body = {
        'profileCode': profileCode,
        'createBy': profileFirstName,
        'updateBy': profileFirstName,
      };

      if (policyCode.isNotEmpty) {
        body['policyCode'] = policyCode;
      }

      final result = await postapi('${policyApi}create', body);

      if (result['status'] == 'S') {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => widget.nextPage),
          (route) => false,
        );
      } else {
        showDialogFail(
          context,
          title: 'เกิดข้อผิดพลาด',
          description:
              result['message']?.toString() ??
              'ไม่สามารถบันทึกการยอมรับเงื่อนไขได้',
          onConfirm: () {
            Navigator.pop(context);
          },
        );
      }
    } catch (e) {
      showDialogFail(
        context,
        title: 'เกิดข้อผิดพลาด',
        description: 'ไม่สามารถบันทึกการยอมรับเงื่อนไขได้',
        onConfirm: () {
          Navigator.pop(context);
        },
      );
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }

  Future<void> declinePolicy() async {
    await storage.deleteAll();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.backgroundMain,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Text(
            policyTitle,
            style: const TextStyle(
              color: AppColors.textDark,
              fontFamily: 'Kanit',
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body:
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                  children: [
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.borderColor),
                        ),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child:
                              policyContent.trim().isEmpty
                                  ? const Text(
                                    'ไม่พบข้อมูลเงื่อนไขการใช้งาน',
                                    style: TextStyle(
                                      fontFamily: 'Kanit',
                                      fontSize: 14,
                                      color: AppColors.textgrey,
                                    ),
                                  )
                                  : Html(data: policyContent),
                        ),
                      ),
                    ),
                    SafeArea(
                      top: false,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: isSubmitting ? null : declinePolicy,
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.textDark,
                                  side: const BorderSide(
                                    color: AppColors.borderColor,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'ไม่ยอมรับ',
                                  style: TextStyle(
                                    fontFamily: 'Kanit',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed:
                                    isSubmitting || policyContent.trim().isEmpty
                                        ? null
                                        : acceptPolicy,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child:
                                    isSubmitting
                                        ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                        : const Text(
                                          'ยอมรับ',
                                          style: TextStyle(
                                            fontFamily: 'Kanit',
                                            fontWeight: FontWeight.w600,
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
    );
  }
}
