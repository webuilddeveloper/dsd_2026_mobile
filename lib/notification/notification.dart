// import 'package:dsd/blank_page/appbar.dart';
// import 'package:dsd/blank_page/format.dart';
// import 'package:dsd/notification/notification_detail.dart';
// import 'package:dsd/notification/notification_preferences.dart';
// import 'package:dsd/shared/locale_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:dsd/shared/api_provider.dart';
// import 'package:dsd/shared/app_strings.dart';
// import 'package:dsd/style_theme.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_html/flutter_html.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// class NotificationList extends StatefulWidget {
//   final Function(int)? onTabChange;
//   final bool pushedFromPage;

//   const NotificationList({
//     super.key,
//     this.onTabChange,
//     this.pushedFromPage = false,
//     this.preferences,
//     this.fetch,
//   });

//   final NotificationPreferences? preferences;
//   final Future<List<Map<String, dynamic>>> Function(String api, String type)?
//   fetch;

//   @override
//   State<NotificationList> createState() => _NotificationListState();
// }

// class _NotificationListState extends State<NotificationList> {
//   late final NotificationPreferences _preferences;
//   String _enabledSignature = '';
//   int _request = 0;
//   final storage = FlutterSecureStorage();
//   String selectType = "1";

//   List<Map<String, dynamic>> allNotifications = [];
//   List<Map<String, dynamic>> notifications = [];
//   bool isLoading = true;

//   final List<Map<String, dynamic>> category = [
//     {
//       "type": "1",
//       "name": "ทั้งหมด",
//       "icon": "assets/DSD/icon/icon_send.png",
//       "color": "0xFFBB439C",
//     },
//     ...notificationTypes,
//   ];

//   // แทน switch-case ด้วย Map อ่านง่ายกว่า
//   final Map<String, String> apiByType = {
//     "2": newsApi,
//     "3": trainingApi,
//     "4": skilledLaborApi,
//     "5": privilegeApi,
//   };

//   void goBack() {
//     if (widget.pushedFromPage) {
//       Navigator.pop(context);
//     } else {
//       widget.onTabChange?.call(0);
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _preferences = widget.preferences ?? NotificationPreferences.shared;
//     _initialize();
//   }

//   Future<void> _initialize() async {
//     await _preferences.load();
//     if (!mounted) return;
//     _enabledSignature = _preferences.enabledSignature;
//     _preferences.addListener(_preferencesChanged);
//     await loadAllData();
//   }

//   void _preferencesChanged() {
//     if (!mounted || _enabledSignature == _preferences.enabledSignature) return;
//     _enabledSignature = _preferences.enabledSignature;
//     if (selectType != '1' && !_preferences.typeEnabled(selectType)) {
//       selectType = '1';
//     }
//     loadAllData();
//   }

//   @override
//   void dispose() {
//     _preferences.removeListener(_preferencesChanged);
//     super.dispose();
//   }

//   List<Map<String, dynamic>> get visibleCategories =>
//       category
//           .where(
//             (c) =>
//                 c['type'] == '1'
//                     ? _preferences.enabledSignature.isNotEmpty
//                     : _preferences.typeEnabled(c['type']),
//           )
//           .toList();

//   void _filterData() {
//     if (selectType == "1") {
//       notifications =
//           allNotifications
//               .where((e) => _preferences.typeEnabled(e["type"].toString()))
//               .toList(); // ป้องกัน reference เดียวกัน
//     } else {
//       notifications =
//           allNotifications
//               .where(
//                 (e) =>
//                     e["type"].toString() == selectType &&
//                     _preferences.typeEnabled(selectType),
//               )
//               .toList();
//     }
//   }

//   Future<List<Map<String, dynamic>>> _fetch(String api, String type) async {
//     if (widget.fetch != null) {
//       final rows = await widget.fetch!(api, type);
//       return rows.map((e) => _normalize(e, type)).toList();
//     }
//     final profilecode = await storage.read(key: 'profileCode');
//     final res = await postDio('${api}read', {"profilecode": profilecode});

//     return (res as List).map((e) => _normalize(e, type)).toList();
//   }

//   Map<String, dynamic> _normalize(Map<String, dynamic> e, String type) {
//     return {
//       ...e,
//       "type": type,
//       "title": e['title'] ?? '',
//       "description": e['description'] ?? '',
//       "imageUrl": e['imageUrl'] ?? '',
//       "docDate": e['docDate'] ?? '',
//       "isRead": e['isRead'],
//       "code": e['code'] ?? '',
//     };
//   }

//   Future<void> loadAllData() async {
//     final request = ++_request;
//     setState(() {
//       isLoading = true;
//       notifications = [];
//       allNotifications = [];
//     });

//     try {
//       final results = await Future.wait([
//         for (final entry in apiByType.entries)
//           if (_preferences.typeEnabled(entry.key))
//             _fetch(entry.value, entry.key),
//       ]);
//       if (!mounted || request != _request) return;

//       allNotifications = results.expand((e) => e).toList();
//       allNotifications.sort(
//         (a, b) => (b["docDate"] ?? "").compareTo(a["docDate"] ?? ""),
//       );

//       _filterData();
//     } catch (e) {
//       debugPrint("loadAllData error: $e");
//     } finally {
//       if (mounted && request == _request) {
//         setState(() => isLoading = false); // ป้องกัน setState หลัง dispose
//       }
//     }
//   }

//   int getCount(String type) {
//     if (type == "1") {
//       // นับทุก type ที่ยังไม่อ่าน
//       return allNotifications.where((e) => e["isRead"] == false).length;
//     }
//     // นับเฉพาะ type นั้นที่ยังไม่อ่าน
//     return allNotifications
//         .where((e) => e["type"].toString() == type && e["isRead"] == false)
//         .length;
//   }

//   Future<void> markAsRead(Map<String, dynamic> item) async {
//     try {
//       final api = apiByType[item["type"].toString()] ?? newsApi;
//       final profilecode = await storage.read(key: 'profileCode');
//       await postDio('${api}read', {
//         "code": item["code"],
//         "profilecode": profilecode,
//       });
//     } catch (e) {
//       debugPrint("markAsRead error: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final language = AppStrings.of(context);
//     final thai = context.watch<LocaleProvider>().locale.languageCode == 'th';
//     final categories = visibleCategories;
//     return Scaffold(
//       appBar: appBar(
//         title: language.notification,
//         backBtn: true,
//         rightBtn: false,
//         backAction: goBack,
//       ),
//       body: SafeArea(
//         top: false,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
//           child:
//               isLoading
//                   ? const Center(child: CircularProgressIndicator())
//                   : Column(
//                     children: [
//                       /// CATEGORY
//                       if (categories.isNotEmpty)
//                         SizedBox(
//                           height: 100,
//                           child: ListView.builder(
//                             scrollDirection: Axis.horizontal,
//                             itemCount: categories.length,
//                             itemBuilder: (context, index) {
//                               final c = categories[index];
//                               final isSelected = c["type"] == selectType;
//                               final count = getCount(c["type"]);
//                               return GestureDetector(
//                                 onTap: () {
//                                   setState(() {
//                                     selectType = c["type"];
//                                     _filterData();
//                                   });
//                                 },
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(right: 12),
//                                   child: Column(
//                                     children: [
//                                       Stack(
//                                         children: [
//                                           Container(
//                                             height: isSelected ? 70 : 55,
//                                             width: isSelected ? 70 : 55,
//                                             decoration: BoxDecoration(
//                                               color: Color(
//                                                 int.parse(c["color"]),
//                                               ),
//                                               borderRadius:
//                                                   BorderRadius.circular(
//                                                     isSelected ? 35 : 30,
//                                                   ),
//                                             ),
//                                             child: Center(
//                                               child: Image.asset(
//                                                 c["icon"],
//                                                 width: 28,
//                                                 color: Colors.white,
//                                               ),
//                                             ),
//                                           ),

//                                           if (count > 0)
//                                             Positioned(
//                                               top: 0,
//                                               right: 0,
//                                               child: Container(
//                                                 height: 19,
//                                                 width: 19,
//                                                 decoration: const BoxDecoration(
//                                                   color: Colors.red,
//                                                   shape: BoxShape.circle,
//                                                 ),
//                                                 child: Center(
//                                                   child: Text(
//                                                     '$count',
//                                                     style: const TextStyle(
//                                                       color: Colors.white,
//                                                       fontSize: 10,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                         ],
//                                       ),
//                                       const SizedBox(height: 6),
//                                       Text(
//                                         thai ? c["name"] : c["nameEN"] ?? "All",
//                                         style: const TextStyle(fontSize: 12),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),

//                       const SizedBox(height: 16),

//                       /// LIST
//                       Expanded(
//                         child:
//                             notifications.isNotEmpty
//                                 ? ListView.builder(
//                                   itemCount: notifications.length,
//                                   itemBuilder:
//                                       (context, index) =>
//                                           _notiList(item: notifications[index]),
//                                 )
//                                 : Center(
//                                   child: Text(
//                                     _preferences.enabledSignature.isEmpty
//                                         ? (thai
//                                             ? 'ปิดการแสดงการแจ้งเตือนทุกประเภทแล้ว'
//                                             : 'All notification types are turned off')
//                                         : (thai
//                                             ? 'ยังไม่มีการแจ้งเตือน'
//                                             : 'No notifications yet'),
//                                   ),
//                                 ),
//                       ),
//                     ],
//                   ),
//         ),
//       ),
//     );
//   }

//   Widget _notiList({required Map<String, dynamic> item}) {
//     final bool isRead = item["isRead"] ?? false;

//     final categoryList = category.firstWhere(
//       (c) => c["type"] == item["type"],
//       orElse:
//           () => {
//             "color": AppColors.primary,
//             "icon": "assets/DSD/imgs/logo_app.png",
//           },
//     );

//     final Color categoryColor = Color(
//       int.tryParse(categoryList["color"].toString()) ?? 0xFFCCCCCC,
//     );

//     return InkWell(
//       onTap: () async {
//         setState(() => item["isRead"] = true);

//         await markAsRead(item);

//         if (!mounted) return;

//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => NotiDetail(noti: item)),
//         );
//       },

//       child: Container(
//         margin: const EdgeInsets.only(bottom: 12),
//         height: 150,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           color: isRead ? Color(0xFFEAEAEA) : const Color(0xFFFBE8C7),
//         ),

//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),

//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               /// 🔹 ICON + DOT
//               Stack(
//                 children: [
//                   Container(
//                     height: 35,
//                     width: 35,
//                     decoration: BoxDecoration(
//                       color: categoryColor,
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Center(
//                       child: Image.asset(
//                         categoryList["icon"],
//                         width: 18,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),

//                   if (!isRead)
//                     Positioned(
//                       top: 0,
//                       right: 0,
//                       child: Container(
//                         height: 9,
//                         width: 9,
//                         decoration: const BoxDecoration(
//                           color: Colors.red,
//                           shape: BoxShape.circle,
//                         ),
//                       ),
//                     ),
//                 ],
//               ),

//               const SizedBox(width: 8),

//               /// 🔹 TEXT SECTION
//               Expanded(
//                 flex: 6,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       item["title"] ?? "-",
//                       style: const TextStyle(fontWeight: FontWeight.w600),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),

//                     const SizedBox(height: 4),

//                     /// ✅ ใช้ Flexible กัน overflow
//                     Flexible(
//                       child: Html(
//                         data: item['description'] ?? "",
//                         style: {
//                           "body": Style(
//                             margin: Margins.zero,
//                             padding: HtmlPaddings.zero,
//                             maxLines: 3,
//                             textOverflow: TextOverflow.ellipsis,
//                             fontSize: FontSize(12),
//                             color: AppColors.textgrey,
//                           ),
//                         },
//                       ),
//                     ),

//                     const SizedBox(height: 4),

//                     Row(
//                       children: [
//                         Image.asset(
//                           'assets/DSD/icon/icon date.png',
//                           width: 14,
//                           color: AppColors.textgrey,
//                         ),
//                         const SizedBox(width: 4),
//                         Text(
//                           formatDate(item["docDate"] ?? ""),
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: AppColors.textgrey,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(width: 8),

//               /// 🔹 IMAGE
//               Expanded(
//                 flex: 3,
//                 child: SizedBox(
//                   height: 120,
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(8),
//                     child:
//                         (item["imageUrl"] as String? ?? '').trim().isEmpty
//                             ? Container(
//                               color: Colors.grey[300],
//                               child: const Icon(Icons.image_not_supported),
//                             )
//                             : Image.network(
//                               item["imageUrl"],
//                               fit: BoxFit.contain,
//                               errorBuilder: (context, error, stackTrace) {
//                                 return Container(
//                                   color: Colors.grey[300],
//                                   child: const Icon(Icons.image_not_supported),
//                                 );
//                               },
//                             ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';

import 'package:dsd/blank_page/appbar.dart';
import 'package:dsd/blank_page/format.dart';
import 'package:dsd/notification/notification_detail.dart';
import 'package:dsd/notification/notification_preferences.dart';
import 'package:dsd/shared/locale_provider.dart';
import 'package:provider/provider.dart';
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
    this.preferences,
    this.fetch,
    this.read,
  });

  final NotificationPreferences? preferences;
  final Future<List<Map<String, dynamic>>> Function(String api, String type)?
  fetch;

  final Future<void> Function(Map<String, dynamic> item)? read;

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  // 🔹 สีเน้นสำหรับโหมดเลือกรายการ ใช้สีจากธีมของแอปโดยตรง
  static const Color _selectionAccent = AppColors.primarysecond;

  late final NotificationPreferences _preferences;
  String _enabledSignature = '';
  int _request = 0;
  final storage = FlutterSecureStorage();
  String selectType = "1";

  List<Map<String, dynamic>> allNotifications = [];
  List<Map<String, dynamic>> notifications = [];
  bool isLoading = true;

  // 🔹 multi-select (long-press) state
  static const _deletedCodesKey = 'deletedNotificationCodes';
  bool _selectionMode = false;
  bool _processing = false;
  final Set<Map<String, dynamic>> _selectedItems = {};
  final Set<String> _deletedCodes =
      {}; // เก็บรายการที่ลบไปแล้ว กันเด้งกลับหลัง reload

  final List<Map<String, dynamic>> category = [
    {
      "type": "1",
      "name": "ทั้งหมด",
      "icon": "assets/DSD/icon/icon_send.png",
      "color": "0xFFBB439C",
    },
    ...notificationTypes,
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
    _preferences = widget.preferences ?? NotificationPreferences.shared;
    _initialize();
  }

  Future<void> _initialize() async {
    await _preferences.load();
    await _loadDeletedCodes();
    if (!mounted) return;
    _enabledSignature = _preferences.enabledSignature;
    _preferences.addListener(_preferencesChanged);
    await loadAllData();
  }

  void _preferencesChanged() {
    if (!mounted || _enabledSignature == _preferences.enabledSignature) return;
    _enabledSignature = _preferences.enabledSignature;
    if (selectType != '1' && !_preferences.typeEnabled(selectType)) {
      selectType = '1';
    }
    loadAllData();
  }

  @override
  void dispose() {
    _preferences.removeListener(_preferencesChanged);
    super.dispose();
  }

  List<Map<String, dynamic>> get visibleCategories =>
      category
          .where(
            (c) =>
                c['type'] == '1'
                    ? _preferences.enabledSignature.isNotEmpty
                    : _preferences.typeEnabled(c['type']),
          )
          .toList();

  void _filterData() {
    if (selectType == "1") {
      notifications =
          allNotifications
              .where((e) => _preferences.typeEnabled(e["type"].toString()))
              .toList(); // ป้องกัน reference เดียวกัน
    } else {
      notifications =
          allNotifications
              .where(
                (e) =>
                    e["type"].toString() == selectType &&
                    _preferences.typeEnabled(selectType),
              )
              .toList();
    }
  }

  Future<List<Map<String, dynamic>>> _fetch(String api, String type) async {
    if (widget.fetch != null) {
      final rows = await widget.fetch!(api, type);
      return rows
          .map((e) => _normalize(e, type))
          .where((e) => !_deletedCodes.contains(_itemKey(e)))
          .toList();
    }
    final profilecode = await storage.read(key: 'profileCode');
    final res = await postDio('${api}read', {"profilecode": profilecode});

    return (res as List)
        .map((e) => _normalize(e, type))
        .where((e) => !_deletedCodes.contains(_itemKey(e)))
        .toList();
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
    final request = ++_request;
    setState(() {
      isLoading = true;
      notifications = [];
      allNotifications = [];
      _selectionMode = false;
      _selectedItems.clear();
    });

    try {
      final results = await Future.wait([
        for (final entry in apiByType.entries)
          if (_preferences.typeEnabled(entry.key))
            _fetch(entry.value, entry.key),
      ]);
      if (!mounted || request != _request) return;

      allNotifications = results.expand((e) => e).toList();
      allNotifications.sort(
        (a, b) => (b["docDate"] ?? "").compareTo(a["docDate"] ?? ""),
      );

      _filterData();
    } catch (e) {
      debugPrint("loadAllData error: $e");
    } finally {
      if (mounted && request == _request) {
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

  Future<bool> markAsRead(Map<String, dynamic> item) async {
    try {
      if (widget.read != null) {
        await widget.read!(item);
        return true;
      }
      final api = apiByType[item["type"].toString()] ?? newsApi;
      final profilecode = await storage.read(key: 'profileCode');
      await postDio('${api}read', {
        "code": item["code"],
        "profilecode": profilecode,
      });
      return true;
    } catch (e) {
      debugPrint("markAsRead error: $e");
      return false;
    }
  }

  // ============ SELECTION MODE (Edit / long-press) ============

  /// key เอกลักษณ์ของแต่ละรายการ ใช้ type+code กันชนกันข้าม type ที่ code ซ้ำกันได้
  String _itemKey(Map<String, dynamic> e) => '${e["type"]}_${e["code"] ?? ''}';

  bool get _allSelected =>
      notifications.isNotEmpty &&
      notifications.every((e) => _selectedItems.contains(e));

  /// จริงหรือไม่ว่ารายการที่เลือกทั้งหมด "อ่านแล้ว" อยู่แล้ว (ใช้ปิดปุ่ม "อ่านแล้ว")
  bool get _allSelectedRead =>
      _selectedItems.isNotEmpty &&
      _selectedItems.every((e) => e["isRead"] == true);

  void _toggleSelected(Map<String, dynamic> item) {
    if (_processing) return;
    setState(() {
      if (_selectedItems.contains(item)) {
        _selectedItems.remove(item);
      } else {
        _selectedItems.add(item);
      }
    });
  }

  void _toggleSelectAll() {
    if (_processing) return;
    setState(() {
      if (_allSelected) {
        _selectedItems.clear();
      } else {
        _selectedItems
          ..clear()
          ..addAll(notifications);
      }
    });
  }

  void _exitSelectionMode() {
    if (_processing) return;
    setState(() {
      _selectionMode = false;
      _selectedItems.clear();
    });
  }

  Future<void> _markSelectedAsRead() async {
    if (_processing || _selectedItems.isEmpty) return;
    final items = _selectedItems.where((e) => e['isRead'] != true).toList();
    setState(() => _processing = true);
    var failures = 0;
    for (final item in items) {
      final success = await markAsRead(item);
      if (!mounted) return;
      if (success) {
        item['isRead'] = true;
        _selectedItems.remove(item);
      } else {
        failures++;
      }
    }
    if (!mounted) return;
    setState(() {
      _processing = false;
      if (failures == 0) {
        _selectedItems.clear();
        _selectionMode = false;
      }
    });
    if (failures > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppStrings.of(
              context,
            ).notificationReadFailed.replaceAll('{count}', failures.toString()),
          ),
        ),
      );
    }
  }

  Future<void> _confirmDeleteSelected() async {
    if (_processing || _selectedItems.isEmpty) return;
    final count = _selectedItems.length;

    final language = AppStrings.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      builder:
          (dialogContext) => Dialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    language.notificationDeleteTitle,
                    style: const TextStyle(
                      fontFamily: 'Sarabun',
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    language.notificationDeleteMessage.replaceAll(
                      '{count}',
                      count.toString(),
                    ),
                    style: const TextStyle(
                      fontFamily: 'Sarabun',
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.grey.shade600,
                            side: BorderSide(color: Colors.grey.shade300),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () => Navigator.pop(dialogContext, false),
                          child: Text(
                            language.cancel,
                            style: const TextStyle(fontFamily: 'Sarabun'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () => Navigator.pop(dialogContext, true),
                          child: Text(
                            language.notificationDelete,
                            style: const TextStyle(
                              fontFamily: 'Sarabun',
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
    );

    if (confirmed == true && mounted) {
      await _deleteSelected();
    }
  }

  /// ⚠️ ไม่มี delete API ในโค้ดตอนนี้ จึงลบได้แค่ใน local state (allNotifications)
  /// เท่านั้น พร้อมจำ code ที่ลบไว้ใน secure storage กัน fetch รอบถัดไปดึงกลับมา
  /// โผล่ซ้ำ — ถ้ามี API ลบจริงในอนาคต ให้เรียก API ตรงนี้ก่อน removeWhere ด้านล่าง
  Future<void> _deleteSelected() async {
    if (_processing) return;
    final items = _selectedItems.toSet();
    final keys =
        items
            .where((e) => (e['code'] ?? '').toString().isNotEmpty)
            .map(_itemKey)
            .toSet();
    setState(() => _processing = true);
    try {
      await storage.write(
        key: _deletedCodesKey,
        value: jsonEncode({..._deletedCodes, ...keys}.toList()),
      );
      if (!mounted) return;
      setState(() {
        allNotifications.removeWhere(items.contains);
        _deletedCodes.addAll(keys);
        _selectedItems.clear();
        _selectionMode = false;
        _filterData();
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppStrings.of(context).notificationDeleteFailed),
        ),
      );
    } finally {
      if (mounted) setState(() => _processing = false);
    }
  }

  Future<void> _loadDeletedCodes() async {
    try {
      final raw = await storage.read(key: _deletedCodesKey);
      if (raw == null || raw.isEmpty) return;
      final list = (jsonDecode(raw) as List).map((e) => e.toString());
      _deletedCodes.addAll(list);
    } catch (e) {
      debugPrint("loadDeletedCodes error: $e");
    }
  }

  PreferredSizeWidget _buildAppBar(bool thai) {
    return appBar(
      title: AppStrings.of(context).notification,
      backBtn: true,
      rightBtn: !isLoading && notifications.isNotEmpty,
      rightWidget:
          !isLoading && notifications.isNotEmpty
              ? (_selectionMode
                  ? TextButton(
                    onPressed: _processing ? null : _exitSelectionMode,
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF856119),
                    ),
                    child: Text(AppStrings.of(context).cancel),
                  )
                  : IconButton(
                    tooltip: AppStrings.of(context).notificationEdit,
                    onPressed: () => setState(() => _selectionMode = true),
                    color: const Color(0xFF856119),
                    icon: const Icon(Icons.edit_outlined, size: 22),
                  ))
              : null,
      righttitle:
          _selectionMode
              ? (AppStrings.of(context).cancel)
              : (AppStrings.of(context).notificationEdit),
      rightAction: () {
        if (_processing) return;
        if (_selectionMode) {
          _exitSelectionMode();
        } else {
          setState(() => _selectionMode = true);
        }
      },
      backAction: _selectionMode ? _exitSelectionMode : goBack,
    );
  }

  Widget _buildSelectAll(bool thai) {
    if (!_selectionMode) return const SizedBox.shrink();
    return Row(
      children: [
        Expanded(
          child: Text(
            AppStrings.of(context).notificationSelectedCount.replaceAll(
              '{count}',
              _selectedItems.length.toString(),
            ),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF514B40),
            ),
          ),
        ),
        TextButton.icon(
          onPressed:
              _processing || notifications.isEmpty ? null : _toggleSelectAll,
          icon: Icon(
            _allSelected ? Icons.check_box : Icons.check_box_outline_blank,
            size: 20,
          ),
          label: Text(
            _allSelected
                ? (AppStrings.of(context).notificationDeselectAll)
                : (AppStrings.of(context).notificationSelectAll),
          ),
          style: TextButton.styleFrom(
            foregroundColor: _selectionAccent,
            textStyle: const TextStyle(fontSize: 13),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectionActionBar(bool thai) {
    if (!_selectionMode) return const SizedBox.shrink();
    final all = _allSelected;
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Material(
        key: const Key('notification-selection-actions'),
        elevation: 0,
        shadowColor: Colors.black.withValues(alpha: 0.12),
        type: MaterialType.transparency,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_processing) ...[
                const LinearProgressIndicator(),
                const SizedBox(height: 10),
              ],
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed:
                          _processing ||
                                  _selectedItems.isEmpty ||
                                  _allSelectedRead
                              ? null
                              : _markSelectedAsRead,
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFF3D5),
                        foregroundColor: const Color(0xFF785817),
                        disabledBackgroundColor: const Color(0xFFFFF3D5),
                        disabledForegroundColor: const Color(0xFF785817),
                        side: const BorderSide(color: Color(0xFFD5AA48)),
                        minimumSize: const Size(0, 40),
                        textStyle: const TextStyle(fontSize: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: Icon(
                        _allSelectedRead
                            ? Icons.done_all_rounded
                            : Icons.mark_email_read_outlined,
                        size: 18,
                      ),
                      label: Text(
                        all
                            ? (AppStrings.of(context).notificationReadAll)
                            : (AppStrings.of(context).notificationRead),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed:
                          _processing || _selectedItems.isEmpty
                              ? null
                              : _confirmDeleteSelected,
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFFFF0EE),
                        side: const BorderSide(color: Color(0xFFD99690)),
                        foregroundColor: const Color(0xFFBA3B32),
                        disabledBackgroundColor: const Color(0xFFF4F3F0),
                        disabledForegroundColor: const Color(0xFF8D8980),
                        minimumSize: const Size(0, 40),
                        textStyle: const TextStyle(fontSize: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.delete_outline, size: 18),
                      label: Text(
                        all
                            ? (AppStrings.of(context).notificationDeleteAll)
                            : (AppStrings.of(context).notificationDelete),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final thai = context.watch<LocaleProvider>().locale.languageCode == 'th';
    final categories = visibleCategories;
    // 🔹 ดักปุ่ม/ท่าทางย้อนกลับของระบบ (hardware back / swipe back)
    // ถ้ายังอยู่ในโหมดเลือก ให้ออกจากโหมดเลือกก่อน ไม่ปล่อยให้ pop ออกจากหน้านี้เลย
    return PopScope(
      canPop: !_selectionMode,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_selectionMode) _exitSelectionMode();
      },
      child: Scaffold(
        appBar: _buildAppBar(thai),
        body: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
            child:
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                      children: [
                        /// CATEGORY
                        if (categories.isNotEmpty)
                          SizedBox(
                            height: 88,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: categories.length,
                              itemBuilder: (context, index) {
                                final c = categories[index];
                                final isSelected = c["type"] == selectType;
                                final count = getCount(c["type"]);
                                return GestureDetector(
                                  onTap: () {
                                    if (_processing) return;
                                    setState(() {
                                      _selectedItems.clear();
                                      selectType = c["type"];
                                      _filterData();
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Column(
                                      children: [
                                        Stack(
                                          children: [
                                            Container(
                                              height: isSelected ? 60 : 48,
                                              width: isSelected ? 60 : 48,
                                              decoration: BoxDecoration(
                                                color: Color(
                                                  int.parse(c["color"]),
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      isSelected ? 30 : 24,
                                                    ),
                                              ),
                                              child: Center(
                                                child: Image.asset(
                                                  c["icon"],
                                                  width: 24,
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
                                                  decoration:
                                                      const BoxDecoration(
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
                                        const SizedBox(height: 5),
                                        Text(
                                          thai
                                              ? c["name"]
                                              : c["nameEN"] ?? "All",
                                          style: const TextStyle(fontSize: 11),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                        AnimatedSize(
                          duration: const Duration(milliseconds: 150),
                          child: _buildSelectAll(thai),
                        ),

                        /// LIST
                        Expanded(
                          child:
                              notifications.isNotEmpty
                                  ? ListView.builder(
                                    itemCount: notifications.length,
                                    itemBuilder:
                                        (context, index) => _notiList(
                                          item: notifications[index],
                                        ),
                                  )
                                  : Center(
                                    child: Text(
                                      _preferences.enabledSignature.isEmpty
                                          ? AppStrings.of(
                                            context,
                                          ).notificationDisabled
                                          : (AppStrings.of(
                                            context,
                                          ).notificationEmpty),
                                    ),
                                  ),
                        ),
                        _buildSelectionActionBar(thai),
                      ],
                    ),
          ),
        ),
      ),
    );
  }

  Widget _notiList({required Map<String, dynamic> item}) {
    final bool isRead = item["isRead"] ?? false;
    final bool isSelected = _selectedItems.contains(item);

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
        if (_selectionMode) {
          _toggleSelected(item);
          return;
        }

        final success = await markAsRead(item);
        if (!mounted) return;
        if (success) setState(() => item["isRead"] = true);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NotiDetail(noti: item)),
        );
      },
      onLongPress: () {
        if (_selectionMode) return;
        setState(() {
          _selectionMode = true;
          _selectedItems.add(item);
        });
      },

      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isRead ? const Color(0xFFEAEAEA) : const Color(0xFFFBE8C7),
          border:
              isSelected ? Border.all(color: _selectionAccent, width: 2) : null,
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
                      child:
                          _selectionMode
                              ? Icon(
                                isSelected
                                    ? Icons.check_rounded
                                    : Icons.radio_button_unchecked,
                                color: Colors.white,
                                size: 22,
                              )
                              : Image.asset(
                                categoryList["icon"],
                                width: 18,
                                color: Colors.white,
                              ),
                    ),
                  ),

                  if (!isRead && !_selectionMode)
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
                    child:
                        (item["imageUrl"] as String? ?? '').trim().isEmpty
                            ? Container(
                              color: Colors.grey[300],
                              child: const Icon(Icons.image_not_supported),
                            )
                            : Image.network(
                              item["imageUrl"],
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
