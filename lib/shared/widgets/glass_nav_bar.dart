import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

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
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 18),
      height: 66,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(36),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 40,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(36),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            decoration: BoxDecoration(
              // ✅ fondo oscuro como en el HTML: rgba(15,34,36,.88)
              color: const Color(0xFF0F2224).withValues(alpha: 0.88),
              borderRadius: BorderRadius.circular(36),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.08),
                width: 1,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _NavItem(icon: Icons.home_outlined, iconSelected: Icons.home, label: 'Inicio', isSelected: widget.currentIndex == 0, onTap: () => widget.onTap(0)),
                _NavItem(icon: Icons.search_outlined, iconSelected: Icons.search, label: 'Buscar', isSelected: widget.currentIndex == 1, onTap: () => widget.onTap(1)),
                _NavItem(icon: Icons.map_outlined, iconSelected: Icons.map, label: 'Mapa', isSelected: widget.currentIndex == 2, onTap: () => widget.onTap(2)),
                _NavItem(icon: Icons.person_outline, iconSelected: Icons.person, label: 'Perfil', isSelected: widget.currentIndex == 3, onTap: () => widget.onTap(3)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.iconSelected,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final IconData iconSelected;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 60,
        height: 50,
        decoration: BoxDecoration(
          // ✅ fondo teal semitransparente en el activo como en el HTML
          color: isSelected
              ? const Color(0xFF35858E).withValues(alpha: 0.30)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? iconSelected : icon,
              // ✅ amarillo/dorado en activo, blanco tenue en inactivo
              color: isSelected
                  ? TmColors.accent
                  : Colors.white.withValues(alpha: 0.35),
              size: 20,
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 9,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? TmColors.accent
                    : Colors.white.withValues(alpha: 0.30),
                fontFamily: 'Sora',
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}