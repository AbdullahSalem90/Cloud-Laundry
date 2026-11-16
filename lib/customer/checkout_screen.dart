// مسار الملف: lib/customer/checkout_screen.dart

import 'package:flutter/material.dart';

import '../core/app_data.dart';
import '../core/main.dart';

String globalSavedAddress = ''; // متغير عام لحفظ العنوان

class CheckoutScreen extends StatefulWidget {
  final Map<String, int> cart;
  final double totalAmount;

  const CheckoutScreen({
    super.key,
    required this.cart,
    required this.totalAmount,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _selectedPaymentMethod = 0;
  final TextEditingController _addressController = TextEditingController(
    text: globalSavedAddress,
  );
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // 🌟 متغيرات أوقات الاستلام والتسليم (للمغسلة السحابية)
  final List<String> _pickupTimes = [
    'اليوم 04:00 م - 06:00 م',
    'اليوم 06:00 م - 08:00 م',
    'غداً 10:00 ص - 12:00 م',
  ];
  final List<String> _deliveryTimes = [
    'غداً 04:00 م - 06:00 م',
    'غداً 06:00 م - 08:00 م',
    'بعد غد 10:00 ص - 12:00 م',
  ];

  late String _selectedPickupTime;
  late String _selectedDeliveryTime;

  @override
  void initState() {
    super.initState();
    _selectedPickupTime = _pickupTimes.first;
    _selectedDeliveryTime = _deliveryTimes.first;
  }

  void _confirmFinalOrder() {
    if (_nameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppStrings.get(
              'الرجاء تعبئة جميع البيانات',
              'Please fill all details',
            ),
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    List<String> serviceNames = [];
    int totalPieces = 0;
    widget.cart.forEach((serviceId, qty) {
      final service = AppData.services.firstWhere((s) => s.id == serviceId);
      serviceNames.add(
        '${AppStrings.iYERabic ? service.nameAr : service.nameEn} (x$qty)',
      );
      totalPieces += qty;
    });

    final newOrderId = 'ORD-${100 + AppData.orders.length + 1}';
    final now = DateTime.now();
    final formattedDate =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} • ${now.hour}:${now.minute.toString().padLeft(2, '0')}';

    // 🌟 تسجيل الطلب مع أوقات المندوب والحالة الجديدة 'pending_pickup'
    AppData.orders.insert(
      0,
      LaundryOrder(
        id: newOrderId,
        customerName: _nameController.text,
        customerPhone: _phoneController.text,
        serviceNameAr: serviceNames.join('، '),
        serviceNameEn: serviceNames.join(', '),
        quantity: totalPieces,
        totalPrice: widget.totalAmount,
        status: 'pending_pickup', // ⬅️ الحالة الجديدة: بانتظار استلام المندوب
        createdAt: formattedDate,
        pickupTime: _selectedPickupTime, // ⬅️ وقت الاستلام المختار
        deliveryTime: _selectedDeliveryTime, // ⬅️ وقت التسليم المختار
      ),
    );

    AppData.customers.add(
      Customer(
        id: 'C${AppData.customers.length + 1}',
        name: _nameController.text,
        phone: _phoneController.text,
      ),
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: Colors.green,
                size: 60,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              AppStrings.get('تم تأكيد طلبك!', 'Order Confirmed!'),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppStrings.get(
                'مندوبنا في طريقه إليك في الوقت المحدد 🛵',
                'Our driver is on the way as scheduled 🛵',
              ),
              style: TextStyle(color: AppColors.textMuted),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context, true);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  AppStrings.get('العودة للرئيسية', 'Back to Home'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
          AppStrings.get('إتمام الطلب', 'Checkout'),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. قسم بيانات العميل والموقع
            Text(
              AppStrings.get(
                'بيانات العميل والموقع',
                'Customer Details & Location',
              ),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
              ),
              child: Column(
                children: [
                  _buildTextField(
                    controller: _nameController,
                    hint: AppStrings.get('اسمك الكريم', 'Your Name'),
                    icon: Icons.person_outline,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _phoneController,
                    hint: AppStrings.get('رقم الجوال', 'Phone Number'),
                    icon: Icons.phone_outlined,
                    isNumber: true,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _addressController,
                    hint: AppStrings.get(
                      'وصف الموقع (الحي، الشارع، المنزل)',
                      'Address Details',
                    ),
                    icon: Icons.location_on_outlined,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 2. 🌟 قسم أوقات الجدولة (المغسلة السحابية)
            Text(
              AppStrings.get('جدولة المندوب', 'Schedule Driver'),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.get('متى نستلم ملابسك؟', 'When to pickup?'),
                    style: TextStyle(fontSize: 14, color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 8),
                  _buildDropdownMenu(
                    value: _selectedPickupTime,
                    items: _pickupTimes,
                    icon: Icons.local_shipping_outlined,
                    onChanged: (val) {
                      setState(() {
                        _selectedPickupTime = val!;
                      });
                    },
                  ),
                  const Divider(height: 32),
                  Text(
                    AppStrings.get(
                      'متى نرجعها لك نظيفة؟',
                      'When to deliver back?',
                    ),
                    style: TextStyle(fontSize: 14, color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 8),
                  _buildDropdownMenu(
                    value: _selectedDeliveryTime,
                    items: _deliveryTimes,
                    icon: Icons.check_circle_outline,
                    onChanged: (val) {
                      setState(() {
                        _selectedDeliveryTime = val!;
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 3. قسم طرق الدفع
            Text(
              AppStrings.get('طريقة الدفع', 'Payment Method'),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 12),
            _buildPaymentMethodTile(
              index: 0,
              title: AppStrings.get(
                'الدفع عند الاستلام (كاش/شبكة)',
                'Cash/POS on Delivery',
              ),
              icon: Icons.money_rounded,
            ),
            _buildPaymentMethodTile(
              index: 1,
              title: AppStrings.get(
                'البطاقة الائتمانية / مدى',
                'Credit Card / Mada',
              ),
              icon: Icons.credit_card_rounded,
            ),
            _buildPaymentMethodTile(
              index: 2,
              title: AppStrings.get('Apple Pay', 'Apple Pay'),
              icon: Icons.apple,
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
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
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.get('المبلغ الإجمالي', 'Total Amount'),
                    style: TextStyle(fontSize: 14, color: AppColors.textMuted),
                  ),
                  Text(
                    '${widget.totalAmount.toStringAsFixed(0)} ${AppStrings.get('ر.ي', 'YER')}',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accentBlue,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 24),
              Expanded(
                child: SizedBox(
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _confirmFinalOrder,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
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
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isNumber = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.phone : TextInputType.text,
      style: TextStyle(color: AppColors.textDark),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 14),
        prefixIcon: Icon(icon, color: AppColors.textMuted, size: 20),
        filled: true,
        fillColor: AppColors.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildDropdownMenu({
    required String value,
    required List<String> items,
    required IconData icon,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: Icon(
            Icons.arrow_drop_down_rounded,
            color: AppColors.primaryBlue,
          ),
          dropdownColor: AppColors.cardColor,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Row(
                children: [
                  Icon(icon, size: 18, color: AppColors.primaryBlue),
                  const SizedBox(width: 8),
                  Text(
                    item,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildPaymentMethodTile({
    required int index,
    required String title,
    required IconData icon,
  }) {
    final isSelected = _selectedPaymentMethod == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedPaymentMethod = index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryBlue.withValues(alpha: 0.05)
              : AppColors.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryBlue
                : Colors.grey.withValues(alpha: 0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primaryBlue : Colors.grey,
              size: 28,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? AppColors.textDark : AppColors.textDark,
                ),
              ),
            ),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? AppColors.primaryBlue : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
