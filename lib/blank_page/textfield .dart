import 'package:dsd/style_theme.dart';
import 'package:flutter/material.dart';

Widget buildSearch({
  required TextEditingController controller,
  required String hintText,
  bool rightBtn = false,
  VoidCallback? onFilterTap,
  Function(String)? onChanged,
}) {
  return TextField(
    controller: controller,
    onChanged: onChanged, // 👈
    decoration: InputDecoration(
      // 🔍 ซ้าย
      prefixIcon: Padding(
        padding: const EdgeInsets.all(10),
        child: Image.asset('assets/DSD/icon/icon_search.png', width: 24),
      ),

      // 🔥 ขวา (filter)
      suffixIcon:
          rightBtn
              ? GestureDetector(
                onTap: onFilterTap,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(
                    'assets/DSD/icon/icon_filter.png', // 👈 เปลี่ยนเป็น path ของคุณ
                    width: 20,
                  ),
                ),
              )
              : null,
      hintText: hintText,
      hintStyle: TextStyle(color: AppColors.textDark),

      filled: true,
      fillColor: Colors.white,

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: AppColors.borderColor),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: AppColors.borderColor),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: AppColors.primary, width: 1.5),
      ),

      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
    ),
  );
}
