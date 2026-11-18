// مسار الملف: lib/orders_screen.dart

import 'package:flutter/material.dart';

import '../core/app_data.dart';
import '../core/app_constants.dart';
import 'order_details_screen.dart';

List<dynamic> globalOrders = [
  // (هنا بيانات الطلبات الوهمية الخاصة بك)
];

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  String _searchQuery = '';
  String _selectedStatus = 'all';

  @override
  Widget build(BuildContext context) {
    final filteredOrders = AppData.orders.where((order) {
      // 1. فلترة البحث بالاسم أو رقم الطلب
      final matchesSearch =
          order.customerName.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          order.id.toLowerCase().contains(_searchQuery.toLowerCase());

      bool matchesStatus = false;
      if (_selectedStatus == 'all') {
        matchesStatus = true;
      } else if (_selectedStatus == 'new') {
        matchesStatus =
            (order.status == 'new' || order.status == 'pending_pickup');
      } else if (_selectedStatus == 'washing') {
        matchesStatus =
            (order.status == 'washing' || order.status == 'in_laundry');
      } else if (_selectedStatus == 'ready') {
        matchesStatus =
            (order.status == 'ready' || order.status == 'out_for_delivery');
      } else if (_selectedStatus == 'delivered') {
        matchesStatus =
            (order.status == 'delivered' || order.status == 'completed');
      }

      return matchesSearch && matchesStatus;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.textDark),
        title: Text(
          AppStrings.get('إدارة الطلبات', 'Orders Management'),
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.cardColor,
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
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: AppStrings.get(
                    'ابحث برقم الطلب أو اسم العميل...',
                    'Search by order ID or name...',
                  ),
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              children: [
                _buildFilterChip('all', AppStrings.get('الكل', 'All')),
                const SizedBox(width: 10),
                _buildFilterChip('new', AppStrings.get('طلب جديد', 'New')),
                const SizedBox(width: 10),
                _buildFilterChip(
                  'washing',
                  AppStrings.get('قيد الغسيل', 'Washing'),
                ),
                const SizedBox(width: 10),
                _buildFilterChip(
                  'ready',
                  AppStrings.get('جاهز / توصيل', 'Ready/Delivery'),
                ),
                const SizedBox(width: 10),
                _buildFilterChip(
                  'delivered',
                  AppStrings.get('مكتمل', 'Delivered'),
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredOrders.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 80,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          AppStrings.get(
                            'لا توجد طلبات مطابقة',
                            'No matching orders found',
                          ),
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    itemCount: filteredOrders.length,
                    itemBuilder: (context, index) {
                      return _buildOrderItemCard(filteredOrders[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String statusValue, String label) {
    final bool isSelected = _selectedStatus == statusValue;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedStatus = statusValue;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.navyDark : AppColors.cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.navyDark
                : Colors.grey.withValues(alpha: 0.3),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.navyDark.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.textMuted,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 13,
            ),
          ),
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
      case 'pending_pickup':
        statusColor = Colors.blue.shade600;
        statusText = AppStrings.get('بانتظار الاستلام', 'Pending Pickup');
        statusIcon = Icons.local_shipping_outlined;
        break;
      case 'washing':
      case 'in_laundry':
        statusColor = Colors.orange.shade600;
        statusText = AppStrings.get('في المغسلة', 'In Laundry');
        statusIcon = Icons.local_laundry_service_rounded;
        break;
      case 'ready':
      case 'out_for_delivery':
        statusColor = Colors.purple.shade600;
        statusText = AppStrings.get('جاري التوصيل', 'Out for Delivery');
        statusIcon = Icons.delivery_dining_rounded;
        break;
      default: // completed أو delivered
        statusColor = Colors.green.shade600;
        statusText = AppStrings.get('مكتمل', 'Completed');
        statusIcon = Icons.done_all_rounded;
    }

    return GestureDetector(
      onTap: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => OrderDetailsScreen(order: order)),
        );
        if (!context.mounted) return;
        setState(() {});
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardColor,
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
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(statusIcon, color: statusColor, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.customerName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${AppStrings.iYERabic ? order.serviceNameAr : order.serviceNameEn} (${order.quantity} ${AppStrings.get('قطع', 'pcs')})',
                    style: TextStyle(fontSize: 14, color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${order.id} • ${order.createdAt}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
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
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 10),
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
