// مسار الملف: lib/order_details_screen.dart

import 'package:flutter/material.dart';

import '../core/app_data.dart';
import '../core/main.dart';

class OrderDetailsScreen extends StatefulWidget {
  final LaundryOrder order;
  final bool
  isAdmin; // ⬅️ إضافة لمعرفة إذا اللي فاتح الشاشة أدمن عشان يقدر يغير الحالة

  const OrderDetailsScreen({
    super.key,
    required this.order,
    this.isAdmin = true,
  }); // خليناها true مؤقتاً للتجربة

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  late LaundryOrder currentOrder;

  @override
  void initState() {
    super.initState();
    currentOrder = widget.order;
  }

  // 🌟 دالة تحديث الحالة عند الضغط على الدوائر العلوية
  void _updateStatus(String newStatus) {
    if (!widget.isAdmin) return; // العميل ما يقدر يغير من هنا

    setState(() {
      currentOrder.status = newStatus;

      // تحديث الحالة في قاعدة البيانات الوهمية
      final index = AppData.orders.indexWhere((o) => o.id == currentOrder.id);
      if (index != -1) {
        AppData.orders[index].status = newStatus;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppStrings.get('تم تحديث حالة الطلب ✅', 'Order status updated ✅'),
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  int _getCurrentStep() {
    switch (currentOrder.status) {
      case 'new':
      case 'pending_pickup':
        return 0;
      case 'washing':
      case 'in_laundry':
        return 1;
      case 'ready':
      case 'out_for_delivery':
        return 2;
      case 'completed':
      case 'delivered':
        return 3;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final int currentStep = _getCurrentStep();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.navyDark),
        title: Text(
          AppStrings.get('تفاصيل الطلب', 'Order Details'),
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 🌟 المتتبع التفاعلي العلوي (Stepper)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              decoration: BoxDecoration(
                color: AppColors.cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInteractiveStep(
                    0,
                    currentStep,
                    AppStrings.get('جديد', 'New'),
                    Icons.shopping_cart_outlined,
                    'pending_pickup',
                  ),
                  _buildLine(0, currentStep),
                  _buildInteractiveStep(
                    1,
                    currentStep,
                    AppStrings.get('غسيل', 'Washing'),
                    Icons.local_laundry_service_outlined,
                    'in_laundry',
                  ),
                  _buildLine(1, currentStep),
                  _buildInteractiveStep(
                    2,
                    currentStep,
                    AppStrings.get('توصيل', 'Delivery'),
                    Icons.delivery_dining_outlined,
                    'out_for_delivery',
                  ),
                  _buildLine(2, currentStep),
                  _buildInteractiveStep(
                    3,
                    currentStep,
                    AppStrings.get('تسليم', 'Done'),
                    Icons.done_all_rounded,
                    'completed',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 🌟 الفاتورة الفخمة
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.cardColor,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.receipt_long_rounded,
                      color: AppColors.primaryBlue,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'LaundryFlow',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  Text(
                    AppStrings.get('فاتورة طلب', 'Order Receipt'),
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 24),
                  _buildDashedLine(),
                  const SizedBox(height: 24),

                  _buildReceiptRow(
                    AppStrings.get('رقم الطلب', 'Order ID'),
                    currentOrder.id,
                    isBold: true,
                  ),
                  const SizedBox(height: 12),
                  _buildReceiptRow(
                    AppStrings.get('التاريخ', 'Date'),
                    currentOrder.createdAt,
                  ),
                  const SizedBox(height: 12),
                  _buildReceiptRow(
                    AppStrings.get('العميل', 'Customer'),
                    currentOrder.customerName,
                  ),

                  const SizedBox(height: 24),
                  _buildDashedLine(),
                  const SizedBox(height: 24),

                  Align(
                    alignment: AppStrings.iYERabic
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Text(
                      AppStrings.get('الخدمات المطلوبة', 'Requested Services'),
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          '${AppStrings.iYERabic ? currentOrder.serviceNameAr : currentOrder.serviceNameEn} (x${currentOrder.quantity})',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${currentOrder.totalPrice.toStringAsFixed(0)} ${AppStrings.get('ر.ي', 'YER')}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  _buildDashedLine(),
                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppStrings.get('الإجمالي الكلي', 'Total Amount'),
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textMuted,
                        ),
                      ),
                      Text(
                        '${currentOrder.totalPrice.toStringAsFixed(0)} ${AppStrings.get('ر.ي', 'YER')}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: (widget.isAdmin && currentStep < 3)
                  ? () {
                      // نقل تلقائي للحالة التالية عند ضغط الزر السفلي
                      final nextStates = [
                        'in_laundry',
                        'out_for_delivery',
                        'completed',
                      ];
                      _updateStatus(nextStates[currentStep]);
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: currentStep == 3
                    ? Colors.green
                    : AppColors.primaryBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                currentStep == 3
                    ? AppStrings.get(
                        'مكتمل وتم التسليم',
                        'Completed & Delivered',
                      )
                    : AppStrings.get(
                        'تحديث للحالة التالية',
                        'Update to Next Status',
                      ),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 🌟 ويدجت الدوائر التفاعلية
  Widget _buildInteractiveStep(
    int stepIndex,
    int currentStep,
    String title,
    IconData icon,
    String statusValue,
  ) {
    bool isCompleted = stepIndex <= currentStep;
    return GestureDetector(
      onTap: () => _updateStatus(statusValue),
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isCompleted ? AppColors.primaryBlue : AppColors.background,
              shape: BoxShape.circle,
              border: Border.all(
                color: isCompleted
                    ? AppColors.primaryBlue
                    : Colors.grey.shade300,
                width: 2,
              ),
              boxShadow: isCompleted
                  ? [
                      BoxShadow(
                        color: AppColors.primaryBlue.withValues(alpha: 0.3),
                        blurRadius: 8,
                      ),
                    ]
                  : [],
            ),
            child: Icon(
              isCompleted ? Icons.check : icon,
              color: isCompleted ? Colors.white : Colors.grey.shade400,
              size: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: isCompleted ? AppColors.navyDark : Colors.grey.shade500,
              fontWeight: isCompleted ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLine(int stepIndex, int currentStep) {
    bool isCompleted = stepIndex < currentStep;
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 24, left: 4, right: 4),
        color: isCompleted ? AppColors.primaryBlue : Colors.grey.shade200,
      ),
    );
  }

  Widget _buildReceiptRow(String title, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(color: AppColors.textMuted, fontSize: 14)),
        Text(
          value,
          style: TextStyle(
            color: isBold ? AppColors.navyDark : AppColors.textDark,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            fontSize: isBold ? 16 : 14,
          ),
        ),
      ],
    );
  }

  Widget _buildDashedLine() {
    return Row(
      children: List.generate(
        30,
        (index) => Expanded(
          child: Container(
            color: index % 2 == 0
                ? Colors.transparent
                : Colors.grey.withValues(alpha: 0.3),
            height: 1,
          ),
        ),
      ),
    );
  }
}
