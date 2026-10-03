import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'pill_navbar_item.dart';

/// Maximum number of tabs supported.
const int kCleanPillNavBarMaxItems = 5;

/// A clean, customizable, iOS 26+ inspired pill-shaped navigation bar.
class CleanPillNavBar extends StatelessWidget {
  const CleanPillNavBar({
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
    this.fadeDuration = const Duration(milliseconds: 200),
    this.enableHapticFeedback = true,
    this.enableIndicatorDrag = true,
    this.borderRadius = const BorderRadius.all(Radius.circular(999)),
    this.border,
    this.enableBackgroundBlur = false,
    this.blurSigma = 20,
    this.elevation = 0,
    this.shadowColor = const Color(0x33000000),
    this.boxShadow,
  }) : assert(
         items.length >= 2 && items.length <= kCleanPillNavBarMaxItems,
         'CleanPillNavBar supports between 2 and $kCleanPillNavBarMaxItems items.',
       ),
       assert(
         selectedIndex >= 0 && selectedIndex < items.length,
         'selectedIndex must be a valid index into items.',
       ),
       assert(blurSigma >= 0, 'blurSigma must be non-negative.'),
       assert(elevation >= 0, 'elevation must be non-negative.');

  final List<CleanPillNavBarItem> items;
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final double height;
  final double? itemWidth;
  final double minItemWidth;
  final double maxItemWidth;
  final double outerPadding;
  final Color backgroundColor;
  final Color borderColor;
  final Color indicatorColor;
  final Color indicatorBorderColor;
  final Color selectedColor;
  final Color unselectedColor;
  final double iconSize;
  final bool showLabels;
  final bool showSelectedLabelOnly;
  final TextStyle? labelStyle;
  final Duration duration;
  final Curve curve;
  final Duration fadeDuration;
  final bool enableHapticFeedback;

  /// Whether the user can tap-and-hold anywhere on the bar to drag the
  /// selection indicator, snapping to the nearest tab on release.
  /// Defaults to `true`.
  final bool enableIndicatorDrag;

  final BorderRadius borderRadius;
  final BoxBorder? border;
  final bool enableBackgroundBlur;
  final double blurSigma;
  final double elevation;
  final Color shadowColor;
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
                  child: _PillNavBarBody(
                    items: items,
                    selectedIndex: selectedIndex,
                    itemWidth: resolvedItemWidth,
                    height: height - outerPadding * 2,
                    iconSize: iconSize,
                    selectedColor: selectedColor,
                    unselectedColor: unselectedColor,
                    showLabels: showLabels,
                    showSelectedLabelOnly: showSelectedLabelOnly,
                    labelStyle: labelStyle,
                    duration: duration,
                    curve: curve,
                    fadeDuration: fadeDuration,
                    enableHapticFeedback: enableHapticFeedback,
                    enableIndicatorDrag: enableIndicatorDrag,
                    borderRadius: borderRadius,
                    indicatorColor: indicatorColor,
                    indicatorBorderColor: indicatorBorderColor,
                    onChanged: onTap,
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
    final computed = (available / items.length) - 0.5;
    return computed.clamp(minItemWidth, maxItemWidth);
  }
}

/// Handles the full-width drag surface plus rendering the indicator and tabs.
class _PillNavBarBody extends StatefulWidget {
  const _PillNavBarBody({
    required this.items,
    required this.selectedIndex,
    required this.itemWidth,
    required this.height,
    required this.iconSize,
    required this.selectedColor,
    required this.unselectedColor,
    required this.showLabels,
    required this.showSelectedLabelOnly,
    required this.labelStyle,
    required this.duration,
    required this.curve,
    required this.fadeDuration,
    required this.enableHapticFeedback,
    required this.enableIndicatorDrag,
    required this.borderRadius,
    required this.indicatorColor,
    required this.indicatorBorderColor,
    required this.onChanged,
  });

  final List<CleanPillNavBarItem> items;
  final int selectedIndex;
  final double itemWidth;
  final double height;
  final double iconSize;
  final Color selectedColor;
  final Color unselectedColor;
  final bool showLabels;
  final bool showSelectedLabelOnly;
  final TextStyle? labelStyle;
  final Duration duration;
  final Curve curve;
  final Duration fadeDuration;
  final bool enableHapticFeedback;
  final bool enableIndicatorDrag;
  final BorderRadius borderRadius;
  final Color indicatorColor;
  final Color indicatorBorderColor;
  final ValueChanged<int> onChanged;

  @override
  State<_PillNavBarBody> createState() => _PillNavBarBodyState();
}

class _PillNavBarBodyState extends State<_PillNavBarBody> {
  bool _dragging = false;
  double _dragLeft = 0;
  Offset? _downPosition;

  /// The index currently pressed/held, used to drive the indicator's visual
  /// position immediately on press — independent from the actual committed
  /// `widget.selectedIndex`, which only updates via `onChanged` on release.
  int? _pressedIndex;

  // Small tolerance to absorb pointer jitter on a "clean" tap so it doesn't
  // mistakenly engage live drag tracking (which skips the slide animation).
  static const double _dragEngageThreshold = 6.0;

  double get _maxLeft => (widget.items.length - 1) * widget.itemWidth;

  int _indexForLeft(double left) {
    final raw = (left / widget.itemWidth).round();
    return raw.clamp(0, widget.items.length - 1);
  }

  double _leftForDx(double dx) {
    final left = dx - widget.itemWidth / 2;
    return left.clamp(0, _maxLeft);
  }

  void _onPanDown(DragDownDetails details) {
    if (!widget.enableIndicatorDrag) return;

    _downPosition = details.localPosition;

    // Move the indicator visually right away, but do NOT commit the
    // selection yet — that only happens on release.
    final tapped = _indexForLeft(_leftForDx(details.localPosition.dx));
    setState(() {
      _pressedIndex = tapped;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!widget.enableIndicatorDrag) return;

    if (!_dragging) {
      final start = _downPosition;
      if (start == null) return;
      final moved = (details.localPosition.dx - start.dx).abs();
      if (moved < _dragEngageThreshold) {
        // Still within jitter tolerance — ignore.
        return;
      }
      // Real movement — engage live tracking, continuing from wherever
      // the pill currently visually is (the pressed index's position).
      setState(() {
        _dragging = true;
        _dragLeft = (_pressedIndex ?? widget.selectedIndex) * widget.itemWidth;
      });
    }

    setState(() {
      _dragLeft = _leftForDx(details.localPosition.dx);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (!widget.enableIndicatorDrag) return;
    _downPosition = null;

    final resolvedIndex = _dragging
        ? _indexForLeft(_dragLeft)
        : (_pressedIndex ?? widget.selectedIndex);

    setState(() {
      _dragging = false;
      _pressedIndex = null;
    });

    if (resolvedIndex != widget.selectedIndex) {
      if (widget.enableHapticFeedback) {
        HapticFeedback.selectionClick();
      }
      widget.onChanged(resolvedIndex);
    }
  }

  void _onPanCancel() {
    setState(() {
      _dragging = false;
      _pressedIndex = null;
    });
    _downPosition = null;
  }

  @override
  Widget build(BuildContext context) {
    final pill = Container(
      width: widget.itemWidth,
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.indicatorColor,
        borderRadius: widget.borderRadius,
        border: Border.all(color: widget.indicatorBorderColor),
      ),
    );

    final visualIndex = _pressedIndex ?? widget.selectedIndex;

    final indicator = AnimatedPositioned(
      duration: _dragging ? Duration.zero : widget.duration,
      curve: widget.curve,
      left: _dragging ? _dragLeft : visualIndex * widget.itemWidth,
      top: 0,
      bottom: 0,
      child: pill,
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanDown: _onPanDown,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      onPanCancel: _onPanCancel,
      child: Stack(
        children: [
          indicator,
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(widget.items.length, (index) {
              final item = widget.items[index];
              final selected = widget.selectedIndex == index;

              return _PillNavBarTab(
                item: item,
                width: widget.itemWidth,
                height: widget.height,
                selected: selected,
                iconSize: widget.iconSize,
                selectedColor: widget.selectedColor,
                unselectedColor: widget.unselectedColor,
                showLabel: widget.showSelectedLabelOnly
                    ? selected
                    : widget.showLabels,
                labelStyle: widget.labelStyle,
                fadeDuration: widget.fadeDuration,
              );
            }),
          ),
        ],
      ),
    );
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
    required this.fadeDuration,
  });

  final CleanPillNavBarItem item;
  final double width;
  final double height;
  final bool selected;
  final double iconSize;
  final Color selectedColor;
  final Color unselectedColor;
  final bool showLabel;
  final TextStyle? labelStyle;
  final Duration fadeDuration;

  @override
  Widget build(BuildContext context) {
    final color = selected ? selectedColor : unselectedColor;
    final icon = selected ? (item.selectedIcon ?? item.icon) : item.icon;

    final labelWidget = (showLabel && item.label != null)
        ? Text(
            item.label!,
            key: const ValueKey<String>('label'),
            style:
                labelStyle?.copyWith(color: color) ??
                TextStyle(fontSize: 12, color: color),
          )
        : const SizedBox.shrink(key: ValueKey<String>('empty'));

    // Note: no GestureDetector/onTap here anymore — the parent's single
    // full-bar GestureDetector (in _PillNavBarBody) handles both quick taps
    // and drags via onPanDown/onPanUpdate/onPanEnd, since a quick tap with
    // no movement resolves to the same index at onPanDown as at onPanEnd.
    return Semantics(
      button: true,
      selected: selected,
      label: item.label,
      child: SizedBox(
        width: width,
        height: height,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: fadeDuration,
                reverseDuration: Duration.zero,
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (child, animation) =>
                    FadeTransition(opacity: animation, child: child),
                child: Icon(
                  icon,
                  key: ValueKey<bool>(selected),
                  size: iconSize,
                  color: color,
                ),
              ),
              const SizedBox(height: 2),
              AnimatedSwitcher(
                duration: fadeDuration,
                reverseDuration: Duration.zero,
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (child, animation) =>
                    FadeTransition(opacity: animation, child: child),
                child: labelWidget,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
