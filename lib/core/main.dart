import 'package:flutter/material.dart';

import '../login_screen.dart'; // استدعاء شاشة الدخول من خارج مجلد core

// ==========================================
// 1. متغيرات التحكم باللغة والوضع الليلي
// ==========================================
final ValueNotifier<bool> isDarkModeNotifier = ValueNotifier<bool>(false);
final ValueNotifier<bool> iYERabicNotifier = ValueNotifier<bool>(true);

// ==========================================
// 2. الألوان الموحدة للتطبيق
// ==========================================
class AppColors {
  static Color get primaryBlue => Colors.blue.shade600;
  static Color get accentBlue => Colors.blue.shade100; // ⬅️ تمت إضافته هنا
  static Color get navyDark => const Color(0xFF0F172A);
  static Color get background => isDarkModeNotifier.value
      ? const Color(0xFF121212)
      : const Color(0xFFF8F9FA);
  static Color get cardColor =>
      isDarkModeNotifier.value ? const Color(0xFF1E1E1E) : Colors.white;
  static Color get textDark =>
      isDarkModeNotifier.value ? Colors.white : const Color(0xFF1E293B);
  static Color get textMuted => Colors.grey.shade500;
}

// ==========================================
// 3. نصوص التطبيق والترجمة
// ==========================================
class AppStrings {
  static bool get iYERabic => iYERabicNotifier.value;
  static String get(String ar, String en) => iYERabic ? ar : en;
}

// ==========================================
// 4. نقطة انطلاق التطبيق
// ==========================================
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDark, _) {
        return ValueListenableBuilder<bool>(
          valueListenable: iYERabicNotifier,
          builder: (context, iYERabic, _) {
            return MaterialApp(
              title: 'LaundryFlow',
              debugShowCheckedModeBanner: false,
              builder: (context, child) {
                return Directionality(
                  textDirection: iYERabic
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  child: child!,
                );
              },
              theme: ThemeData(
                brightness: isDark ? Brightness.dark : Brightness.light,
                primaryColor: AppColors.primaryBlue,
                scaffoldBackgroundColor: AppColors.background,
                fontFamily: 'Cairo',
              ),
              // التوجيه المباشر لشاشة تسجيل الدخول
              home: const LoginScreen(),
            );
          },
        );
      },
    );
  }
}
