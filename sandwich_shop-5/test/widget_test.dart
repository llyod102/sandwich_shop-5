import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  group('App', () {
    testWidgets('renders OrderScreen as home', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(OrderScreen), findsOneWidget);
    });
  });

  group('OrderScreen - Quantity', () {
    testWidgets('shows title and initial quantity',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      expect(find.text('Sandwich Counter'), findsOneWidget);
      expect(find.text('Quantity: '), findsOneWidget);
      expect(find.text('1'), findsWidgets); // initial quantity is 1
    });

    testWidgets('increments quantity when + is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      expect(find.text('2'), findsWidgets);
    });

    testWidgets('decrements quantity when - is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();
      expect(find.text('0'), findsWidgets);
    });

    testWidgets('does not decrement below zero', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      // Tap remove twice; should clamp at 0
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();
      expect(find.text('0'), findsWidgets);
    });
  });

  group('OrderScreen - Controls', () {
    testWidgets('toggles sandwich size with Switch',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(Switch), findsOneWidget);
      await tester.tap(find.byType(Switch));
      await tester.pump();
      // No visible text changes; just ensure it toggles without error
      expect(find.byType(Switch), findsOneWidget);
    });

    testWidgets('changes bread type with DropdownMenu',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.tap(find.byType(DropdownMenu<BreadType>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('wheat').last);
      await tester.pumpAndSettle();
      // Selected label should now show somewhere
      expect(find.text('wheat'), findsWidgets);
    });
  });

  group('Add to Cart', () {
    testWidgets('shows SnackBar confirmation when adding to cart',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Tap "Add to Cart" button
      await tester.tap(find.widgetWithText(ElevatedButton, 'Add to Cart'));
      await tester.pump(); // Start the animation
      await tester
          .pump(const Duration(milliseconds: 100)); // Let SnackBar appear

      // Verify SnackBar appears with confirmation message
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.textContaining('Added'), findsOneWidget);
      expect(find.textContaining('Veggie Delight'), findsOneWidget);
      expect(find.textContaining('cart'), findsOneWidget);
    });

    testWidgets('SnackBar message includes quantity and sandwich details',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Increase quantity to 2
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      // Tap "Add to Cart"
      await tester.tap(find.widgetWithText(ElevatedButton, 'Add to Cart'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Check message contains quantity
      expect(find.textContaining('Added 2'), findsOneWidget);
      expect(find.textContaining('footlong'), findsOneWidget);
    });
  });

  group('StyledButton', () {
    testWidgets('renders with icon and label', (WidgetTester tester) async {
      const testButton = StyledButton(
        onPressed: null,
        icon: Icons.add,
        label: 'Test Add',
        backgroundColor: Colors.blue,
      );
      const testApp = MaterialApp(
        home: Scaffold(body: testButton),
      );
      await tester.pumpWidget(testApp);
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.text('Test Add'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });
  });
}
