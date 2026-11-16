// مسار الملف: lib/login_screen.dart

import 'package:flutter/material.dart';
import 'package:laundry_flow/admin/dashboard_screen.dart';

import 'core/app_data.dart';
import 'core/main.dart';
import 'customer/customer_home_screen.dart';

// مسار شاشتك الأصلية

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController =
      TextEditingController(); // لصفحة إنشاء الحساب
  bool _isSignUp = false; // للتبديل بين تسجيل الدخول وإنشاء حساب

  void _submit() {
    final phone = _phoneController.text.trim();
    final name = _nameController.text.trim();

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

    // 🌟 حساب تجريبي خاص بالأدمن (مثلاً هذا الرقم يدخل مباشرة للوحة التحكم)
    if (phone == '0777' && !_isSignUp) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardScreen(onToggleLanguage: () {}),
        ), // ⬅️ التوجيه لشاشتك الأصلية
      );
      return;
    }

    // تسجيل دخول أو إنشاء حساب للعميل العادي
    if (_isSignUp && name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppStrings.get(
              'الرجاء إدخال الاسم الكريم',
              'Please enter your name',
            ),
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // إضافة العميل لقائمة العملاء لو كان تسجيل جديد
    if (_isSignUp) {
      AppData.customers.add(
        Customer(
          id: 'C${AppData.customers.length + 1}',
          name: name,
          phone: phone,
        ),
      );
    }

    // الانتقال لشاشة العميل الرئيسية
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

                // كارد الأداة (تسجيل الدخول / إنشاء حساب)
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
                        _isSignUp
                            ? AppStrings.get(
                                'إنشاء حساب جديد',
                                'Create Account',
                              )
                            : AppStrings.get('تسجيل الدخول', 'Sign In'),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _isSignUp
                            ? AppStrings.get(
                                'أدخل بياناتك لنبدأ خدمة غسيل ملابسك',
                                'Enter your details to start laundry service',
                              )
                            : AppStrings.get(
                                'أدخل رقم الجوال للمتابعة',
                                'Enter mobile number to continue',
                              ),
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // حقل الاسم (يظهر فقط في إنشاء الحساب)
                      if (_isSignUp) ...[
                        TextField(
                          controller: _nameController,
                          style: TextStyle(color: AppColors.textDark),
                          decoration: InputDecoration(
                            labelText: AppStrings.get(
                              'الاسم الكريم',
                              'Full Name',
                            ),
                            prefixIcon: const Icon(Icons.person_outline),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

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

                      // زر التنفيذ
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
                            _isSignUp
                                ? AppStrings.get('إنشاء الحساب', 'Sign Up')
                                : AppStrings.get('دخول', 'Login'),
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

                // زر التبديل بين تسجيل الدخول وإنشاء حساب
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isSignUp = !_isSignUp;
                    });
                  },
                  child: Text(
                    _isSignUp
                        ? AppStrings.get(
                            'لديك حساب بالفعل؟ تسجيل الدخول',
                            'Already have an account? Sign In',
                          )
                        : AppStrings.get(
                            'ليس لديك حساب؟ إنشاء حساب جديد',
                            'Don\'t have an account? Sign Up',
                          ),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 12),
                // تلميح تجريبي للأدمن
                Text(
                  AppStrings.get('💡 ', '💡 '),
                  style: TextStyle(fontSize: 11, color: Colors.amber.shade300),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
