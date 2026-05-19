// ignore_for_file: deprecated_member_use

import 'package:dsd/style_theme.dart';
import 'package:flutter/material.dart';

class AppBarHome extends StatelessWidget implements PreferredSizeWidget {
  final String name;
  final String memberType;
  final String imageUrl;
  final Widget? rightWidget;
  final VoidCallback? onProfileTap;

  const AppBarHome({
    super.key,
    required this.name,
    required this.memberType,
    required this.imageUrl,
    this.rightWidget,
    this.onProfileTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget build(BuildContext context) {
    const String defaultImage =
        'https://khubdeedlt.we-builds.com/khubdeedlt-document/images/contact-categoty/contact-categoty_263001888.png';

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 17),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: onProfileTap,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAFAFA),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(width: 1, color: AppColors.borderColor),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(
                        imageUrl.isNotEmpty ? imageUrl : defaultImage,
                        width: 32,
                        height: 32,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (_, __, ___) => Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.grey[300],
                              ),
                              child: const Icon(
                                Icons.person,
                                size: 20,
                                color: Colors.grey,
                              ),
                            ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          memberType,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 12),

            rightWidget ?? const SizedBox(),
          ],
        ),
      ),
    );
  }
}

appBar({
  String? title = "",
  bool backBtn = true,
  bool rightBtn = true,
  Function? rightAction,
  Function? backAction,
  String righttitle = "",
}) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(80), // 🔻 ลดความสูง
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(32),
            bottomRight: Radius.circular(32),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 17,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: SafeArea(
          bottom: false,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// 🔹 LEFT
              backBtn
                  ? GestureDetector(
                    onTap: () => backAction!(),
                    child: Container(
                      width: 40,
                      alignment: Alignment.center,
                      // padding: const EdgeInsets.symmetric(
                      //   horizontal: 12,
                      //   vertical: 10,
                      // ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAFAFA),
                        // borderRadius: BorderRadius.circular(22),
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 1,
                          color: const Color(0xFFDBDBDB),
                        ),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new, size: 15),
                    ),
                  )
                  : Container(width: 40),
              const SizedBox(width: 12),
              Expanded(
                child: Center(
                  child: Text(title!, style: const TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(width: 12),

              // / 🔔 RIGHT
              // ignore: unrelated_type_equality_checks
              rightBtn
                  // ? GestureDetector(
                  //   onTap: () => rightAction!(),
                  //   child: Container(
                  //     width: 40,
                  //     height: 40,
                  //     alignment: Alignment.center,
                  //     decoration: BoxDecoration(
                  //       color: const Color(0xFFFAFAFA),
                  //       shape: BoxShape.circle,
                  //       border: Border.all(
                  //         width: 1,
                  //         color: const Color(0xFFDBDBDB),
                  //       ),
                  //     ),
                  //     child: Icon(Icons.list_rounded, size: 18),
                  //   ),
                  // )
                  ? GestureDetector(
                    onTap: () => rightAction!(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAFAFA),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          width: 1,
                          color: const Color(0xFFDBDBDB),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.list_rounded, size: 18),
                          SizedBox(width: 4),
                          Text(righttitle, style: TextStyle(fontSize: 10)),
                        ],
                      ),
                    ),
                  )
                  : SizedBox(width: 40),
            ],
          ),
        ),
      ),
    ),
  );
}
