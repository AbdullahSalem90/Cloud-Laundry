import 'package:flutter/material.dart';
import 'package:laundry_flow/admin/dashboard_screen.dart';

import '../core/app_data.dart';
import '../core/app_constants.dart';
import '../customer/customer_home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();

  void _submit() {
    final phone = _phoneController.text.trim();

    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppStrings.get(
              'الرجاء إدخال رقم الجوال',
              'Please enter phone number',
            ),
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // دخول المدير
    if (phone == '0777') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardScreen(onToggleLanguage: () {}),
        ),
      );
      return;
    }

    // التحقق من رقم العميل
    final isAllowedCustomer =
        phone == '0555' ||
        AppData.customers.any((customer) => customer.phone.trim() == phone);

    // رفض الأرقام غير المسجلة
    if (!isAllowedCustomer) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppStrings.get(
              'رقم الجوال غير مسجل، يرجى مراجعة الإدارة',
              'Phone number is not registered',
            ),
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // دخول العميل
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const CustomerHomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navyDark,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // شعار التطبيق
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.local_laundry_service_rounded,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),

                const Text(
                  'LaundryFlow',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),

                Text(
                  AppStrings.get(
                    'المغسلة السحابية الذكية ☁️',
                    'Smart Cloud Laundry ☁️',
                  ),
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade300),
                ),
                const SizedBox(height: 48),

                // كارد تسجيل الدخول
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.cardColor,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.get('تسجيل الدخول', 'Sign In'),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 6),

                      Text(
                        AppStrings.get(
                          'أدخل رقم الجوال للمتابعة',
                          'Enter mobile number to continue',
                        ),
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // حقل رقم الجوال
                      TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        style: TextStyle(color: AppColors.textDark),
                        decoration: InputDecoration(
                          labelText: AppStrings.get(
                            'رقم الجوال',
                            'Phone Number',
                          ),
                          hintText: '967xxxxxxxx+',
                          prefixIcon: const Icon(Icons.phone_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // زر الدخول
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBlue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            AppStrings.get('دخول', 'Login'),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
