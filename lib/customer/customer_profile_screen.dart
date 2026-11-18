// مسار الملف: lib/customer/customer_profile_screen.dart
// هذه الشاشة مسؤولة عن إعدادات حساب العميل واللغة والإشعارات وتسجيل الخروج.

import 'package:flutter/material.dart';

import '../core/app_constants.dart';
import '../auth/login_screen.dart';

class CustomerProfileScreen extends StatefulWidget {
  const CustomerProfileScreen({super.key});

  @override
  State<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            AppStrings.get('الملف الشخصي', 'Profile'),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 40),
          Expanded(
            child: Container(
              color: AppColors.cardColor,
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildProfileListTile(
                    title: AppStrings.get('تسجيل الدخول', 'Login'),
                    icon: Icons.person_outline,
                    onTap: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                  ),
                  _buildProfileListTile(
                    title: AppStrings.get('اللغة', 'Language'),
                    icon: Icons.translate_rounded,
                    trailingWidget: Text(
                      AppStrings.iYERabic ? 'العربية' : 'English',
                      style: TextStyle(
                        color: AppColors.primaryBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        iYERabicNotifier.value = !iYERabicNotifier.value;
                      });
                    },
                  ),
                  _buildProfileListTile(
                    title: AppStrings.get('الإشعارات', 'Notifications'),
                    icon: Icons.notifications_none_rounded,
                    trailingWidget: Switch(
                      value: _notificationsEnabled,
                      activeTrackColor: Colors.black, // ✅ لون مسار الزر
                      activeThumbColor: Colors.white,
                      onChanged: (val) {
                        setState(() {
                          _notificationsEnabled = val;
                        });
                      },
                    ),
                    onTap: null,
                  ),
                  _buildProfileListTile(
                    title: AppStrings.get('خدمة العملاء', 'Customer Service'),
                    icon: Icons.support_agent_rounded,
                    onTap: () {},
                  ),
                  _buildProfileListTile(
                    title: AppStrings.get('سياسة الخصوصية', 'Privacy Policy'),
                    icon: Icons.description_outlined,
                    onTap: () {},
                  ),
                  _buildProfileListTile(
                    title: AppStrings.get('تسجيل الخروج', 'Logout'),
                    icon: Icons.logout_rounded,
                    hideDivider: true, // إخفاء الخط تحت آخر زر
                    onTap: () {
                      // أمر تسجيل الخروج والعودة لشاشة البداية
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                        (Route<dynamic> route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileListTile({
    required String title,
    required IconData icon,
    Widget? trailingWidget,
    VoidCallback? onTap,
    bool hideDivider = false,
  }) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 4,
          ),
          onTap: onTap,
          leading: Icon(icon, color: AppColors.textDark, size: 26),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          trailing:
              trailingWidget ??
              Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 16,
                color: Colors.grey.shade400,
              ),
        ),
        if (!hideDivider)
          Divider(
            height: 1,
            indent: 24,
            endIndent: 24,
            color: Colors.grey.withValues(alpha: 0.2),
          ),
      ],
    );
  }
}
