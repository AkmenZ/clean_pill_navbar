import 'package:clean_pill_navbar/clean_pill_navbar.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const icon = IconData(0xe000, fontFamily: 'test');

  test('throws when more than kPillNavBarMaxItems are provided', () {
    final tooMany = List.generate(
      kPillNavBarMaxItems + 1,
      (_) => const PillNavBarItem(icon: icon),
    );

    expect(
      () => PillNavBar(items: tooMany, selectedIndex: 0, onTap: (_) {}),
      throwsAssertionError,
    );
  });

  test('allows exactly kPillNavBarMaxItems', () {
    final maxItems = List.generate(
      kPillNavBarMaxItems,
      (_) => const PillNavBarItem(icon: icon),
    );

    expect(
      () => PillNavBar(items: maxItems, selectedIndex: 0, onTap: (_) {}),
      returnsNormally,
    );
  });

  testWidgets('shows labels when showLabels is true', (tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: PillNavBar(
          items: const [
            PillNavBarItem(icon: icon, label: 'One'),
            PillNavBarItem(icon: icon, label: 'Two'),
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