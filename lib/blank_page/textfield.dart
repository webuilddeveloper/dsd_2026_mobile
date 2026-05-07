import 'package:dsd/style_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
                    'assets/DSD/icon/icon_filter.png',
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
 
 
Widget buildTextField({
  required TextEditingController controller,
  required String hint,
  required IconData icon,
  bool isSelect = true,
  TextInputType? keybord,
  List<TextInputFormatter>? inputFormatters,
  String? Function(String?)? validator,

  bool obscure = false,
  Widget? suffix,
}) {
  return TextFormField(
    controller: controller,
    obscureText: obscure,
    enabled: isSelect == true ? true : false,
    style: TextStyle(
      fontFamily: 'Kanit',
      fontSize: 14,
      color: isSelect == true ? AppColors.textgrey : AppColors.primary,
    ),
    keyboardType: keybord,

    inputFormatters: inputFormatters,
    validator: validator,
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        fontFamily: 'Kanit',
        fontSize: 13,
        color: isSelect == true ? AppColors.textgrey : AppColors.primary,
      ),
      prefixIcon: Icon(
        icon,
        size: 18,
        color: isSelect == true ? AppColors.textgrey : AppColors.primary,
      ),
      suffixIcon: suffix,
      filled: true,
      fillColor:
          isSelect == true ? Colors.white : AppColors.primary.withOpacity(0.4),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(
          color: isSelect == true ? AppColors.borderColor : AppColors.primary,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(
          color: isSelect == true ? AppColors.borderColor : AppColors.primary,
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(
          color: isSelect == true ? AppColors.borderColor : AppColors.primary,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: AppColors.primary, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
    ),
  );
}

Widget buildDateField({
  required BuildContext context,
  required TextEditingController controller,
  required String hint,
  DateTime? firstDate,
  DateTime? lastDate,
  Function(DateTime)? onDateSelected,
  String? Function(String?)? validator,
}) {
  Future<void> pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? DateTime(2100),
      locale: const Locale('th', 'TH'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.textDark,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                textStyle: const TextStyle(
                  fontFamily: 'Kanit',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      final year = picked.year; // ไม่ต้อง +543
      final day = picked.day.toString().padLeft(2, '0');
      final month = picked.month.toString().padLeft(2, '0');

      controller.text = '$year$month$day';
      onDateSelected?.call(picked);
    }
  }

  return TextFormField(
    controller: controller,
    readOnly: true,
    onTap: pickDate,
    style: const TextStyle(
      fontFamily: 'Kanit',
      fontSize: 14,
      color: AppColors.textDark,
    ),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        fontFamily: 'Kanit',
        fontSize: 13,
        color: AppColors.textgrey,
      ),
      prefixIcon: const Icon(
        Icons.calendar_today_outlined,
        size: 18,
        color: AppColors.textgrey,
      ),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: AppColors.borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: AppColors.borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
    ),
  );
}
