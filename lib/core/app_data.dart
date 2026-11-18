// مسار الملف: lib/core/app_data.dart
String globalSavedAddress = '';

class LaundryServiceItem {
  final String id;
  final String nameAr;
  final String nameEn;
  final double price;
  final String category;
  final String imagePath;

  LaundryServiceItem({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.price,
    required this.category,
    required this.imagePath,
  });
}

class LaundryOrder {
  final String id;
  final String customerName;
  final String customerPhone;
  final String serviceNameAr;
  final String serviceNameEn;
  final int quantity;
  final double totalPrice;
  String status; // 'pending_pickup' (بانتظار الاستلام), 'in_laundry' (في المغسلة), 'out_for_delivery' (جاري التوصيل), 'completed' (مكتمل)
  final String createdAt;

  //    (أوقات المندوب)
  final String pickupTime;
  final String deliveryTime;

  LaundryOrder({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.serviceNameAr,
    required this.serviceNameEn,
    required this.quantity,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
    required this.pickupTime,
    required this.deliveryTime,
  });
}

class Customer {
  final String id;
  final String name;
  final String phone;

  Customer({required this.id, required this.name, required this.phone});
}

class AppData {
  // قائمة الخدمات السحابية
  static List<LaundryServiceItem> services = [
    LaundryServiceItem(
      id: 's0',
      nameAr: 'غسيل كيس كامل (Wash & Fold)',
      nameEn: 'Full Bag (Wash & Fold)',
      price: 49,
      category: 'الكل',
      imagePath: 'assets/images/blanket.png',
    ),

    LaundryServiceItem(
      id: 's1',
      nameAr: 'غسيل وكوي ثوب',
      nameEn: 'Thobe Wash & Iron',
      price: 10,
      category: 'الثوب',
      imagePath: 'assets/images/wash_iron.png',
    ),
    LaundryServiceItem(
      id: 's2',
      nameAr: 'تنظيف كنب ومجالس',
      nameEn: 'Sofa Cleaning',
      price: 50,
      category: 'الكنب',
      imagePath: 'assets/images/carpet.png',
    ),
    LaundryServiceItem(
      id: 's3',
      nameAr: 'طقم رياضي',
      nameEn: 'Sports Kit',
      price: 15,
      category: 'رياضية',
      imagePath: 'assets/images/dry_clean.png',
    ),
    LaundryServiceItem(
      id: 's4',
      nameAr: 'غسيل شماغ / صارون',
      nameEn: 'Shemagh Care',
      price: 5,
      category: 'الصارون',
      imagePath: 'assets/images/wash_iron.png',
    ),
    LaundryServiceItem(
      id: 's5',
      nameAr: 'غسيل بطانية',
      nameEn: 'Blanket Wash',
      price: 35,
      category: 'سجاد ومفروشات',
      imagePath: 'assets/images/blanket.png',
    ),
    LaundryServiceItem(
      id: 's6',
      nameAr: 'غسيل سجاد',
      nameEn: 'Carpet Wash',
      price: 45,
      category: 'سجاد ومفروشات',
      imagePath: 'assets/images/carpet.png',
    ),
  ];

  static List<LaundryOrder> orders = [
    LaundryOrder(
      id: 'ORD-101',
      customerName: 'عبدالله طالب',
      customerPhone: '0500000000',
      serviceNameAr: 'غسيل كيس كامل (Wash & Fold) (x1)',
      serviceNameEn: 'Full Bag (Wash & Fold) (x1)',
      quantity: 1,
      totalPrice: 49,
      status: 'pending_pickup', // بانتظار استلام المندوب
      createdAt: '2026-11-10 • 10:30',
      pickupTime: 'اليوم - 04:00 م إلى 06:00 م',
      deliveryTime: 'غداً - 08:00 م إلى 10:00 م',
    ),
  ];

  static List<Customer> customers = [
    Customer(id: 'C1', name: 'عبدالله طالب', phone: '0500000000'),
  ];
}
