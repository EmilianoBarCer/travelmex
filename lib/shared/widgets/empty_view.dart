import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

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