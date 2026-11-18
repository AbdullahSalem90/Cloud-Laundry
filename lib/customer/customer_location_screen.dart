// مسار الملف: lib/customer/customer_location_screen.dart
// هذه الشاشة تعرض الخريطة وتسمح للعميل بحفظ تفاصيل عنوان الاستلام.

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../core/app_data.dart';
import '../core/app_constants.dart';

class CustomerLocationScreen extends StatelessWidget {
  const CustomerLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          // 1. الخريطة 
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

          const Center(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: 40.0,
              ), 
              child: Icon(Icons.location_on, size: 50, color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddressDetailsBottomSheet(BuildContext context) {
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
}
