import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/review.dart';
import '../providers/auth_provider.dart';
import '../services/supabase_service.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<List<Review>>? _reviewsFuture;

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    if (_reviewsFuture == null && authProvider.profile != null) {
      _reviewsFuture = SupabaseService.instance.fetchReviewsByUser(authProvider.profile!.id);
    }

    return Scaffold(
      backgroundColor: TmColors.grey100,
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        actions: [
          IconButton(
            onPressed: authProvider.isLoading ? null : () => authProvider.signOut(),
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
      body: authProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : authProvider.profile == null
              ? const Center(child: Text('No se encontró el perfil.'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: TmColors.white,
                          borderRadius: BorderRadius.circular(TmRadius.xl),
                          boxShadow: [TmShadows.elevated],
                        ),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 54,
                              backgroundColor: TmColors.grey100,
                              backgroundImage: authProvider.profile?.avatarUrl != null
                                  ? NetworkImage(authProvider.profile!.avatarUrl!)
                                  : null,
                              child: authProvider.profile?.avatarUrl == null
                                  ? const Icon(Icons.person, size: 52, color: TmColors.grey500)
                                  : null,
                            ),
                            const SizedBox(height: 18),
                            Text(
                              authProvider.profile?.name ?? authProvider.profile?.email ?? 'Usuario',
                              style: TmTheme.light.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              authProvider.profile?.email ?? '',
                              style: TmTheme.light.textTheme.bodyLarge?.copyWith(
                                color: TmColors.grey600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () => _showEditProfileDialog(context, authProvider),
                                  child: const Text('Editar perfil'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Tus reseñas',
                        style: TmTheme.light.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      FutureBuilder<List<Review>>(
                        future: _reviewsFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          if (snapshot.hasError) {
                            return ErrorView(
                              error: snapshot.error.toString(),
                              onRetry: () {
                                setState(() {
                                  _reviewsFuture = SupabaseService.instance.fetchReviewsByUser(authProvider.profile!.id);
                                });
                              },
                            );
                          }

                          final reviews = snapshot.data ?? [];

                          if (reviews.isEmpty) {
                            return const EmptyView(
                              icon: Icons.rate_review,
                              title: 'Aún no has dejado reseñas',
                              subtitle: 'Cuando publiques una reseña aparecerá aquí.',
                            );
                          }

                          return Column(
                            children: reviews.map((review) => ReviewCard(review: review)).toList(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
    );
  }

  void _showEditProfileDialog(BuildContext context, AuthProvider authProvider) {
    final nameController = TextEditingController(text: authProvider.profile?.name ?? '');
    final avatarController = TextEditingController(text: authProvider.profile?.avatarUrl ?? '');

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar perfil'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: avatarController,
                decoration: const InputDecoration(labelText: 'URL de avatar'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                final success = await authProvider.updateProfile(
                  name: nameController.text.trim().isEmpty ? null : nameController.text.trim(),
                  avatarUrl: avatarController.text.trim().isEmpty ? null : avatarController.text.trim(),
                );
                if (!context.mounted) return;
                if (success) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }
}
