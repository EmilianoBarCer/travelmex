import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/review.dart';
import '../theme/app_theme.dart';

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

/// ⭐ ReviewCard
/// Card widget for displaying individual reviews
class ReviewCard extends StatelessWidget {
  const ReviewCard({
    super.key,
    required this.review,
  });

  final Review review;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: TmColors.white,
        borderRadius: BorderRadius.circular(TmRadius.lg),
        boxShadow: [TmShadows.card],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: TmColors.grey100,
                backgroundImage: review.userAvatar != null ? NetworkImage(review.userAvatar!) : null,
                child: review.userAvatar == null
                    ? const Icon(Icons.person, color: TmColors.grey500)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName ?? 'Usuario',
                      style: TmTheme.light.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < review.rating ? Icons.star : Icons.star_border,
                          color: TmColors.accent,
                          size: 16,
                        );
                      }),
                    ),
                  ],
                ),
              ),
              Text(
                _formatDate(review.createdAt),
                style: TmTheme.light.textTheme.bodySmall?.copyWith(
                  color: TmColors.grey500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Text(
            review.comment,
            style: TmTheme.light.textTheme.bodyMedium?.copyWith(
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Hoy';
    } else if (difference.inDays == 1) {
      return 'Ayer';
    } else if (difference.inDays < 7) {
      return 'Hace ${difference.inDays} días';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

/// 🔄 ShimmerLoading
/// Shimmer effect for loading states
class ShimmerLoading extends StatefulWidget {
  const ShimmerLoading({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1500),
  });

  final Widget child;
  final Duration duration;

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();

    _animation = Tween<double>(begin: -1.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: const [
                TmColors.grey100,
                TmColors.grey200,
                TmColors.grey100,
              ],
              stops: [
                0.0,
                _animation.value * 0.5 + 0.5,
                1.0,
              ],
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

/// 📦 ShimmerCard
/// Pre-built shimmer card for loading destinations
class ShimmerCard extends StatelessWidget {
  const ShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Container(
        width: 280,
        height: 200,
        decoration: BoxDecoration(
          color: TmColors.white,
          borderRadius: BorderRadius.circular(TmRadius.lg),
        ),
      ),
    );
  }
}

/// 🎯 ErrorView
/// Error state widget with retry option
class ErrorView extends StatelessWidget {
  const ErrorView({
    super.key,
    required this.error,
    required this.onRetry,
    this.title = 'Oops! Algo salió mal',
  });

  final String error;
  final VoidCallback onRetry;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: TmColors.error,
            ),

            const SizedBox(height: 16),

            Text(
              title,
              style: TmTheme.light.textTheme.headlineSmall?.copyWith(
                color: TmColors.grey900,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            Text(
              error,
              style: TmTheme.light.textTheme.bodyMedium?.copyWith(
                color: TmColors.grey600,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}

/// 📭 EmptyView
/// Empty state widget
class EmptyView extends StatelessWidget {
  const EmptyView({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: TmColors.grey400,
            ),

            const SizedBox(height: 16),

            Text(
              title,
              style: TmTheme.light.textTheme.headlineSmall?.copyWith(
                color: TmColors.grey700,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            Text(
              subtitle,
              style: TmTheme.light.textTheme.bodyMedium?.copyWith(
                color: TmColors.grey500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}