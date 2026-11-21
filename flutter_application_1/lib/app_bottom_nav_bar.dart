import 'package:material_ui/material_ui.dart';

import 'app_colors.dart';

/// A single entry of [AppSideBottomNavBar].
class SideNavItem {
  final IconData icon;
  final String label;

  const SideNavItem(this.icon, this.label);
}

/// Floating vertical navigation rail pinned to the bottom-left corner.
///
/// Items render collapsed at 48x48 and expand to 150 wide on hover (desktop)
/// or while selected (touch), revealing the item label.
class AppSideBottomNavBar extends StatefulWidget {
  const AppSideBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.items,
    this.onTap,
  });

  final int currentIndex;
  final List<SideNavItem> items;
  final ValueChanged<int>? onTap;

  @override
  State<AppSideBottomNavBar> createState() => _AppSideBottomNavBarState();
}

class _AppSideBottomNavBarState extends State<AppSideBottomNavBar> {
  static const double _collapsedSize = 48;
  static const double _expandedWidth = 150;
  static const double _gap = 8;
  static const double _padding = 8;
  static const Color _barColor = Color(0xFF222222);
  static const Color _itemColor = Color(0xFF444444);

  int? _hoveredIndex;

  bool _isExpanded(int index) =>
      _hoveredIndex == index || widget.currentIndex == index;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(_padding),
      decoration: const BoxDecoration(
        color: _barColor,
        borderRadius: BorderRadius.only(topRight: Radius.circular(8)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < widget.items.length; i++) ...[
            if (i > 0) const SizedBox(height: _gap),
            _buildItem(i),
          ],
        ],
      ),
    );
  }

  Widget _buildItem(int index) {
    final SideNavItem item = widget.items[index];
    final bool isSelected = widget.currentIndex == index;
    final bool isExpanded = _isExpanded(index);

    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredIndex = index),
      onExit: (_) => setState(() => _hoveredIndex = null),
      child: GestureDetector(
        onTap: widget.onTap == null ? null : () => widget.onTap!(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease,
          width: isExpanded ? _expandedWidth : _collapsedSize,
          height: _collapsedSize,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.teal : _itemColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment:
                isExpanded ? MainAxisAlignment.start : MainAxisAlignment.center,
            children: [
              Icon(item.icon, color: Colors.white, size: 22),
              if (isExpanded) ...[
                const SizedBox(width: _gap),
                Flexible(
                  child: Text(
                    item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      height: 1.0,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}