import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// 🧭 GlassBottomNavBar
/// Floating glassmorphism bottom navigation bar
class GlassBottomNavBar extends StatefulWidget {
  const GlassBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  State<GlassBottomNavBar> createState() => _GlassBottomNavBarState();
}

class _GlassBottomNavBarState extends State<GlassBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      height: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(TmRadius.xl),
        boxShadow: [TmShadows.elevated],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(TmRadius.xl),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: TmColors.white.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(TmRadius.xl),
              border: Border(
                top: BorderSide(
                  color: TmColors.white.withValues(alpha: 0.4),
                  width: 1.5,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _NavBarItem(
                  icon: Icons.home,
                  label: 'Inicio',
                  isSelected: widget.currentIndex == 0,
                  onTap: () => widget.onTap(0),
                ),
                _NavBarItem(
                  icon: Icons.search,
                  label: 'Buscar',
                  isSelected: widget.currentIndex == 1,
                  onTap: () => widget.onTap(1),
                ),
                _NavBarItem(
                  icon: Icons.map,
                  label: 'Mapa',
                  isSelected: widget.currentIndex == 2,
                  onTap: () => widget.onTap(2),
                ),
                _NavBarItem(
                  icon: Icons.person,
                  label: 'Perfil',
                  isSelected: widget.currentIndex == 3,
                  onTap: () => widget.onTap(3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 🧭 NavBarItem
/// Individual navigation item with animations
class _NavBarItem extends StatelessWidget {
  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon with animation
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isSelected ? TmColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isSelected ? TmColors.white : TmColors.grey500,
                size: 20,
              ),
            ),

            const SizedBox(height: 4),

            // Label with animation
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TmTheme.light.textTheme.labelSmall!.copyWith(
                color: isSelected ? TmColors.primary : TmColors.grey500,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}
