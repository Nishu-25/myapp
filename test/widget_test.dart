import 'package:flutter_test/flutter_test.dart';

import 'package:myapp/main.dart';

void main() {
  testWidgets('Calculator app renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const CalculatorApp());

    // Display starts at 0
    expect(find.text('0'), findsWidgets);

    // Key buttons are present
    expect(find.text('C'), findsOneWidget);
    expect(find.text('='), findsOneWidget);
    expect(find.text('+'), findsOneWidget);
    expect(find.text('÷'), findsOneWidget);
  });

  testWidgets('Calculator digit input works', (WidgetTester tester) async {
    await tester.pumpWidget(const CalculatorApp());

    // Tap 5 then 3 using the button with the exact label
    await tester.tap(find.text('5').first);
    await tester.pump();

    await tester.tap(find.text('3').first);
    await tester.pump();

    // The display should show 53. It uses FittedBox with a larger font.
    expect(find.text('53'), findsOneWidget);
  });

  testWidgets('Calculator clear button resets display', (WidgetTester tester) async {
    await tester.pumpWidget(const CalculatorApp());

    // Tap the '7' button (first occurrence is the button in the grid)
    await tester.tap(find.text('7').first);
    await tester.pump();

    // Tap C to clear
    await tester.tap(find.text('C'));
    await tester.pump();

    // Display should be back to 0
    expect(find.text('0'), findsWidgets);
  });
}
