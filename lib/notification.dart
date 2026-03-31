import 'package:dsd/blank_page/appbar.dart';
import 'package:dsd/blank_page/dialog_fail.dart';
import 'package:dsd/model/notification_data.dart';
import 'package:dsd/noti_detail.dart';
import 'package:dsd/style_theme.dart';
import 'package:flutter/material.dart';

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
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void goBack() {
    if (widget.pushedFromPage) {
      Navigator.pop(context); // มาจาก ServiceAllPage → pop กลับ
    } else {
      widget.onTabChange?.call(0); // มาจาก Menu/Home → switch tab
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        title: "การแจ้งเตือน",
        backBtn: true,
        rightBtn: false,
        backAction: () => goBack(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          children: [
            // 🔥 อ่านทั้งหมด
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    showCustomDialog(
                      context,
                      title: 'อ่านทั้งหมด',
                      description:
                          "คุณต้องการทำเครื่องหมายว่าอ่านแล้ว สำหรับการแจ้งเตือนต่างๆหรือไม่ หากยืนยันจะไม่สามารถย้อนกลับได้",
                      onConfirm: () {
                        setState(() {
                          for (var i in notifications) {
                            i.isRead = true;
                          }
                        });
                      },
                    );
                  },
                  child: Text(
                    notifications.where((e) => !e.isRead).isEmpty
                        ? 'อ่านทั้งหมด'
                        : 'อ่านทั้งหมด (${notifications.where((e) => !e.isRead).length})',
                    style: TextStyle(fontSize: 12, color: AppColors.primary),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 🔥 ต้องใช้ Expanded ตรงนี้ (ไม่อยู่ใน ScrollView)
            Expanded(
              child: ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final i = notifications[index];
                  return _notiList(item: i);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _notiList({required NotificationModel item}) {
    return InkWell(
      onTap: () {
        setState(() {
          item.isRead = true; // ✅ อัปเดต UI
        });

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NotiDetail(noti: item)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: item.isRead ? Colors.grey[200] : const Color(0xFFFBE8C7),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔴 dot
              if (!item.isRead)
                Container(
                  margin: const EdgeInsets.only(top: 6),
                  height: 9,
                  width: 9,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                ),

              const SizedBox(width: 8),

              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ข่าวประชาสัมพันธ์',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      item.description,
                      style: const TextStyle(fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: AppColors.textgrey,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          item.date,
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
              Expanded(
                flex: 3,
                child: SizedBox(
                  height: 120,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(item.image, fit: BoxFit.cover),
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
