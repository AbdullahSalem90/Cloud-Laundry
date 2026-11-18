// مسار الملف: lib/analytics_screen.dart

import 'package:flutter/material.dart';

import '../core/app_data.dart';
import '../core/app_constants.dart';
import 'settings_screen.dart';
import '../auth/login_screen.dart'; 
import 'orders_screen.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  int get completedOrdersCount {
    return globalOrders.where((order) {
      final status = order.status.toString().trim();
      return status == 'مكتمل' ||
          status == 'Completed' ||
          status.contains('مكتمل');
    }).length;
  }

  double get totalRevenue {
    return globalOrders
        .where((order) {
          final status = order.status.toString().trim();
          return status == 'مكتمل' ||
              status == 'Completed' ||
              status.contains('مكتمل');
        })
        .fold(0.0, (sum, order) => sum + order.totalPrice);
  }

  @override
  Widget build(BuildContext context) {
    double totalRevenue = 0;
    int activeOrders = 0;
    int completedOrders = 0;

    for (var order in AppData.orders) {
      final isCompleted =
          order.status == 'completed' || order.status == 'delivered';

      if (isCompleted) {
        totalRevenue += order.totalPrice;
        completedOrders++;
      } else {
        activeOrders++;
      }
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.textDark),
        title: Text(
          AppStrings.get('المركز المالي', 'Financial Center'),
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E3A8A), Color(0xFF2563EB)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryBlue.withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppStrings.get(
                          'إجمالي الأرباح المحصلة',
                          'Total Collected Revenue',
                        ),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const Icon(
                        Icons.account_balance_wallet_rounded,
                        color: Colors.white70,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${totalRevenue.toStringAsFixed(0)} ${AppStrings.get('ر.ي', 'YER')}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.trending_up_rounded,
                          color: Colors.greenAccent,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          AppStrings.get(
                            'ارتفاع بنسبة +15% هذا الشهر',
                            'Up by +15% this month',
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    title: AppStrings.get('طلبات نشطة', 'Active Orders'),
                    value: activeOrders.toString(),
                    icon: Icons.autorenew_rounded,
                    color: Colors.orange.shade600,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    title: AppStrings.get('مكتمل', 'Completed'),
                    value: completedOrders.toString(),
                    icon: Icons.done_all_rounded,
                    color: Colors.green.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildWeeklySalesChart(),
            const SizedBox(height: 32),
            Text(
              AppStrings.get('إدارة النظام', 'System Management'),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 16),
            _buildActionTile(
              icon: Icons.dry_cleaning_rounded,
              title: AppStrings.get(
                'إدارة الخدمات والأسعار',
                'Manage Services & Prices',
              ),
            ),
            _buildActionTile(
              icon: Icons.people_alt_rounded,
              title: AppStrings.get('صلاحيات الموظفين', 'Staff Roles'),
            ),
            _buildActionTile(
              icon: Icons.settings_rounded,
              title: AppStrings.get('إعدادات التطبيق', 'App Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildActionTile(
              icon: Icons.logout_rounded,
              title: AppStrings.get('تسجيل الخروج', 'Logout'),
              isDestructive: true,
              onTap: () {
                // هذا الأمر يحذف كل الشاشات السابقة (عشان ما يقدر يرجع بالخلف) ويفتح شاشة الدخول
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklySalesChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.get(
                  'أداء المبيعات (أسبوع)',
                  'Weekly Sales Performance',
                ),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.show_chart_rounded,
                  color: Colors.green.shade600,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 140,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildChartBar(AppStrings.get('السبت', 'Sat'), 0.4),
                _buildChartBar(AppStrings.get('الأحد', 'Sun'), 0.6),
                _buildChartBar(AppStrings.get('الإثنين', 'Mon'), 0.5),
                _buildChartBar(AppStrings.get('الثلاثاء', 'Tue'), 0.8),
                _buildChartBar(AppStrings.get('الأربعاء', 'Wed'), 0.7),
                _buildChartBar(AppStrings.get('الخميس', 'Thu'), 0.9),
                _buildChartBar(AppStrings.get('الجمعة', 'Fri'), 1.0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartBar(String day, double percentage) {
    final bool isHighest = percentage == 1.0;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          width: 14,
          height: 100 * percentage,
          decoration: BoxDecoration(
            color: isHighest
                ? AppColors.primaryBlue
                : AppColors.primaryBlue.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          day,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isHighest ? FontWeight.bold : FontWeight.normal,
            color: isHighest ? AppColors.navyDark : AppColors.textMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(fontSize: 13, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    bool isDestructive = false,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        onTap:
            onTap ??
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    AppStrings.get(
                      'هذه الميزة ستتوفر قريباً...',
                      'Coming soon...',
                    ),
                  ),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDestructive
                ? Colors.red.withValues(alpha: 0.1)
                : AppColors.primaryBlue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: isDestructive ? Colors.red : AppColors.primaryBlue,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDestructive ? Colors.red : AppColors.textDark,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: Colors.grey.shade400,
        ),
      ),
    );
  }
}
