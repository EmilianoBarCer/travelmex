import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

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
