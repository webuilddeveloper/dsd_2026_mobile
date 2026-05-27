import 'package:dsd/blank_page/appbar.dart';
import 'package:dsd/blank_page/format.dart';
import 'package:dsd/notification/notification_detail.dart';
import 'package:dsd/shared/api_provider.dart';
import 'package:dsd/shared/app_strings.dart';
import 'package:dsd/style_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class NotificationList extends StatefulWidget {
  final Function(int)? onTabChange;
  final bool pushedFromPage;

  const NotificationList({
    super.key,
    this.onTabChange,
    this.pushedFromPage = false,
  });

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList>
    with SingleTickerProviderStateMixin {
  final storage = FlutterSecureStorage();
  String selectType = "1";

  List<Map<String, dynamic>> allNotifications = [];
  List<Map<String, dynamic>> notifications = [];
  bool isLoading = true;

  final List<Map<String, dynamic>> category = [
    {
      "type": "1",
      "name": "ทั้งหมด",
      "icon": "assets/DSD/icon/icon_send.png",
      "color": "0xFFBB439C",
    },
    {
      "type": "2",
      "name": "ข่าวสาร",
      "icon": "assets/DSD/icon/icon news.png",
      "color": "0xFFF1B435",
    },
    {
      "type": "3",
      "name": "หลักสูตรอบรม",
      "icon": "assets/DSD/icon/icon_training.png",
      "color": "0xFF956A08",
    },
    {
      "type": "4",
      "name": "ทดสอบมาตรฐาน",
      "icon": "assets/DSD/icon/icons_skill.png",
      "color": "0xFFF18135",
    },
    {
      "type": "5",
      "name": "สิทธิประโยชน์",
      "icon": "assets/DSD/icon/icons_privilege.png",
      "color": "0xFF4F1964",
    },
  ];

  // แทน switch-case ด้วย Map อ่านง่ายกว่า
  final Map<String, String> apiByType = {
    "2": newsApi,
    "3": trainingApi,
    "4": skilledLaborApi,
    "5": privilegeApi,
  };

  void goBack() {
    if (widget.pushedFromPage) {
      Navigator.pop(context);
    } else {
      widget.onTabChange?.call(0);
    }
  }

  @override
  void initState() {
    super.initState();
    loadAllData();
  }

  void _filterData() {
    if (selectType == "1") {
      notifications = List.from(allNotifications); // ป้องกัน reference เดียวกัน
    } else {
      notifications =
          allNotifications
              .where((e) => e["type"].toString() == selectType)
              .toList();
    }
  }

  Future<List<Map<String, dynamic>>> _fetch(String api, String type) async {
    final profilecode = await storage.read(key: 'profileCode');
    final res = await postDio('${api}read', {"profilecode": profilecode});

    return (res as List).map((e) => _normalize(e, type)).toList();
  }

  Map<String, dynamic> _normalize(Map<String, dynamic> e, String type) {
    return {
      ...e,
      "type": type,
      "title": e['title'] ?? '',
      "description": e['description'] ?? '',
      "imageUrl": e['imageUrl'] ?? '',
      "docDate": e['docDate'] ?? '',
      "isRead": e['isRead'],
      "code": e['code'] ?? '',
    };
  }

  Future<void> loadAllData() async {
    setState(() => isLoading = true);

    try {
      final results = await Future.wait([
        _fetch(newsApi, "2"),
        _fetch(trainingApi, "3"),
        _fetch(skilledLaborApi, "4"),
        _fetch(privilegeApi, "5"),
      ]);

      allNotifications = results.expand((e) => e).toList();
      allNotifications.sort(
        (a, b) => (b["docDate"] ?? "").compareTo(a["docDate"] ?? ""),
      );

      _filterData();
    } catch (e) {
      debugPrint("loadAllData error: $e");
    } finally {
      if (mounted) {
        setState(() => isLoading = false); // ป้องกัน setState หลัง dispose
      }
    }
  }

  int getCount(String type) {
    if (type == "1") {
      // นับทุก type ที่ยังไม่อ่าน
      return allNotifications.where((e) => e["isRead"] == false).length;
    }
    // นับเฉพาะ type นั้นที่ยังไม่อ่าน
    return allNotifications
        .where((e) => e["type"].toString() == type && e["isRead"] == false)
        .length;
  }

  Future<void> markAsRead(Map<String, dynamic> item) async {
    try {
      final api = apiByType[item["type"].toString()] ?? newsApi;
      final profilecode = await storage.read(key: 'profileCode');
      await postDio('${api}read', {
        "code": item["code"],
        "profilecode": profilecode,
      });
    } catch (e) {
      debugPrint("markAsRead error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final language = AppStrings.of(context);
    return Scaffold(
      appBar: appBar(
        title: language.notification,
        backBtn: true,
        rightBtn: false,
        backAction: goBack,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child:
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                  children: [
                    /// CATEGORY
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: category.length,
                        itemBuilder: (context, index) {
                          final c = category[index];
                          final isSelected = c["type"] == selectType;
                          final count = getCount(c["type"]);
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectType = c["type"];
                                _filterData();
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: Column(
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                        height: isSelected ? 70 : 55,
                                        width: isSelected ? 70 : 55,
                                        decoration: BoxDecoration(
                                          color: Color(int.parse(c["color"])),
                                          borderRadius: BorderRadius.circular(
                                            isSelected ? 35 : 30,
                                          ),
                                        ),
                                        child: Center(
                                          child: Image.asset(
                                            c["icon"],
                                            width: 28,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),

                                      if (count > 0)
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: Container(
                                            height: 19,
                                            width: 19,
                                            decoration: const BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: Text(
                                                '$count',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    c["name"],
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// LIST
                    Expanded(
                      child:
                          notifications.isNotEmpty
                              ? ListView.builder(
                                itemCount: notifications.length,
                                itemBuilder:
                                    (context, index) =>
                                        _notiList(item: notifications[index]),
                              )
                              : Center(child: Text("ยังไม่มีการแจ้งเตือน")),
                    ),
                  ],
                ),
      ),
    );
  }

  Widget _notiList({required Map<String, dynamic> item}) {
    final bool isRead = item["isRead"] ?? false;

    final categoryList = category.firstWhere(
      (c) => c["type"] == item["type"],
      orElse:
          () => {
            "color": AppColors.primary,
            "icon": "assets/DSD/imgs/logo_app.png",
          },
    );

    final Color categoryColor = Color(
      int.tryParse(categoryList["color"].toString()) ?? 0xFFCCCCCC,
    );

    return InkWell(
      onTap: () async {
        setState(() => item["isRead"] = true);

        await markAsRead(item);

        if (!mounted) return;

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NotiDetail(noti: item)),
        );
      },

      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isRead ? Color(0xFFEAEAEA) : const Color(0xFFFBE8C7),
        ),

        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),

          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔹 ICON + DOT
              Stack(
                children: [
                  Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      color: categoryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Image.asset(
                        categoryList["icon"],
                        width: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  if (!isRead)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        height: 9,
                        width: 9,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(width: 8),

              /// 🔹 TEXT SECTION
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item["title"] ?? "-",
                      style: const TextStyle(fontWeight: FontWeight.w600),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 4),

                    /// ✅ ใช้ Flexible กัน overflow
                    Flexible(
                      child: Html(
                        data: item['description'] ?? "",
                        style: {
                          "body": Style(
                            margin: Margins.zero,
                            padding: HtmlPaddings.zero,
                            maxLines: 3,
                            textOverflow: TextOverflow.ellipsis,
                            fontSize: FontSize(12),
                            color: AppColors.textgrey,
                          ),
                        },
                      ),
                    ),

                    const SizedBox(height: 4),

                    Row(
                      children: [
                        Image.asset(
                          'assets/DSD/icon/icon date.png',
                          width: 14,
                          color: AppColors.textgrey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          formatDate(item["docDate"] ?? ""),
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textgrey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              /// 🔹 IMAGE
              Expanded(
                flex: 3,
                child: SizedBox(
                  height: 120,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      item["imageUrl"] ?? "",
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.image_not_supported),
                        );
                      },
                    ),
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
