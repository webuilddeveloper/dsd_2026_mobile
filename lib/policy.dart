import 'package:dsd/blank_page/dialog_fail.dart';
import 'package:dsd/login.dart';
import 'package:dsd/shared/api_provider.dart';
import 'package:dsd/shared/policy_acceptance.dart';
import 'package:dsd/style_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PolicyPage extends StatefulWidget {
  const PolicyPage({super.key, required this.nextPage, this.request});

  final Future<dynamic> Function(String url, dynamic body)? request;

  final Widget nextPage;

  @override
  State<PolicyPage> createState() => _PolicyPageState();
}

class _PolicyPageState extends State<PolicyPage> {
  final storage = FlutterSecureStorage();
  final _scrollController = ScrollController();
  String _profileCode = '';
  Future<dynamic> _post(String url, dynamic body) =>
      (widget.request ?? postapi)(url, body);

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _continue() {
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => widget.nextPage),
      (route) => false,
    );
  }

  Future<void> _scrollToEnd() async {
    if (!_scrollController.hasClients || policyContent.trim().isEmpty) return;
    await _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOut,
    );
    _checkReadToEnd();
  }

  void _checkReadToEnd() {
    if (!mounted ||
        !_scrollController.hasClients ||
        policyContent.trim().isEmpty) {
      return;
    }
    if (_scrollController.position.extentAfter <= 10 && !hasReadToEnd) {
      setState(() => hasReadToEnd = true);
    }
  }

  bool isLoading = true;
  bool isSubmitting = false;

  String policyCode = '';
  String policyTitle = 'เงื่อนไขการใช้งาน';
  String policyContent = '';

  bool isChecked = false;
  bool hasReadToEnd = false;

  @override
  void initState() {
    super.initState();
    readPolicy();
  }

  Future<void> readPolicy() async {
    try {
      _profileCode = await storage.read(key: 'profileCode') ?? '';
      if (_profileCode.isEmpty) throw StateError('Missing profile code');
      if (await PolicyAcceptance.hasAccepted(_profileCode)) {
        _continue();
        return;
      }
      // The legacy API uses username + reference to identify acknowledgements.
      // Use the stable profile code, since social accounts may have no username.
      final result = await _post('${policyApi}read', {
        'username': _profileCode,
        'profileCode': _profileCode,
      });
      if (result is! Map ||
          result['status'] != 'S' ||
          result['objectData'] == null) {
        throw StateError('Unable to read policy');
      }
      if (result['objectData'] is List &&
          (result['objectData'] as List).isEmpty) {
        _continue();
        return;
      }
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
      WidgetsBinding.instance.addPostFrameCallback((_) => _checkReadToEnd());
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
    if (data is String && data.trim().isNotEmpty) {
      return data;
    }

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
    if (isSubmitting ||
        !hasReadToEnd ||
        !isChecked ||
        policyContent.trim().isEmpty ||
        policyCode.isEmpty) {
      return;
    }

    setState(() => isSubmitting = true);

    try {
      final profileCode = _profileCode;

      final profileFirstName =
          await storage.read(key: 'profileFirstName') ?? '';

      final body = {
        'profileCode': profileCode,
        'username': profileCode,
        'reference': policyCode,
        'isActive': true,
        'status': 'A',
        'createBy': profileFirstName,
        'updateBy': profileFirstName,
      };

      if (policyCode.isNotEmpty) {
        body['policyCode'] = policyCode;
      }

      final result = await _post('${policyApi}create', body);
      if (!mounted) return;

      if (result['status'] == 'S') {
        await PolicyAcceptance.remember(profileCode);
        _continue();
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
      if (!mounted) return;
      showDialogFail(
        context,
        title: 'เกิดข้อผิดพลาด',
        description: 'ไม่สามารถบันทึกการยอมรับเงื่อนไขได้',
        onConfirm: () {
          Navigator.pop(context);
        },
      );
    } finally {
      if (mounted) {
        setState(() => isSubmitting = false);
      }
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

  /// ตรวจสอบว่าผู้ใช้เลื่อนอ่านเนื้อหาจนถึงด้านล่างแล้วหรือยัง
  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification ||
        notification is OverscrollNotification) {
      final metrics = notification.metrics;

      // เผื่อระยะเล็กน้อย เพื่อให้ไม่ต้องลากแบบเป๊ะ ๆ
      final reachedEnd = metrics.pixels >= metrics.maxScrollExtent - 10;

      if (reachedEnd && !hasReadToEnd) {
        setState(() {
          hasReadToEnd = true;
        });
      }
    }

    return false;
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
          surfaceTintColor: Colors.transparent,
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
                        child: NotificationListener<ScrollNotification>(
                          onNotification: _handleScrollNotification,
                          child: SingleChildScrollView(
                            controller: _scrollController,
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
                    ),

                    SafeArea(
                      top: false,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        child: Column(
                          children: [
                            // ------------------------------------------------
                            // สถานะการอ่าน
                            // ------------------------------------------------
                            Semantics(
                              button: true,
                              child: InkWell(
                                onTap:
                                    isSubmitting || policyContent.trim().isEmpty
                                        ? null
                                        : _scrollToEnd,
                                borderRadius: BorderRadius.circular(10),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        hasReadToEnd
                                            ? AppColors.primary.withValues(alpha: 0.12)
                                            : Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        hasReadToEnd
                                            ? Icons.check_circle_outline
                                            : Icons.keyboard_arrow_down,
                                        size: 20,
                                        color:
                                            hasReadToEnd
                                                ? AppColors.primary
                                                : AppColors.textgrey,
                                      ),

                                      const SizedBox(width: 8),

                                      Expanded(
                                        child: Text(
                                          hasReadToEnd
                                              ? 'ถึงท้ายเงื่อนไขแล้ว โปรดยืนยันการยอมรับ'
                                              : 'เลื่อนไปท้ายเงื่อนไข',
                                          style: TextStyle(
                                            fontFamily: 'Kanit',
                                            fontSize: 13,
                                            color:
                                                hasReadToEnd
                                                    ? AppColors.textDark
                                                    : AppColors.textgrey,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),

                            // ------------------------------------------------
                            // Checkbox
                            // ------------------------------------------------
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color:
                                    hasReadToEnd
                                        ? Colors.white
                                        : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color:
                                      hasReadToEnd
                                          ? AppColors.borderColor
                                          : Colors.grey.shade300,
                                ),
                              ),
                              child: CheckboxListTile(
                                value: isChecked,

                                // ยังอ่านไม่จบ = กดไม่ได้
                                enabled: hasReadToEnd,

                                onChanged:
                                    hasReadToEnd
                                        ? (value) {
                                          setState(() {
                                            isChecked = value ?? false;
                                          });
                                        }
                                        : null,

                                title: Text(
                                  'ฉันได้อ่านและยอมรับข้อกำหนดและเงื่อนไขการใช้งาน',
                                  style: TextStyle(
                                    fontFamily: 'Kanit',
                                    fontSize: 15,
                                    color:
                                        hasReadToEnd
                                            ? AppColors.textDark
                                            : Colors.grey.shade500,
                                  ),
                                ),

                                controlAffinity:
                                    ListTileControlAffinity.leading,
                              ),
                            ),

                            const SizedBox(height: 12),

                            // ------------------------------------------------
                            // ปุ่ม
                            // ------------------------------------------------
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed:
                                        isSubmitting ? null : declinePolicy,
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
                                        isSubmitting ||
                                                policyContent.trim().isEmpty ||
                                                policyCode.isEmpty ||
                                                !hasReadToEnd ||
                                                !isChecked
                                            ? null
                                            : acceptPolicy,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: Colors.black,
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
