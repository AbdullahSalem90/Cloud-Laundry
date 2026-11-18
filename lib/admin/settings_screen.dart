// مسار الملف: lib/settings_screen.dart

import 'package:flutter/material.dart';

import '../core/app_constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isNotificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.textDark),
        title: Text(
          AppStrings.get('إعدادات التطبيق', 'App Settings'),
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // 1. قسم المظهر (الدارك مود)
          _buildSectionHeader(AppStrings.get('المظهر', 'Appearance')),
          _buildSwitchTile(
            icon: Icons.dark_mode_rounded,
            title: AppStrings.get('الوضع الليلي (Dark Mode)', 'Dark Mode'),
            value: isDarkModeNotifier.value,
            onChanged: (val) {
              setState(() {
                isDarkModeNotifier.value = val;
              });
            },
          ),

          const SizedBox(height: 24),

          // 2. قسم الإشعارات
          _buildSectionHeader(AppStrings.get('الإشعارات', 'Notifications')),
          _buildSwitchTile(
            icon: Icons.notifications_active_rounded,
            title: AppStrings.get('تفعيل الإشعارات', 'Enable Notifications'),
            value: isNotificationsEnabled,
            onChanged: (val) {
              setState(() {
                isNotificationsEnabled = val;
              });
            },
          ),

          const SizedBox(height: 24),

          // 3. قسم اللغة
          _buildSectionHeader(AppStrings.get('اللغة', 'Language')),
          Container(
            decoration: BoxDecoration(
              color: AppColors.cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
            ),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.language_rounded,
                  color: AppColors.primaryBlue,
                ),
              ),
              title: Text(
                AppStrings.get('لغة التطبيق', 'App Language'),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              trailing: Text(
                AppStrings.iYERabic ? 'العربية' : 'English',
                style: TextStyle(color: AppColors.textMuted, fontSize: 14),
              ),
              onTap: () {
                setState(() {
                  iYERabicNotifier.value = !iYERabicNotifier.value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, right: 8, left: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.textDark,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        activeThumbColor:
            AppColors.primaryBlue, // ⬅️ تم التحديث هنا لمواكبة الإصدار الجديد
        secondary: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryBlue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primaryBlue),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
      ),
    );
  }
}
