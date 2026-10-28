## 1.0.2

* Updated press-scale effect: the whole bar now scales down slightly while touched (and stays scaled while held or dragged), then gives a brief scale-up bump on release before settling back to normal. Still opt out via `enablePressScale: false`.

## 1.0.1

* Added press-scale effect: the whole bar (background, indicator, icons and labels) scales up slightly when touched, stays scaled while held or dragged, and scales back on release. Quick taps still show a brief scale-up. Opt out via `enablePressScale: false`.

## 1.0.0

* **Breaking:** Renamed `PillNavBar` → `CleanPillNavBar`, `PillNavBarItem` → `CleanPillNavBarItem`, and `kPillNavBarMaxItems` → `kCleanPillNavBarMaxItems` to match the package name.
* Added smooth fade-in transitions for the icon and label when a tab becomes selected (instant fade-out when deselected).
* Added draggable selection indicator: tap-and-hold anywhere on the bar and the pill slides to follow your finger; the new tab is only committed on release. Opt out via `enableIndicatorDrag: false`.
* Added `fadeDuration` to control the icon/label fade timing independently from the indicator's slide `duration`.

## 0.0.2

* Added demo GIF to README.

## 0.0.1

* Initial release: PillNavBar widget with customizable colors, border, and 2–5 item support.
* Added `showSelectedLabelOnly` for showing a label only under the active tab.
* Added `enableBackgroundBlur` / `blurSigma` for an optional frosted-glass background.
* Added `elevation`, `shadowColor`, and `boxShadow` for optional drop shadows.
* Default label font size increased to 12.