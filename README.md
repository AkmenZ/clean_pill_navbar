# clean_pill_navbar

A customizable, iOS-inspired pill-shaped bottom navigation bar for Flutter — no blur/glass effects, just a clean animated pill indicator.

Framework-agnostic: works with the new decoupled `cupertino_ui` and `material_ui`
packages, or plain `flutter/cupertino.dart` / `flutter/material.dart` — the
package only depends on `flutter/widgets.dart` and accepts plain `IconData`,
`Color`, and `TextStyle` values, so you can wire it to whichever UI library
your app uses.

## Features
- Solid pill-shaped nav bar with sliding selection indicator
- Customizable background, border, indicator, and colors
- Optional labels
- Supports 2–5 items (matches Apple's own tab bar overflow convention)
- Haptic feedback on tap
- Works with `cupertino_ui`, `material_ui`, or classic `flutter/cupertino.dart` / `flutter/material.dart`

## Usage

```dart
PillNavBar(
  items: const [
    PillNavBarItem(icon: CupertinoIcons.house, label: 'Home'),
    PillNavBarItem(icon: CupertinoIcons.search, label: 'Search'),
  ],
  selectedIndex: selectedIndex,
  onTap: (i) => setState(() => selectedIndex = i),
)
```

See `example/` for both a `cupertino_ui` and a `material_ui` demo.

## License
MIT