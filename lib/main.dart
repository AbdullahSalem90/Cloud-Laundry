import 'package:flutter/material.dart';

import 'auth/login_screen.dart';
import 'core/app_constants.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

// الواجهة الرئيسية التي تتحكم في إعدادات التطبيق.
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

              // أول شاشة تظهر عند تشغيل التطبيق.
              home: const LoginScreen(),
            );
          },
        );
      },
    );
  }
}
