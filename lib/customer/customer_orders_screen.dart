// مسار الملف: lib/customer/customer_orders_screen.dart
// هذه الشاشة تعرض طلبات العميل السابقة وحالة كل طلب.

import 'package:flutter/material.dart';

import '../core/app_data.dart';
import '../core/app_constants.dart';

class CustomerOrdersScreen extends StatelessWidget {
  const CustomerOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final myOrders = AppData.orders;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppStrings.get('طلباتي', 'My Orders'),
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: myOrders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.list_alt_rounded,
                    size: 80,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppStrings.get(
                      'لا توجد طلبات سابقة',
                      'No past orders found',
                    ),
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: myOrders.length,
              itemBuilder: (context, index) {
                final order = myOrders[index];

                Color statusColor;
                String statusText;
                IconData statusIcon;

                switch (order.status) {
                  case 'pending_pickup':
                  case 'new':
                    statusColor = Colors.blue.shade600;
                    statusText = AppStrings.get(
                      'جاري الاستلام (المندوب بالطريق)',
                      'Pending Pickup',
                    );
                    statusIcon = Icons.local_shipping_outlined;
                    break;
                  case 'washing':
                  case 'in_laundry':
                    statusColor = Colors.orange.shade600;
                    statusText = AppStrings.get(
                      'في المغسلة (جاري التنظيف)',
                      'In Laundry',
                    );
                    statusIcon = Icons.local_laundry_service_rounded;
                    break;
                  case 'out_for_delivery':
                  case 'ready':
                    statusColor = Colors.purple.shade600;
                    statusText = AppStrings.get(
                      'جاري التوصيل إليك',
                      'Out for Delivery',
                    );
                    statusIcon = Icons.delivery_dining_rounded;
                    break;
                  default: // completed
                    statusColor = Colors.green.shade600;
                    statusText = AppStrings.get(
                      'مكتمل وتم التسليم',
                      'Completed',
                    );
                    statusIcon = Icons.check_circle_outline_rounded;
                }

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.grey.withValues(alpha: 0.15),
                    ),
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
                            order.id,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                          Text(
                            order.createdAt,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      Text(
                        AppStrings.iYERabic
                            ? order.serviceNameAr
                            : order.serviceNameEn,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.arrow_upward_rounded,
                                  size: 16,
                                  color: Colors.blue,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${AppStrings.get('وقت الاستلام:', 'Pickup:')} ${order.pickupTime}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textDark,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.arrow_downward_rounded,
                                  size: 16,
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${AppStrings.get('وقت التسليم:', 'Delivery:')} ${order.deliveryTime}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textDark,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${order.quantity} ${AppStrings.get('قطع', 'Items')}',
                            style: TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            '${order.totalPrice.toStringAsFixed(0)} ${AppStrings.get('ر.ي', 'YER')}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryBlue,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(statusIcon, color: statusColor, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              statusText,
                              style: TextStyle(
                                color: statusColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
