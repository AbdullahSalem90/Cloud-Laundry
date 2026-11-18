import 'package:flutter/material.dart';

import '../core/app_data.dart';
import '../core/app_constants.dart';
class AddOrderScreen extends StatefulWidget {
  const AddOrderScreen({super.key});

  @override
  State<AddOrderScreen> createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends State<AddOrderScreen> {
  // العميل الذي اختاره المدير للطلب.
  Customer? _selectedCustomer;

  // المفتاح هو رقم الخدمة والقيمة هي عدد القطع.
  final Map<String, int> _selectedServices = {};

  // حساب مجموع أسعار جميع الخدمات المختارة.
  double get _totalPrice {
    double total = 0;

    for (final service in AppData.services) {
      final quantity = _selectedServices[service.id] ?? 0;
      total += service.price * quantity;
    }

    return total;
  }

  // حساب العدد الإجمالي للقطع في الطلب.
  int get _totalQuantity {
    return _selectedServices.values.fold(0, (sum, quantity) => sum + quantity);
  }

  // فتح نافذة اختيار العميل من قائمة العملاء المسجلين.
  void _showCustomerSelectionSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.cardColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Text(
                AppStrings.get('اختر العميل', 'Select Customer'),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 16),

              // عرض العملاء في قائمة قابلة للتمرير.
              Expanded(
                child: AppData.customers.isEmpty
                    ? Center(
                        child: Text(
                          AppStrings.get(
                            'لا يوجد عملاء، يرجى إضافتهم أولاً',
                            'No customers found',
                          ),
                          style: TextStyle(color: AppColors.textDark),
                        ),
                      )
                    : ListView.builder(
                        itemCount: AppData.customers.length,
                        itemBuilder: (context, index) {
                          final customer = AppData.customers[index];

                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              backgroundColor: AppColors.primaryBlue.withValues(
                                alpha: 0.1,
                              ),
                              child: Text(
                                customer.name.isNotEmpty
                                    ? customer.name.substring(0, 1)
                                    : '?',
                                style: TextStyle(
                                  color: AppColors.primaryBlue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              customer.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                            ),
                            subtitle: Text(
                              customer.phone,
                              style: TextStyle(color: AppColors.textMuted),
                            ),

                            // عند الضغط على العميل يتم اختياره.
                            onTap: () {
                              setState(() {
                                _selectedCustomer = customer;
                              });
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  // إضافة الخدمة أو إلغاء اختيارها عند الضغط على بطاقتها.
  void _toggleService(LaundryServiceItem service) {
    setState(() {
      if (_selectedServices.containsKey(service.id)) {
        // إذا كانت مختارة نحذفها من الطلب.
        _selectedServices.remove(service.id);
      } else {
        // إذا لم تكن مختارة نضيفها بقطعة واحدة.
        _selectedServices[service.id] = 1;
      }
    });
  }

  // زيادة أو تقليل كمية خدمة معينة بشكل مستقل.
  void _changeQuantity(LaundryServiceItem service, int change) {
    setState(() {
      final currentQuantity = _selectedServices[service.id] ?? 0;
      final newQuantity = currentQuantity + change;

      // لا نسمح بأن تصبح الكمية أقل من قطعة واحدة.
      if (newQuantity >= 1) {
        _selectedServices[service.id] = newQuantity;
      }
    });
  }

  // إنشاء بطاقة التحكم بكمية كل خدمة مختارة.
  Widget _buildSelectedServiceQuantity(LaundryServiceItem service) {
    final quantity = _selectedServices[service.id] ?? 1;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          // اسم الخدمة وسعرها.
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.iYERabic ? service.nameAr : service.nameEn,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${service.price} × $quantity = '
                  '${service.price * quantity} '
                  '${AppStrings.get('ر.ي', 'YER')}',
                  style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
              ],
            ),
          ),

          // زر تقليل عدد القطع.
          IconButton(
            icon: Icon(Icons.remove_rounded, color: AppColors.textMuted),
            onPressed: () => _changeQuantity(service, -1),
          ),

          // عرض الكمية الحالية.
          Text(
            '$quantity',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),

          // زر زيادة عدد القطع.
          IconButton(
            icon: Icon(Icons.add_rounded, color: AppColors.textMuted),
            onPressed: () => _changeQuantity(service, 1),
          ),
        ],
      ),
    );
  }

  // التحقق من البيانات ثم إنشاء الطلب وحفظه في قائمة الطلبات.
  void _saveOrder() {
    if (_selectedCustomer == null || _selectedServices.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppStrings.get(
              'الرجاء اختيار العميل وخدمة واحدة على الأقل',
              'Please select a customer and at least one service',
            ),
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // استخراج الخدمات التي اختارها المدير.
    final selectedServices = AppData.services
        .where((service) => _selectedServices.containsKey(service.id))
        .toList();

    // تجهيز أسماء الخدمات باللغة العربية.
    final serviceNamesAr = selectedServices
        .map((service) {
          final quantity = _selectedServices[service.id]!;
          return '${service.nameAr} (x$quantity)';
        })
        .join('، ');

    // تجهيز أسماء الخدمات باللغة الإنجليزية.
    final serviceNamesEn = selectedServices
        .map((service) {
          final quantity = _selectedServices[service.id]!;
          return '${service.nameEn} (x$quantity)';
        })
        .join(', ');

    // حساب مجموع أسعار الخدمات المختارة.
    final totalPrice = _totalPrice;

    // حساب إجمالي عدد القطع.
    final totalQuantity = _totalQuantity;

    // إنشاء رقم جديد للطلب.
    final newOrderId = 'ORD-${100 + AppData.orders.length + 1}';

    // تسجيل تاريخ ووقت إنشاء الطلب.
    final now = DateTime.now();

    final formattedDate =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')} • '
        '${now.hour}:${now.minute.toString().padLeft(2, '0')}';

    // إنشاء الطلب وإضافته إلى بداية قائمة الطلبات.
    AppData.orders.insert(
      0,
      LaundryOrder(
        id: newOrderId,
        customerName: _selectedCustomer!.name,
        customerPhone: _selectedCustomer!.phone,
        serviceNameAr: serviceNamesAr,
        serviceNameEn: serviceNamesEn,
        quantity: totalQuantity,
        totalPrice: totalPrice,
        status: 'new',
        createdAt: formattedDate,
        pickupTime: 'محدد من الإدارة',
        deliveryTime: 'محدد من الإدارة',
      ),
    );

    // إظهار رسالة نجاح بعد إنشاء الطلب.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppStrings.get(
            'تم إنشاء الطلب بنجاح!',
            'Order created successfully!',
          ),
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
      ),
    );

    // العودة إلى الشاشة السابقة.
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // تحديث الإجمالي تلقائياً عند اختيار الخدمات وتغيير كمياتها.
    final double totalPrice = _totalPrice;

    return Scaffold(
      backgroundColor: AppColors.background,

      // شريط العنوان العلوي.
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.textDark),
        title: Text(
          AppStrings.get('طلب جديد', 'New Order'),
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // عنوان قسم بيانات العميل.
                  Text(
                    AppStrings.get('بيانات العميل', 'Customer Details'),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // بطاقة اختيار العميل.
                  GestureDetector(
                    onTap: _showCustomerSelectionSheet,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.grey.withValues(alpha: 0.2),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: _selectedCustomer != null
                                  ? AppColors.navyDark.withValues(alpha: 0.1)
                                  : Colors.grey.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.person_rounded,
                              color: _selectedCustomer != null
                                  ? AppColors.navyDark
                                  : Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 16),

                          // عرض اسم العميل ورقم جواله.
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _selectedCustomer?.name ??
                                      AppStrings.get(
                                        'اضغط لاختيار العميل',
                                        'Tap to select customer',
                                      ),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: _selectedCustomer != null
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: _selectedCustomer != null
                                        ? AppColors.textDark
                                        : AppColors.textMuted,
                                  ),
                                ),
                                if (_selectedCustomer != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    _selectedCustomer!.phone,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // عنوان قسم اختيار الخدمات.
                  Text(
                    AppStrings.get('نوع الخدمة', 'Service Type'),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // عرض جميع الخدمات في بطاقات قابلة للاختيار المتعدد.
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 2.2,
                        ),
                    itemCount: AppData.services.length,
                    itemBuilder: (context, index) {
                      final service = AppData.services[index];

                      // معرفة هل الخدمة مختارة أم لا.
                      final isSelected = _selectedServices.containsKey(
                        service.id,
                      );

                      return GestureDetector(
                        onTap: () => _toggleService(service),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.navyDark
                                : AppColors.cardColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.navyDark
                                  : Colors.grey.withValues(alpha: 0.2),
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: AppColors.navyDark.withValues(
                                        alpha: 0.3,
                                      ),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ]
                                : [],
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            children: [
                              // تغيير الأيقونة حسب حالة الاختيار.
                              Icon(
                                isSelected
                                    ? Icons.check_circle_rounded
                                    : Icons.dry_cleaning_rounded,
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.primaryBlue,
                                size: 24,
                              ),
                              const SizedBox(width: 8),

                              // عرض اسم الخدمة وسعر القطعة الواحدة.
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppStrings.iYERabic
                                          ? service.nameAr
                                          : service.nameEn,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: isSelected
                                            ? Colors.white
                                            : AppColors.textDark,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${service.price} ${AppStrings.get('ر.ي', 'YER')}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isSelected
                                            ? Colors.white70
                                            : AppColors.textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ), // إظهار قسم الكميات فقط عند اختيار خدمة واحدة على الأقل.
                  if (_selectedServices.isNotEmpty) ...[
                    const SizedBox(height: 32),

                    Text(
                      AppStrings.get(
                        'عدد القطع لكل خدمة',
                        'Quantity for Each Service',
                      ),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // إنشاء عنصر تحكم مستقل لكل خدمة مختارة.
                    for (final service in AppData.services.where(
                      (service) => _selectedServices.containsKey(service.id),
                    ))
                      _buildSelectedServiceQuantity(service),
                  ],
                ],
              ),
            ),
          ),

          // الشريط السفلي الذي يعرض الإجمالي وزر تأكيد الطلب.
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.cardColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  // عرض إجمالي سعر جميع الخدمات.
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppStrings.get('الإجمالي', 'Total Price'),
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${totalPrice.toStringAsFixed(0)} ${AppStrings.get('ر.ي', 'YER')}',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.accentBlue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 24),

                  // زر حفظ الطلب بعد التأكد من البيانات.
                  Expanded(
                    child: SizedBox(
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _saveOrder,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 2,
                        ),
                        child: Text(
                          AppStrings.get('تأكيد الطلب', 'Confirm Order'),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
