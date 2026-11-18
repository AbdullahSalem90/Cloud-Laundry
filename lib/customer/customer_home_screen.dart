// مسار الملف: lib/customer/customer_home_screen.dart
// هذه هي الحاوية الرئيسية للعميل، وتربط تبويبات الرئيسية والطلبات والموقع والحساب.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/app_constants.dart';
import 'customer_home_tab.dart';
import 'customer_orders_screen.dart';
import 'customer_location_screen.dart';
import 'customer_profile_screen.dart';
import 'cart_screen.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});


  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  // رقم التبويب المفتوح حاليًا.
  int _currentIndex = 0;

  // السلة محفوظة هنا حتى تبقى بياناتها مشتركة بين الرئيسية والسلة.
  Map<String, int> _cart = {};
  
@override
void initState() {
  super.initState();

  isDarkModeNotifier.addListener(_refreshCustomerScreens);
  iYERabicNotifier.addListener(_refreshCustomerScreens);
}

// تحديث واجهة العميل فوراً
void _refreshCustomerScreens() {
  if (mounted) {
    setState(() {});
  }
}

// إيقاف الاستماع عند مغادرة الشاشة
@override
void dispose() {
  isDarkModeNotifier.removeListener(_refreshCustomerScreens);
  iYERabicNotifier.removeListener(_refreshCustomerScreens);

  super.dispose();
}

  // إضافة قطعة من خدمة إلى السلة.
  void _incrementCart(String id) {
    setState(() {
      _cart[id] = (_cart[id] ?? 0) + 1;
    });
  }

  // تقليل عدد القطع، وحذف الخدمة إذا وصل العدد إلى صفر.
  void _decrementCart(String id) {
    setState(() {
      if (_cart[id] != null && _cart[id]! > 1) {
        _cart[id] = _cart[id]! - 1;
      } else {
        _cart.remove(id);
      }
    });
  }

  // حذف خدمة كاملة من السلة.
  void _removeFromCart(String id) {
    setState(() {
      _cart.remove(id);
    });
  }

  // فتح شاشة السلة واستقبال التعديلات التي تمت بداخلها.
  Future<void> _navigateToCart() async {
    final Map<String, int>? updatedCart =
        await Navigator.push<Map<String, int>>(
      context,
      MaterialPageRoute(
        builder: (context) => CartScreen(initialCart: Map.from(_cart)),
      ),
    );

    if (!mounted || updatedCart == null) return;

    setState(() {
      _cart = updatedCart;
    });
  }

  @override
  Widget build(BuildContext context) {
    // حساب مجموع القطع الموجودة في السلة.
    final int totalCartItems =
        _cart.values.fold(0, (sum, quantity) => sum + quantity);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        // إظهار رسالة تأكيد قبل إغلاق التطبيق بزر الرجوع.
        final bool shouldPop =
            await showDialog<bool>(
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

        // شريط التنقل بين أقسام تطبيق العميل.
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.cardColor,
          selectedItemColor: Colors.amber.shade700,
          unselectedItemColor: Colors.grey.shade400,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              activeIcon: const Icon(Icons.home_rounded),
              label: AppStrings.get('الرئيسية', 'Home'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.shopping_bag_outlined),
              activeIcon: const Icon(Icons.shopping_bag_rounded),
              label: AppStrings.get('الطلبات', 'Orders'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.location_on_outlined),
              activeIcon: const Icon(Icons.location_on_rounded),
              label: AppStrings.get('الموقع', 'Location'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_outline),
              activeIcon: const Icon(Icons.person),
              label: AppStrings.get('حسابي', 'Account'),
            ),
          ],
        ),

        // IndexedStack يحافظ على حالة كل تبويب عند التنقل بينها.
        body: IndexedStack(
          index: _currentIndex,
          children: [
            CustomerHomeTab(
              cart: _cart,
              totalCartItems: totalCartItems,
              onIncrementCart: _incrementCart,
              onDecrementCart: _decrementCart,
              onRemoveFromCart: _removeFromCart,
              onOpenCart: _navigateToCart,
            ),
            const CustomerOrdersScreen(),
            const CustomerLocationScreen(),
            const CustomerProfileScreen(),
          ],
        ),
      ),
    );
  }
}
