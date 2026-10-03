# clean_pill_navbar

A customizable, iOS 26+ inspired pill-shaped bottom navigation bar for Flutter — no glass effects by default, just a clean animated pill indicator (with an optional frosted-glass blur if you want it).

Framework-agnostic: works with the new decoupled `cupertino_ui` and `material_ui`
packages, or plain `flutter/cupertino.dart` / `flutter/material.dart` — the
package only depends on `flutter/widgets.dart` and accepts plain `IconData`,
`Color`, and `TextStyle` values, so you can wire it to whichever UI library
your app uses.

## Preview

![CleanPillNavBar demo](https://raw.githubusercontent.com/AkmenZ/clean_pill_navbar/main/screenshots/demo.gif)

## Features
- Solid pill-shaped nav bar with an animated sliding selection indicator
- Tap-and-hold anywhere on the bar to drag the indicator — it follows your finger and commits to the nearest tab on release (togglable via `enableIndicatorDrag`)
- Smooth fade-in for icons/labels when a tab becomes selected
- Fully customizable background, border, indicator, and text/icon colors
- Optional labels — show them for all tabs, or only for the selected tab (`showSelectedLabelOnly`)
- Optional frosted-glass background blur (`enableBackgroundBlur` + `blurSigma`), fully opt-in
- Optional elevation/drop shadow (`elevation`, or a fully custom `boxShadow`)
- Supports 2–5 items (matches Apple's own tab bar overflow convention)
- Haptic feedback on tap (togglable via `enableHapticFeedback`)
- Works with `cupertino_ui`, `material_ui`, or classic `flutter/cupertino.dart` / `flutter/material.dart`

## Usage

Basic:

```dart
CleanPillNavBar(
  items: const [
    CleanPillNavBarItem(icon: Icons.home_outlined, selectedIcon: Icons.home, label: 'Home'),
    CleanPillNavBarItem(icon: Icons.search, label: 'Search'),
  ],
  selectedIndex: selectedIndex,
  onTap: (i) => setState(() => selectedIndex = i),
)
```

With labels only on the selected tab, a frosted-glass background, and a subtle shadow:

```dart
CleanPillNavBar(
  items: items,
  selectedIndex: selectedIndex,
  onTap: (i) => setState(() => selectedIndex = i),
  showSelectedLabelOnly: true,
  backgroundColor: const Color(0xB3F2F2F7),
  enableBackgroundBlur: true,
  blurSigma: 18,
  elevation: 8,
)
```

For the frosted-glass/blur effect to actually show underlying content, place `CleanPillNavBar` as a floating overlay (e.g. via `Stack` + `Positioned`/`Align`) above scrollable content, rather than inside `Scaffold.bottomNavigationBar` — the latter reserves an opaque, non-transparent slot and won't let content scroll behind it.

See `example/` for a full demo with scrollable content behind a floating, blurred pill nav bar.

## Item limit

`CleanPillNavBar` supports **2 to 5 items**. This mirrors Apple's own `UITabBar` convention (which shows a "More" overflow beyond 5 items) and keeps pill sizing visually consistent. Passing fewer than 2 or more than 5 items throws an assertion in debug mode.

## Routing

`CleanPillNavBar` is fully decoupled from any navigation package. It works well as the visual layer for a `go_router` `StatefulShellRoute.indexedStack`, a plain `IndexedStack`, or any other tab-based navigation approach — just feed it `selectedIndex` and handle `onTap` however your routing is set up.

## License
MIT