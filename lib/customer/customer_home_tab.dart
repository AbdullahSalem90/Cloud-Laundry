// مسار الملف: lib/customer/customer_home_tab.dart
// هذه الشاشة مسؤولة عن عرض الخدمات وتصنيفاتها وإضافة الخدمات إلى السلة.

import 'package:flutter/material.dart';

import '../core/app_data.dart';
import '../core/app_constants.dart';

class CustomerHomeTab extends StatefulWidget {
  final Map<String, int> cart;
  final int totalCartItems;

  // دوال لتحديث السلة في الشاشة الرئيسية.
  final ValueChanged<String> onIncrementCart;
  final ValueChanged<String> onDecrementCart;
  final ValueChanged<String> onRemoveFromCart;
  final VoidCallback onOpenCart;

  const CustomerHomeTab({
    super.key,
    required this.cart,
    required this.totalCartItems,
    required this.onIncrementCart,
    required this.onDecrementCart,
    required this.onRemoveFromCart,
    required this.onOpenCart,
  });

  @override
  State<CustomerHomeTab> createState() => _CustomerHomeTabState();
}

class _CustomerHomeTabState extends State<CustomerHomeTab> {
  // القسم المختار حاليًا لفلترة الخدمات.
  String _selectedCategory = 'الكل';

  List<String> get _categories => [
    AppStrings.get('الكل', 'All'),
    AppStrings.get('الثوب', 'Thobe'),
    AppStrings.get('الكنب', 'Sofas'),
    AppStrings.get('رياضية', 'Sports'),
    AppStrings.get('الصارون', 'Sarong'),
    AppStrings.get('سجاد ومفروشات', 'Carpets & Rugs'),
    AppStrings.get('المفروشات', 'Furnishings'),
  ];

  @override
  Widget build(BuildContext context) {
    final Map<String, int> cart = widget.cart;
    final int totalCartItems = widget.totalCartItems;
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
                  onPressed: widget.onOpenCart,
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
                isDarkModeNotifier.value = !isDarkModeNotifier.value;
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
                        final int countInCart = cart[service.id] ?? 0;
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
                                              onPressed: () => widget
                                                  .onIncrementCart(service.id),
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
                                                    widget.onRemoveFromCart(
                                                      service.id,
                                                    ),
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
                                                      onTap: () => widget
                                                          .onDecrementCart(
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
                                                      onTap: () => widget
                                                          .onIncrementCart(
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
                    onPressed: widget.onOpenCart,
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
}
