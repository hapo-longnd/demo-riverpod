// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:demo_riverpod/products/pages/favorite_list_page.dart';
import 'package:demo_riverpod/products/product_page.dart';
import 'package:demo_riverpod/products/widgets/card_item_product_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Test favorite page', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: FavoriteListPage(),
          ),
        ),
      ),
    );

    await tester.pump();
    expect(find.byType(SpinKitCircle), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(SpinKitCircle), findsNothing);
    expect(find.text("No data"), findsOneWidget);
  });

  testWidgets('Test product page', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: ProductsPage(),
          ),
        ),
      ),
    );

    // await tester.pump();
    // expect(find.byType(SpinKitCircle), findsOneWidget);
    // await tester.pump(const Duration(seconds: 1));
    // expect(find.byType(SpinKitCircle), findsNothing);
    // expect(tester.widgetList(find.byType(CardItemProductWidget)), findsWidgets);
  });
}
