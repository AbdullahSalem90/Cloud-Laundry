import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laundry_flow/main.dart'; // ⬅️ تم تعديل المسار هنا بناءً على طلبك

void main() {
  testWidgets('App starts successfully', (WidgetTester tester) async {
    // بناء التطبيق باستخدام الاسم الصحيح
    await tester.pumpWidget(const MyApp());

    // اختبار بسيط للتأكد من عمل التطبيق
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
