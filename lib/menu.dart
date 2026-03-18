// ignore_for_file: deprecated_member_use

import 'package:dsd/home.dart';
import 'package:dsd/model/service_data.dart';
import 'package:dsd/notification.dart';
import 'package:dsd/profile.dart';
import 'package:dsd/calendar_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Menu extends StatefulWidget {
  const Menu({super.key, this.pageIndex});
  final int? pageIndex;

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> with SingleTickerProviderStateMixin {
  List<Widget> pages = <Widget>[];
  int _currentPage = 0;
  DateTime? currentBackPressTime;
  dynamic futureNotificationTire;

  @override
  void initState() {
    // _callRead();

    globalOnTabChange = _onItemTapped;
    pages = <Widget>[
      HomePage(onTabChange: _onItemTapped),
      // EventCalendarMain(title: 'ตารางงาน'),
      CalendarPage(onTabChange: _onItemTapped),
      NotificationList(onTabChange: _onItemTapped),
      ProfilePage(onTabChange: _onItemTapped),
    ];
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      if (index == 0 && _currentPage == 0) {
        // _callRead();
      }

      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFF1E1E1E),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: WillPopScope(
          onWillPop: confirmExit,
          child: IndexedStack(index: _currentPage, children: pages),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  // สร้างเมนูด้านล่าง
  Future<bool> confirmExit() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
        msg: 'กดอีกครั้งเพื่อออก',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return Future.value(false);
    }
    return Future.value(true);
  }

  Widget _buildBottomNavBar() {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Container(
        height: 65 + MediaQuery.of(context).padding.bottom,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF000000).withOpacity(0.10),
              blurRadius: 4,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceAround, // กระจายไอคอนให้ห่างกัน
          children: [
            _buildTap(0, 'Home', icon: 'assets/DSD/icon/icon_home.png'),
            _buildTap(1, 'Calendar', icon: 'assets/DSD/icon/icon_calendar.png'),
            _buildTap(
              2,
              'Notification',
              icon: 'assets/DSD/icon/icon_noti.png',
              // isNoti: true,
            ),
            _buildTap(3, 'Profile', icon: 'assets/DSD/icon/icon_user.png'),
          ],
        ),
      ),
    );
  }

  Widget _buildTap(
    int? index,
    String title, {
    // bool isNoti = false,
    String? icon,
  }) {
    return Flexible(
      flex: 1,
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: GestureDetector(
            onTap: () => _onItemTapped(index!),
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ----- >>> Noti
                  // if (isNoti)
                  //   Stack(
                  //     children: [
                  //       Image.asset(
                  //         _currentPage == index ? iconActive! : icon!,
                  //         height: 30,
                  //         width: 30,
                  //       ),
                  //       if (_ListNotiModel.isNotEmpty)
                  //         Positioned(
                  //           top: 0,
                  //           right: 3,
                  //           child: Container(
                  //             height: 10,
                  //             width: 10,
                  //             decoration: const BoxDecoration(
                  //               shape: BoxShape.circle,
                  //               color: Color(0xFFE40000),
                  //             ),
                  //           ),
                  //         ),
                  //     ],
                  //   )
                  // else
                  Image.asset(
                    icon!,
                    height: 30,
                    width: 30,
                    color:
                        _currentPage == index
                            ? Theme.of(context).primaryColor
                            : Color(0xff484C52),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color:
                          _currentPage == index
                              ? Theme.of(context).primaryColor
                              : Colors.grey[600],
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
