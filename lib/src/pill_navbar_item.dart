import 'package:flutter/widgets.dart';

/// Represents a single tab in a [PillNavBar].
@immutable
class CleanPillNavBarItem {
  const CleanPillNavBarItem({
    required this.icon,
    this.selectedIcon,
    this.label,
  });

  /// Icon shown when the item is not selected.
  final IconData icon;

  /// Optional icon shown when the item is selected.
  /// Falls back to [icon] if not provided.
  final IconData? selectedIcon;

  // Optional label shown below the icon when labels are enabled.
  final String? label;
}