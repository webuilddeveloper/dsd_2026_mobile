// ignore_for_file: deprecated_member_use

import 'package:dsd/home.dart';
import 'package:dsd/login.dart';
import 'package:dsd/notification/notification.dart';
import 'package:dsd/calendar/calendar_page.dart';
import 'package:dsd/profile/user_information.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Menu extends StatefulWidget {
  const Menu({super.key, this.pageIndex});
  final int? pageIndex;

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> with SingleTickerProviderStateMixin {
  final storage = FlutterSecureStorage();
  final GlobalKey<HomePageState> _homeKey = GlobalKey<HomePageState>();

  List<Widget> pages = <Widget>[];
  int _currentPage = 0;
  int _previousPage = 0;
  DateTime? currentBackPressTime;

  @override
  void initState() {
    pages = <Widget>[
      HomePage(key: ValueKey(0), onTabChange: _onItemTapped),
      CalendarPage(key: ValueKey(1), onTabChange: _onItemTapped),
      NotificationList(key: ValueKey(2), onTabChange: _onItemTapped),
      UserInformationPage(key: ValueKey(3), onTabChange: _onItemTapped),
    ];
    super.initState();
  }

  void _onItemTapped(int index) async {
    if (index == _currentPage) return;

    if (index == 3) {
      final code = await storage.read(key: 'profileCode');

      if (code == null || code.isEmpty) {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );

        if (result == true) {
          setState(() {
            _previousPage = _currentPage;
            _currentPage = index;
          });
          _homeKey.currentState?.refreshPage();
        }
        return;
      }
    }

    if (index == 0) {
      _homeKey.currentState?.refreshPage();
    }

    setState(() {
      _previousPage = _currentPage;
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
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              final isGoingRight = _currentPage > _previousPage;

              // หน้าใหม่ slide เข้ามา
              final slideIn = SlideTransition(
                position: Tween<Offset>(
                  begin:
                      isGoingRight
                          ? const Offset(1.0, 0.0)
                          : const Offset(-1.0, 0.0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeInOut),
                ),
                child: child,
              );

              // หน้าเก่าถูกดัน/ค้างอยู่ข้างหลัง
              return Stack(
                children: [
                  SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset.zero,
                      end:
                          isGoingRight
                              ? const Offset(-0.3, 0.0)
                              : const Offset(0.3, 0.0),
                    ).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeInOut,
                      ),
                    ),
                    child: pages[_previousPage],
                  ),
                  slideIn,
                ],
              );
            },
            child: KeyedSubtree(
              key: ValueKey(_currentPage),
              child: pages[_currentPage],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

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
        height: 72 + MediaQuery.of(context).padding.bottom,
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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildTap(0, 'Home', icon: 'assets/DSD/icon/icon_home.png'),
            _buildTap(1, 'Calendar', icon: 'assets/DSD/icon/icon_calendar.png'),
            _buildTap(2, 'Notification', icon: 'assets/DSD/icon/icon_noti.png'),
            _buildTap(3, 'Profile', icon: 'assets/DSD/icon/icon_user.png'),
          ],
        ),
      ),
    );
  }

  Widget _buildTap(int? index, String title, {String? icon}) {
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
                  Image.asset(
                    icon!,
                    height: 30,
                    width: 30,
                    color:
                        _currentPage == index
                            ? Theme.of(context).primaryColor
                            : const Color(0xff484C52),
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
