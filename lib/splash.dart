import 'dart:async';
import 'package:dsd/blank_page/dialog_fail.dart';
import 'package:dsd/menu.dart';
import 'package:dsd/style_theme.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

late Future<dynamic> futureModel;

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    _callRead();
    super.initState();
  }

  _callRead() {
    futureModel = _loadDemoData();

    // postDio(server + 'm/splash/read', {
    //   "code": '20241028141922-963-452',
    // });
  }

  Future<List<Map<String, dynamic>>> _loadDemoData() async {
    await Future.delayed(Duration(seconds: 1)); // จำลองโหลดข้อมูล
    return [
      {"timeOut": "2000"}, // ตัวอย่างข้อมูลจำลอง
    ];
  }

  _callTimer(time) async {
    var duration = Duration(seconds: time);
    return Timer(duration, _callNavigatorPage);
  }

  _callNavigatorPage() async {
    // final storage = FlutterSecureStorage();
    // String? value = await storage.read(key: 'token');
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => Menu(pageIndex: null)),
      (Route<dynamic> route) => false,
    );

    // if (value != null && value.isNotEmpty) {
    //   Navigator.of(context).pushAndRemoveUntil(
    //     MaterialPageRoute(builder: (context) => Menu(pageIndex: null)),
    //     (Route<dynamic> route) => false,
    //   );
    // } else {
    //   Navigator.of(context).pushAndRemoveUntil(
    //     MaterialPageRoute(builder: (context) => LoginPage()),
    //     (Route<dynamic> route) => false,
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: FutureBuilder<dynamic>(
          future: futureModel,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              _callTimer(
                (snapshot.data.length > 0
                        ? int.parse(snapshot.data[0]['timeOut']) / 1000
                        : 0)
                    .round(),
              );

              return snapshot.data.length > 0
                  ? Center(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // โลโก้
                          Container(
                            height: 140,
                            width: 140,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  'assets/DSD/imgs/logo_app.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 30),

                          // ชื่อแอป
                          Text(
                            'DSD E-Certification',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                              letterSpacing: 1.2,
                            ),
                          ),

                          const SizedBox(height: 8),

                          // subtitle
                          Text(
                            'Professional Certification Platform',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),

                          const SizedBox(height: 40),

                          // loading
                          // const CircularProgressIndicator(),
                        ],
                      ),
                    ),
                  )
                  : Container();
            } else if (snapshot.hasError) {
              return Center(
                child: Container(
                  color: Colors.white,
                  child: dialogFail(context, reloadApp: true),
                ),
              );
            } else {
              return Center(child: Container());
            }
          },
        ),
      ),
    );
  }
}
