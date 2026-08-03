import 'package:dsd/blank_page/appbar.dart';
import 'package:dsd/blank_page/format.dart';
import 'package:dsd/blank_page/launch.dart';
import 'package:dsd/blank_page/webview.dart';
import 'package:dsd/shared/app_strings.dart';

import 'package:dsd/shared/api_provider.dart';
import 'package:dsd/style_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TestingPage extends StatefulWidget {
  const TestingPage({super.key});

  @override
  State<TestingPage> createState() => _TestingPageState();
}

class _TestingPageState extends State<TestingPage> {
  void goBack() {
    Navigator.pop(context, false);
  }

  final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _testingApi();
  }

  List<Map<String, dynamic>> testing = [];
  bool isLoading = true;

  /*===============================>> API <<=============================== */
  Future<void> _testingApi() async {
    // final profileCode = await storage.read(key: 'profileCode');

    // final data = await postDio('${skilledLaborApi}read', {
    //   'limit': 10,
    //   "username": profileCode,
    //   // "code": profileCode,
    // });
    // setState(() {
    //   testing = (data as List).cast<Map<String, dynamic>>();

    //   isLoading = false;
    // });
    final data = await postDio('${testingApi}readAPI', {"keySearch": "2569"});
    setState(() {
      testing = (data as List).cast<Map<String, dynamic>>();

      isLoading = false;
    });
  }

  /*===============================>> API <<=============================== */

  @override
  Widget build(BuildContext context) {
    final language = AppStrings.of(context); // ← ดึง strings ตาม locale
    return Scaffold(
      appBar: appBar(
        title: language.skillTestSchedule,
        backBtn: true,
        rightBtn: false,
        backAction: () => goBack(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: ListView.builder(
          itemCount: testing.length,
          itemBuilder: (context, index) {
            final item = testing[index];

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Title
                    Text(
                      item['testOccupationName'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 6),

                    /// Batch
                    Text(
                      'รุ่นที่ ${item['testTime']}',
                      style: const TextStyle(fontSize: 15),
                    ),

                    const SizedBox(height: 4),

                    /// Organization
                    Text(item['site'], style: const TextStyle(fontSize: 15)),

                    const SizedBox(height: 12),

                    /// Date
                    Row(
                      children: [
                        Image.asset(
                          'assets/DSD/icon/icon_calendar_full.png',
                          color: AppColors.primary,
                          width: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          // exam.examDate,
                          formatDate(item['startDate']),
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    const Divider(color: AppColors.backgroundMain),
                    const SizedBox(height: 16),

                    /// Button
                    InkWell(
                      onTap: () {
                        final url = buildTestingUrl(item); // ชั่วคราว
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => WebViewPage(
                                  url: url,
                                  title: language.skillTestSchedule,
                                ),
                          ),
                        );
                      },
                      // onTap:
                      //     item['status2'] == true
                      //         ? null
                      //         : () {
                      //           Navigator.push(
                      //             context,
                      //             MaterialPageRoute(
                      //               builder:
                      //                   (context) =>
                      //                       SkillDetailPage(skill: item),
                      //             ),
                      //           );
                      //         },
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color:
                              item['status2'] == true
                                  ? Colors.grey
                                  : const Color(0xff6FC546),
                        ),
                        child: Center(
                          child: Text(
                            item['status2'] == true ? 'สมัครแล้ว' : 'สมัคร',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
