import 'package:clean_pill_navbar/clean_pill_navbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const items = [
    CleanPillNavBarItem(icon: CupertinoIcons.house),
    CleanPillNavBarItem(icon: CupertinoIcons.search),
    CleanPillNavBarItem(icon: CupertinoIcons.heart),
  ];

  testWidgets('renders all items and highlights selected one', (tester) async {
    var selected = 0;

    await tester.pumpWidget(
      CupertinoApp(
        home: StatefulBuilder(
          builder: (context, setState) {
            return CleanPillNavBar(
              items: items,
              selectedIndex: selected,
              onTap: (i) => setState(() => selected = i),
            );
          },
        ),
      ),
    );

    expect(find.byIcon(CupertinoIcons.house), findsOneWidget);
    expect(find.byIcon(CupertinoIcons.search), findsOneWidget);
    expect(find.byIcon(CupertinoIcons.heart), findsOneWidget);

    await tester.tap(find.byIcon(CupertinoIcons.search));
    await tester.pumpAndSettle();

    expect(selected, 1);
  });

  test('asserts item count bounds', () {
    expect(
      () => CleanPillNavBar(items: [items[0]], selectedIndex: 0, onTap: (_) {}),
      throwsAssertionError,
    );
  });
}