// مسار الملف: lib/dashboard_screen.dart

import 'package:flutter/material.dart';

import '../core/app_data.dart';
import '../core/main.dart';
import 'orders_screen.dart';
import 'customers_screen.dart';
import 'analytics_screen.dart';
import 'add_order_screen.dart';
import 'order_details_screen.dart';

import 'package:flutter/services.dart';

class DashboardScreen extends StatefulWidget {
  final VoidCallback onToggleLanguage;

  const DashboardScreen({super.key, required this.onToggleLanguage});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  bool _isNotificationActive = false; // متغير يحفظ حالة زر الإشعارات

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final bool shouldPop =
            await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: AppColors.cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: Text(
                  'تأكيد الخروج',
                  style: TextStyle(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: Text(
                  'هل أنت متأكد أنك تريد الخروج من التطبيق؟',
                  style: TextStyle(color: AppColors.textMuted),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(
                      'بقاء',
                      style: TextStyle(
                        color: AppColors.primaryBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text(
                      'خروج',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ) ??
            false;

        if (shouldPop) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 8.0,
          color: AppColors.cardColor, // لون تفاعلي
          elevation: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBottomNavItem(
                0,
                Icons.home_rounded,
                AppStrings.get('الرئيسية', 'Home'),
              ),
              _buildBottomNavItem(
                1,
                Icons.list_alt_rounded,
                AppStrings.get('طلباتي', 'Orders'),
              ),
              const SizedBox(width: 40),
              _buildBottomNavItem(
                2,
                Icons.people_outline_rounded,
                AppStrings.get('العملاء', 'Customers'),
              ),
              _buildBottomNavItem(
                3,
                Icons.bar_chart_rounded,
                AppStrings.get('المزيد', 'More'),
              ),
            ],
          ),
        ),

        // ⬇️ أكوادك القديمة (body و floatingActionButton) تبقى هنا زي ما هي لا تغيرها ⬇️
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const AddOrderScreen()));
            setState(() {});
          },
          backgroundColor: AppColors.navyDark, // ⬅️ لون تفاعلي
          elevation: 5,
          shape: const CircleBorder(),
          child: const Icon(
            Icons.add_shopping_cart_rounded,
            color: Colors.white,
            size: 28,
          ),
        ),

        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: AppColors.navyDark.withValues(
                            alpha: 0.1,
                          ),
                          child: Text(
                            'ع',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.get('أهلاً بعودتك،', 'Welcome back,'),
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textMuted,
                              ),
                            ),
                            Text(
                              AppStrings.get(
                                'عبدالله سالم ',
                                ' Abdullah Salem,',
                              ),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _isNotificationActive = !_isNotificationActive;
                            });
                          },
                          icon: Icon(
                            _isNotificationActive
                                ? Icons.notifications
                                : Icons.notifications_outlined,
                            color: AppColors.textDark,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // ⬅️ السطر السحري الذي يعكس اللغة في كامل التطبيق فوراً
                            iYERabicNotifier.value = !iYERabicNotifier.value;
                          },
                          child: Text(
                            AppStrings.iYERabic ? 'EN' : 'عربي',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Container(
                  decoration: BoxDecoration(
                    color: AppColors.cardColor, // ⬅️ خلفية البطاقة التفاعلية
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    style: TextStyle(color: AppColors.textDark),
                    decoration: InputDecoration(
                      hintText: AppStrings.get(
                        'ابحث عن الخدمات أو الطلبات...',
                        'Search for services or orders...',
                      ),
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Container(
                  width: double.infinity,
                  height: 185,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/banner.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withValues(alpha: 0.6),
                          Colors.transparent,
                        ],
                        begin: Alignment.bottomRight,
                        end: Alignment.topLeft,
                      ),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade600,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            AppStrings.get('لا تشيل هم 🛡️', 'No Worries 🛡️'),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppStrings.get(
                            'اطلب غسيلك وأنت مرتاح',
                            'Order from your comfort',
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          AppStrings.get(
                            'عناية متكاملة تضمن لك الأمان والراحة',
                            'Comprehensive care ensures safety and comfort',
                          ),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                Text(
                  AppStrings.get('خدماتنا السريعة', 'Our Quick Services'),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 14),

                GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 1.15,
                  children: [
                    _buildServiceImageCard(
                      title: AppStrings.get('غسيل جاف', 'Dry Clean'),
                      price: '25',
                      imagePath: 'assets/images/dry_clean.png',
                    ),
                    _buildServiceImageCard(
                      title: AppStrings.get('غسيل وكوي', 'Wash & Iron'),
                      price: '7',
                      imagePath: 'assets/images/wash_iron.png',
                    ),
                    _buildServiceImageCard(
                      title: AppStrings.get('غسيل بطانية', 'Blanket Wash'),
                      price: '35',
                      imagePath: 'assets/images/blanket.png',
                    ),
                    _buildServiceImageCard(
                      title: AppStrings.get('غسيل سجاد', 'Carpet Wash'),
                      price: '50',
                      imagePath: 'assets/images/carpet.png',
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.get('أحدث الطلبات الجارية', 'Recent Orders'),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const OrdersScreen(),
                          ),
                        );
                        setState(() {});
                      },
                      child: Text(AppStrings.get('الكل ', 'All ')),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: AppData.orders.length > 2
                      ? 2
                      : AppData.orders.length,
                  itemBuilder: (context, index) {
                    final order = AppData.orders[index];
                    return _buildOrderItemCard(order);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(int index, IconData icon, String label) {
    final bool isSelected = _currentIndex == index;
    return InkWell(
      onTap: () async {
        setState(() {
          _currentIndex = index;
        });

        if (index == 1) {
          await Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const OrdersScreen()));
        } else if (index == 2) {
          await Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const CustomersScreen()));
        } else if (index == 3) {
          await Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const AnalyticsScreen()));
        }

        setState(() {
          _currentIndex = 0;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? AppColors.primaryBlue : AppColors.textMuted,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? AppColors.primaryBlue : AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceImageCard({
    required String title,
    required String price,
    required String imagePath,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            colors: [Colors.black.withValues(alpha: 0.7), Colors.transparent],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$price ${AppStrings.get('ر.ي', 'YER')}',
                  style: TextStyle(
                    color: AppColors.accentBlue,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Icon(
                  Icons.arrow_circle_left_rounded,
                  color: Colors.white70,
                  size: 18,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItemCard(LaundryOrder order) {
    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (order.status) {
      case 'new':
        statusColor = Colors.blue.shade600;
        statusText = AppStrings.get('طلب جديد', 'New');
        statusIcon = Icons.add_circle_outline_rounded;
        break;
      case 'washing':
        statusColor = Colors.orange.shade600;
        statusText = AppStrings.get('قيد الغسيل', 'Washing');
        statusIcon = Icons.local_laundry_service_rounded;
        break;
      case 'ready':
        statusColor = Colors.green.shade600;
        statusText = AppStrings.get('جاهز للاستلام', 'Ready');
        statusIcon = Icons.check_circle_outline_rounded;
        break;
      default:
        statusColor = Colors.grey.shade600;
        statusText = AppStrings.get('تم التسليم', 'Delivered');
        statusIcon = Icons.done_all_rounded;
    }

    return GestureDetector(
      onTap: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => OrderDetailsScreen(order: order)),
        );
        setState(() {});
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardColor, // ⬅️ لون البطاقة تفاعلي
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.grey.withValues(alpha: 0.15),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(statusIcon, color: statusColor, size: 24),
            ),
            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.customerName,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark, // ⬅️ نص تفاعلي
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${AppStrings.iYERabic ? order.serviceNameAr : order.serviceNameEn} (${order.quantity} ${AppStrings.get('قطع', 'pcs')})',
                    style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${order.id} • ${order.createdAt}',
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${order.totalPrice.toStringAsFixed(0)} ${AppStrings.get('ر.ي', 'YER')}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark, // ⬅️ نص تفاعلي
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        statusText,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
