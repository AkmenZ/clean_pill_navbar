import 'package:clean_pill_navbar/clean_pill_navbar.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const icon = IconData(0xe000, fontFamily: 'test');

  test('throws when more than kPillNavBarMaxItems are provided', () {
    final tooMany = List.generate(
      kCleanPillNavBarMaxItems + 1,
      (_) => const CleanPillNavBarItem(icon: icon),
    );

    expect(
      () => CleanPillNavBar(items: tooMany, selectedIndex: 0, onTap: (_) {}),
      throwsAssertionError,
    );
  });

  test('allows exactly kPillNavBarMaxItems', () {
    final maxItems = List.generate(
      kCleanPillNavBarMaxItems,
      (_) => const CleanPillNavBarItem(icon: icon),
    );

    expect(
      () => CleanPillNavBar(items: maxItems, selectedIndex: 0, onTap: (_) {}),
      returnsNormally,
    );
  });

  testWidgets('shows labels when showLabels is true', (tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: CleanPillNavBar(
          items: const [
            CleanPillNavBarItem(icon: icon, label: 'One'),
            CleanPillNavBarItem(icon: icon, label: 'Two'),
          ],
          selectedIndex: 0,
          onTap: (_) {},
          showLabels: true,
        ),
      ),
    );

    expect(find.text('One'), findsOneWidget);
    expect(find.text('Two'), findsOneWidget);
  });
}