// مسار الملف: lib/customer/customer_home_screen.dart

import 'package:flutter/material.dart';

import '../core/app_data.dart';
import '../core/main.dart';
import 'checkout_screen.dart'; // ⬅️ استدعاء شاشة الدفع

import 'package:flutter/services.dart';

import '../login_screen.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart'; // أو import 'login_screen.dart'; حسب مسار ملفك

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  int _currentIndex = 0;
  bool _notificationsEnabled = true;

  String _selectedCategory = 'الكل';
  Map<String, int> _cart = {};

  // 🌟 تحديث قائمة الأقسام للمغسلة السحابية بدعم اللغتين
  List<String> get _categories => [
    AppStrings.get('الكل', 'All'),
    AppStrings.get('الثوب', 'Thobe'),
    AppStrings.get('الكنب', 'Sofas'),
    AppStrings.get('رياضية', 'Sports'),
    AppStrings.get('الصارون', 'Sarong'),
    AppStrings.get('سجاد ومفروشات', 'Carpets & Rugs'),
    AppStrings.get('المفروشات', 'Furnishings'),
  ];

  void _incrementCart(String id) {
    setState(() {
      _cart[id] = (_cart[id] ?? 0) + 1;
    });
  }

  void _decrementCart(String id) {
    setState(() {
      if (_cart[id] != null && _cart[id]! > 1) {
        _cart[id] = _cart[id]! - 1;
      } else {
        _cart.remove(id);
      }
    });
  }

  void _removeFromCart(String id) {
    setState(() {
      _cart.remove(id);
    });
  }

  Future<void> _navigateToCart() async {
    final updatedCart = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CartScreen(initialCart: _cart)),
    );

    if (updatedCart != null) {
      setState(() {
        _cart = updatedCart;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalCartItems = _cart.values.fold(0, (sum, element) => sum + element);

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
        body: IndexedStack(
          index: _currentIndex,
          children: [
            _buildHomeScreen(totalCartItems),
            _buildOrdersScreen(),
            _buildLocationScreen(),
            _buildProfileScreen(),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 1. واجهة الرئيسية (Home)
  // ==========================================
  Widget _buildHomeScreen(int totalCartItems) {
    final filteredServices =
        _selectedCategory == 'All' || _selectedCategory == 'الكل'
        ? AppData.services
        : AppData.services
              .where((s) => s.category == _selectedCategory)
              .toList();

    return Column(
      children: [
        AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          centerTitle: false,
          title: Text(
            AppStrings.get('مرحباً بك 👋', 'Welcome 👋'),
            style: TextStyle(
              color: AppColors.textDark,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          actions: [
            Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.shopping_cart_outlined,
                    color: AppColors.textDark,
                  ),
                  onPressed: _navigateToCart,
                ),
                if (totalCartItems > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$totalCartItems',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            IconButton(
              icon: Icon(
                isDarkModeNotifier.value
                    ? Icons.light_mode_rounded
                    : Icons.dark_mode_rounded,
                color: AppColors.textDark,
              ),
              onPressed: () {
                setState(() {
                  isDarkModeNotifier.value = !isDarkModeNotifier.value;
                });
              },
            ),
          ],
        ),
        Expanded(
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 20,
                  bottom: 80,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 160,
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
                              Colors.black.withValues(alpha: 0.7),
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
                                color: AppColors.primaryBlue,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                AppStrings.get(
                                  'خدمة التوصيل 🛵',
                                  'Delivery Service 🛵',
                                ),
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
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      AppStrings.get(
                        'ماذا تريد أن تغسل اليوم؟',
                        'What to wash today?',
                      ),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 45,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _categories.length,
                        itemBuilder: (context, index) {
                          final cat = _categories[index];
                          final isSelected = _selectedCategory == cat;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(cat),
                              selected: isSelected,
                              selectedColor: AppColors.primaryBlue,
                              labelStyle: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textDark,
                                fontWeight: FontWeight.bold,
                              ),
                              onSelected: (selected) {
                                setState(() {
                                  _selectedCategory = cat;
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.65,
                          ),
                      itemCount: filteredServices.length,
                      itemBuilder: (context, index) {
                        final service = filteredServices[index];
                        final int countInCart = _cart[service.id] ?? 0;
                        return Container(
                          decoration: BoxDecoration(
                            color: AppColors.cardColor,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: countInCart > 0
                                  ? AppColors.primaryBlue
                                  : Colors.grey.withValues(alpha: 0.15),
                              width: countInCart > 0 ? 2 : 1,
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
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                  child: Image.asset(
                                    service.imagePath,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                              color: AppColors.primaryBlue
                                                  .withValues(alpha: 0.1),
                                              child: Icon(
                                                Icons.dry_cleaning_rounded,
                                                size: 40,
                                                color: AppColors.primaryBlue,
                                              ),
                                            ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppStrings.iYERabic
                                          ? service.nameAr
                                          : service.nameEn,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textDark,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${service.price} ${AppStrings.get('ر.ي', 'YER')}',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: AppColors.primaryBlue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    countInCart == 0
                                        ? SizedBox(
                                            width: double.infinity,
                                            child: ElevatedButton(
                                              onPressed: () =>
                                                  _incrementCart(service.id),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    AppColors.primaryBlue,
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                              child: Text(
                                                AppStrings.get(
                                                  'إضافة للسلة',
                                                  'Add to Cart',
                                                ),
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              GestureDetector(
                                                onTap: () =>
                                                    _removeFromCart(service.id),
                                                child: Container(
                                                  padding: const EdgeInsets.all(
                                                    6,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.red
                                                        .withValues(alpha: 0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                  child: const Icon(
                                                    Icons
                                                        .delete_outline_rounded,
                                                    color: Colors.red,
                                                    size: 18,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: AppColors.background,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                    color: Colors.grey
                                                        .withValues(alpha: 0.3),
                                                  ),
                                                ),
                                                child: Row(
                                                  children: [
                                                    InkWell(
                                                      onTap: () =>
                                                          _decrementCart(
                                                            service.id,
                                                          ),

                                                      child: const Padding(
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                              horizontal: 8,
                                                              vertical: 4,
                                                            ),
                                                        child: Icon(
                                                          Icons.remove,
                                                          size: 16,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      '$countInCart',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14,
                                                        color:
                                                            AppColors.textDark,
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () =>
                                                          _incrementCart(
                                                            service.id,
                                                          ),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                              horizontal: 8,
                                                              vertical: 4,
                                                            ),
                                                        child: Icon(
                                                          Icons.add,
                                                          size: 16,
                                                          color: AppColors
                                                              .primaryBlue,
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
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              if (totalCartItems > 0)
                Positioned(
                  bottom: 16,
                  left: 20,
                  right: 20,
                  child: ElevatedButton(
                    onPressed: _navigateToCart,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.shopping_cart_checkout_rounded,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          AppStrings.get(
                            'عرض السلة ($totalCartItems خدمات)',
                            'View Cart ($totalCartItems items)',
                          ),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================
  // 2. واجهة الطلبات السابقة للمغسلة السحابية (Orders)
  // ==========================================
  Widget _buildOrdersScreen() {
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
                              color: AppColors.navyDark,
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

  // ==========================================
  // 3. واجهة الموقع (Location) - الدالة المفقودة
  // ==========================================
  Widget _buildLocationScreen() {
    // إحداثيات ابتدائية (مثلاً: المكلا كمركز افتراضي، وتقدر تغيرها لأي مدينة)
    final LatLng initialCenter = const LatLng(14.5333, 49.1167);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.get('تحديد الموقع', 'Select Location'),
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // 1. الخريطة المجانية
          FlutterMap(
            options: MapOptions(
              initialCenter: initialCenter,
              initialZoom: 14.0, // مستوى التقريب
            ),
            children: [
              // طبقة الخرائط (OpenStreetMap)
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.laundry_flow', // يستحسن تغييره لاسم حزمة تطبيقك
              ),
            ],
          ),

          // 2. زر "تأكيد الموقع" أسفل الشاشة
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                _showAddressDetailsBottomSheet(context);
              },
              child: Text(
                AppStrings.get(
                  'تأكيد موقع الاستلام',
                  'Confirm Pickup Location',
                ),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // 3. الدبوس الثابت في منتصف الشاشة
          const Center(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: 40.0,
              ), // لرفع الدبوس ليكون في المركز الدقيق
              child: Icon(Icons.location_on, size: 50, color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddressDetailsBottomSheet(BuildContext context) {
    // متحكمات النصوص لالتقاط البيانات المكتوبة
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController houseNumberController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // مهم جداً عشان الكيبورد ما يغطي الحقول
      backgroundColor: AppColors.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          // MediaQuery.of(context).viewInsets.bottom يرفع النافذة تلقائياً مع الكيبورد
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize:
                MainAxisSize.min, // عشان النافذة تاخذ مساحة المحتوى فقط
            children: [
              Text(
                AppStrings.get('تفاصيل العنوان', 'Address Details'),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 20),

              // حقل أقرب وصف
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: AppStrings.get(
                    'أقرب وصف للمكان',
                    'Closest Landmark',
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // حقل رقم البيت
              TextField(
                controller: houseNumberController,
                keyboardType: TextInputType.number, // يفتح كيبورد الأرقام
                decoration: InputDecoration(
                  labelText: AppStrings.get(
                    'رقم البيت / الشقة',
                    'House / Apt Number',
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // زر الحفظ
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    // 1. حفظ العنوان في المتغير العام قبل إغلاق النافذة
                    globalSavedAddress =
                        '${descriptionController.text} (رقم/شقة: ${houseNumberController.text})';

                    // 2. إغلاق النافذة
                    Navigator.pop(context);

                    // 3. إظهار رسالة النجاح
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppStrings.get(
                            'تم حفظ الموقع بنجاح!',
                            'Location saved successfully!',
                          ),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  },
                  child: Text(
                    AppStrings.get('حفظ', 'Save'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  // ==========================================
  // 4. واجهة الملف الشخصي (Profile) - الدالة المفقودة
  // ==========================================
  Widget _buildProfileScreen() {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            AppStrings.get('الملف الشخصي', 'Profile'),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 40),
          Expanded(
            child: Container(
              color: AppColors.cardColor,
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildProfileListTile(
                    title: AppStrings.get('تسجيل الدخول', 'Login'),
                    icon: Icons.person_outline,
                    onTap: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                  ),
                  _buildProfileListTile(
                    title: AppStrings.get('اللغة', 'Language'),
                    icon: Icons.translate_rounded,
                    trailingWidget: Text(
                      AppStrings.iYERabic ? 'العربية' : 'English',
                      style: TextStyle(
                        color: AppColors.primaryBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        iYERabicNotifier.value = !iYERabicNotifier.value;
                      });
                    },
                  ),
                  _buildProfileListTile(
                    title: AppStrings.get('الإشعارات', 'Notifications'),
                    icon: Icons.notifications_none_rounded,
                    trailingWidget: Switch(
                      value: _notificationsEnabled,
                      activeTrackColor: Colors.black, // ✅ لون مسار الزر
                      activeThumbColor: Colors.white,
                      onChanged: (val) {
                        setState(() {
                          _notificationsEnabled = val;
                        });
                      },
                    ),
                    onTap: null,
                  ),
                  _buildProfileListTile(
                    title: AppStrings.get('خدمة العملاء', 'Customer Service'),
                    icon: Icons.support_agent_rounded,
                    onTap: () {},
                  ),
                  _buildProfileListTile(
                    title: AppStrings.get('سياسة الخصوصية', 'Privacy Policy'),
                    icon: Icons.description_outlined,
                    onTap: () {},
                  ),
                  _buildProfileListTile(
                    title: AppStrings.get('تسجيل الخروج', 'Logout'),
                    icon: Icons.logout_rounded,
                    hideDivider: true, // إخفاء الخط تحت آخر زر
                    onTap: () {
                      // أمر تسجيل الخروج والعودة لشاشة البداية
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                        (Route<dynamic> route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileListTile({
    required String title,
    required IconData icon,
    Widget? trailingWidget,
    VoidCallback? onTap,
    bool hideDivider = false,
  }) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 4,
          ),
          onTap: onTap,
          leading: Icon(icon, color: AppColors.textDark, size: 26),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          trailing:
              trailingWidget ??
              Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 16,
                color: Colors.grey.shade400,
              ),
        ),
        if (!hideDivider)
          Divider(
            height: 1,
            indent: 24,
            endIndent: 24,
            color: Colors.grey.withValues(alpha: 0.2),
          ),
      ],
    );
  }
}

// ==========================================
// 🌟 شاشة السلة المستقلة (Cart Screen)
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
