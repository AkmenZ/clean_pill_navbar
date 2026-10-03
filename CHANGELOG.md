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