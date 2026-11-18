import 'package:flutter/material.dart';

// التحكم في الوضع الليلي.
final ValueNotifier<bool> isDarkModeNotifier =
    ValueNotifier<bool>(false);

// التحكم في لغة التطبيق.
final ValueNotifier<bool> iYERabicNotifier =
    ValueNotifier<bool>(true);

// الألوان الموحدة المستخدمة في جميع الشاشات.
class AppColors {
  static Color get primaryBlue => Colors.blue.shade600;

  static Color get accentBlue => Colors.blue.shade100;

  static Color get navyDark => const Color(0xFF0F172A);

  static Color get background =>
      isDarkModeNotifier.value
          ? const Color(0xFF121212)
          : const Color(0xFFF8F9FA);

  static Color get cardColor =>
      isDarkModeNotifier.value
          ? const Color(0xFF1E1E1E)
          : Colors.white;

  static Color get textDark =>
      isDarkModeNotifier.value
          ? Colors.white
          : const Color(0xFF1E293B);

  static Color get textMuted => Colors.grey.shade500;
}

// النصوص والترجمة حسب اللغة المختارة.
class AppStrings {
  static bool get iYERabic => iYERabicNotifier.value;

  static String get(String ar, String en) =>
      iYERabic ? ar : en;
}