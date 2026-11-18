// مسار الملف: lib/customer/cart_screen.dart
// هذه الشاشة تعرض الخدمات المختارة وتسمح بتعديل الكميات ثم إتمام الطلب.

import 'package:flutter/material.dart';

import '../core/app_data.dart';
import '../core/app_constants.dart';
import 'checkout_screen.dart';

// ==========================================
//  شاشة السلة  (Cart Screen)
// ==========================================
class CartScreen extends StatefulWidget {
  final Map<String, int> initialCart;
  const CartScreen({super.key, required this.initialCart});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Map<String, int> cart;

  @override
  void initState() {
    super.initState();
    cart = Map.from(widget.initialCart);
  }

  void _increment(String id) {
    setState(() {
      cart[id] = (cart[id] ?? 0) + 1;
    });
  }

  void _decrement(String id) {
    setState(() {
      if (cart[id] != null && cart[id]! > 1) {
        cart[id] = cart[id]! - 1;
      } else {
        cart.remove(id);
      }
    });
  }

  void _remove(String id) {
    setState(() {
      cart.remove(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    double totalAmount = 0;
    cart.forEach((id, qty) {
      final service = AppData.services.firstWhere((s) => s.id == id);
      totalAmount += service.price * qty;
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.textDark),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context, cart),
        ),
        title: Text(
          AppStrings.get('سلة الطلبات', 'Your Cart'),
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: cart.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppStrings.get('سلتك فارغة!', 'Your cart is empty!'),
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 18),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: cart.keys.length,
              itemBuilder: (context, index) {
                final serviceId = cart.keys.elementAt(index);
                final qty = cart[serviceId]!;
                final service = AppData.services.firstWhere(
                  (s) => s.id == serviceId,
                );

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.grey.withValues(alpha: 0.15),
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
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          service.imagePath,
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                width: 70,
                                height: 70,
                                color: AppColors.primaryBlue.withValues(
                                  alpha: 0.1,
                                ),
                                child: Icon(
                                  Icons.dry_cleaning_rounded,
                                  color: AppColors.primaryBlue,
                                ),
                              ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.iYERabic
                                  ? service.nameAr
                                  : service.nameEn,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${service.price} ${AppStrings.get('ر.ي', 'YER')}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () => _remove(serviceId),
                            child: const Icon(
                              Icons.delete_outline_rounded,
                              color: Colors.red,
                              size: 20,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.grey.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () => _decrement(serviceId),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    child: Icon(Icons.remove, size: 16),
                                  ),
                                ),
                                Text(
                                  '$qty',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: AppColors.textDark,
                                  ),
                                ),
                                InkWell(
                                  onTap: () => _increment(serviceId),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    child: Icon(
                                      Icons.add,
                                      size: 16,
                                      color: AppColors.primaryBlue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: cart.isEmpty
          ? null
          : Container(
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
                          AppStrings.get('الإجمالي', 'Total'),
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textMuted,
                          ),
                        ),
                        Text(
                          '${totalAmount.toStringAsFixed(0)} ${AppStrings.get('ر.ي', 'YER')}',
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
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CheckoutScreen(
                                  cart: cart,
                                  totalAmount: totalAmount,
                                ),
                              ),
                            );

                            // 👇 نتحقق من الـ context نفسه بدلاً من الشاشة العامة
                            if (!context.mounted) return;

                            if (result == true) {
                              Navigator.pop(context, <String, int>{});
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBlue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            AppStrings.get('إتمام الطلب', 'Checkout'),
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
}
