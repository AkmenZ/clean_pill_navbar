import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'pill_navbar_item.dart';

/// Maximum number of tabs supported.
///
/// This mirrors Apple's own tab bar convention (UITabBar shows a "More"
/// overflow beyond 5 items), and keeps pill sizing visually consistent.
const int kPillNavBarMaxItems = 5;

/// A clean, customizable, iOS 26+ inspired pill-shaped navigation bar.
///
/// Framework-agnostic: works with `cupertino_ui`, `material_ui`, or plain
/// Flutter widgets since it only depends on `package:flutter/widgets.dart`.
///
/// No blur/glass effects by default — but an optional frosted-glass
/// background can be enabled via [enableBackgroundBlur].
class PillNavBar extends StatelessWidget {
  const PillNavBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onTap,
    this.height = 64,
    this.itemWidth,
    this.minItemWidth = 56,
    this.maxItemWidth = 96,
    this.outerPadding = 3,
    this.backgroundColor = const Color(0xFFF2F2F7),
    this.borderColor = const Color(0xFFD0D0D5),
    this.indicatorColor = const Color(0xFFFFFFFF),
    this.indicatorBorderColor = const Color(0xFFD0D0D5),
    this.selectedColor = const Color(0xFF000000),
    this.unselectedColor = const Color(0xFF8E8E93),
    this.iconSize = 24,
    this.showLabels = false,
    this.showSelectedLabelOnly = false,
    this.labelStyle,
    this.duration = const Duration(milliseconds: 280),
    this.curve = Curves.easeOutCubic,
    this.enableHapticFeedback = true,
    this.borderRadius = const BorderRadius.all(Radius.circular(999)),
    this.border,
    this.enableBackgroundBlur = false,
    this.blurSigma = 20,
    this.elevation = 0,
    this.shadowColor = const Color(0x33000000),
    this.boxShadow,
  }) : assert(
         items.length >= 2 && items.length <= kPillNavBarMaxItems,
         'PillNavBar supports between 2 and $kPillNavBarMaxItems items.',
       ),
       assert(
         selectedIndex >= 0 && selectedIndex < items.length,
         'selectedIndex must be a valid index into items.',
       ),
       assert(blurSigma >= 0, 'blurSigma must be non-negative.'),
       assert(elevation >= 0, 'elevation must be non-negative.');

  /// The tabs to display. Must contain between 2 and [kPillNavBarMaxItems] items.
  final List<PillNavBarItem> items;

  /// Index of the currently selected item.
  final int selectedIndex;

  /// Called with the tapped index.
  final ValueChanged<int> onTap;

  /// Height of the nav bar.
  final double height;

  /// Fixed width per item. If null, width is computed from available space.
  final double? itemWidth;

  /// Minimum width per item when auto-sizing.
  final double minItemWidth;

  /// Maximum width per item when auto-sizing.
  final double maxItemWidth;

  /// Padding between the outer pill border and the items row.
  final double outerPadding;

  /// Background color of the outer pill. Use a translucent color (e.g. via
  /// [Color.withValues] or an ARGB alpha < 255) together with
  /// [enableBackgroundBlur] for a frosted-glass effect.
  final Color backgroundColor;

  /// Border color of the outer pill.
  final Color borderColor;

  /// Color of the sliding selection indicator.
  final Color indicatorColor;

  /// Border color of the sliding selection indicator.
  final Color indicatorBorderColor;

  /// Icon/label color for the selected item.
  final Color selectedColor;

  /// Icon/label color for unselected items.
  final Color unselectedColor;

  /// Size of each icon.
  final double iconSize;

  /// Whether to show labels under the icons for all tabs.
  /// Ignored if [showSelectedLabelOnly] is `true`.
  final bool showLabels;

  /// Whether to show a label only under the currently selected tab,
  /// matching a common iOS tab bar pattern. When `true`, this takes
  /// priority over [showLabels].
  final bool showSelectedLabelOnly;

  /// Optional custom text style for labels.
  final TextStyle? labelStyle;

  /// Duration of the selection indicator slide animation.
  final Duration duration;

  /// Curve of the selection indicator slide animation.
  final Curve curve;

  /// Whether to trigger `HapticFeedback.selectionClick()` on tap.
  final bool enableHapticFeedback;

  /// Border radius of the outer pill and the indicator.
  final BorderRadius borderRadius;

  /// Optional custom border for the outer pill. Defaults to a 1px solid
  /// border using [borderColor].
  final BoxBorder? border;

  /// Whether to apply a background blur (frosted-glass) effect behind the pill.
  /// Only affects the background layer — icons and the selection
  /// indicator remain fully sharp on top. Defaults to `false` (no blur).
  final bool enableBackgroundBlur;

  /// The blur sigma used when [enableBackgroundBlur] is `true`.
  final double blurSigma;

  /// Controls the default drop shadow intensity/spread behind the pill,
  /// similar to Material elevation. Ignored if [boxShadow] is provided.
  /// A value of `0` (the default) means no shadow.
  final double elevation;

  /// The color used for the default elevation-based shadow.
  /// Ignored if [boxShadow] is provided.
  final Color shadowColor;

  /// A fully custom shadow list for the pill. Overrides [elevation] and
  /// [shadowColor] when provided.
  final List<BoxShadow>? boxShadow;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final resolvedItemWidth = _resolveItemWidth(constraints.maxWidth);
        final resolvedShadow = boxShadow ?? _defaultShadowForElevation();

        return Container(
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            boxShadow: resolvedShadow,
          ),
          child: ClipRRect(
            borderRadius: borderRadius,
            child: Stack(
              children: [
                // Background layer (optionally blurred), isolated from
                // the sharp foreground content below.
                Positioned.fill(
                  child: enableBackgroundBlur
                      ? BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: blurSigma,
                            sigmaY: blurSigma,
                          ),
                          child: DecoratedBox(
                            decoration: BoxDecoration(color: backgroundColor),
                          ),
                        )
                      : DecoratedBox(
                          decoration: BoxDecoration(color: backgroundColor),
                        ),
                ),
                Container(
                  height: height,
                  padding: EdgeInsets.all(outerPadding),
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: borderRadius,
                    border: border ?? Border.all(color: borderColor),
                  ),
                  child: Stack(
                    children: [
                      AnimatedPositioned(
                        duration: duration,
                        curve: curve,
                        left: selectedIndex * resolvedItemWidth,
                        top: 0,
                        bottom: 0,
                        child: Container(
                          width: resolvedItemWidth,
                          decoration: BoxDecoration(
                            color: indicatorColor,
                            borderRadius: borderRadius,
                            border: Border.all(color: indicatorBorderColor),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(items.length, (index) {
                          final item = items[index];
                          final selected = selectedIndex == index;

                          return _PillNavBarTab(
                            item: item,
                            width: resolvedItemWidth,
                            height: height,
                            selected: selected,
                            iconSize: iconSize,
                            selectedColor: selectedColor,
                            unselectedColor: unselectedColor,
                            showLabel: showSelectedLabelOnly
                                ? selected
                                : showLabels,
                            labelStyle: labelStyle,
                            onTap: () {
                              if (enableHapticFeedback) {
                                HapticFeedback.selectionClick();
                              }
                              onTap(index);
                            },
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<BoxShadow> _defaultShadowForElevation() {
    if (elevation <= 0) return const [];

    return [
      BoxShadow(
        color: shadowColor,
        blurRadius: elevation * 2,
        spreadRadius: elevation * 0.2,
        offset: Offset(0, elevation * 0.5),
      ),
    ];
  }

  double _resolveItemWidth(double maxWidth) {
    if (itemWidth != null) return itemWidth!;

    final available = maxWidth.isFinite
        ? maxWidth - outerPadding * 2
        : double.infinity;
    if (!available.isFinite) return maxItemWidth;

    // Subtract a tiny epsilon to guard against floating-point rounding
    // causing a 1-2px RenderFlex overflow in the Row below.
    final computed = (available / items.length) - 0.5;
    return computed.clamp(minItemWidth, maxItemWidth);
  }
}

class _PillNavBarTab extends StatelessWidget {
  const _PillNavBarTab({
    required this.item,
    required this.width,
    required this.height,
    required this.selected,
    required this.iconSize,
    required this.selectedColor,
    required this.unselectedColor,
    required this.showLabel,
    required this.labelStyle,
    required this.onTap,
  });

  final PillNavBarItem item;
  final double width;
  final double height;
  final bool selected;
  final double iconSize;
  final Color selectedColor;
  final Color unselectedColor;
  final bool showLabel;
  final TextStyle? labelStyle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? selectedColor : unselectedColor;
    final icon = selected ? (item.selectedIcon ?? item.icon) : item.icon;

    return Semantics(
      button: true,
      selected: selected,
      label: item.label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SizedBox(
          width: width,
          height: height,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: iconSize, color: color),
                if (showLabel && item.label != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    item.label!,
                    style:
                        labelStyle?.copyWith(color: color) ??
                        TextStyle(fontSize: 12, color: color),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}