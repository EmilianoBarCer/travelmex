import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../lobby/auth_provider.dart';
import '../core/services/supabase_service.dart';
import '../core/theme/app_theme.dart';
import '../shared/models/review.dart';
import '../shared/widgets/config_in_profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _tabActiva = 0;
  Future<List<Review>>? _reviewsFuture;

  void _cargarResenas(String userId) {
    _reviewsFuture ??= SupabaseService.instance.fetchReviewsByUser(userId);
  }

  void _abrirMenuAjustes(BuildContext context) {
    final auth = context.read<AuthProvider>();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => ConfigInProfile(auth: auth),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    if (authProvider.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (authProvider.profile == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.person_off, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              const Text('No hay sesión activa'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pushNamed('/login'),
                style: ElevatedButton.styleFrom(backgroundColor: TmColors.primary),
                child: const Text('Iniciar sesión', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      );
    }

    final profile = authProvider.profile!;
    _cargarResenas(profile.id);

    final iniciales = (profile.name ?? profile.email ?? 'U')
        .split(' ')
        .take(2)
        .map((e) => e.isNotEmpty ? e[0].toUpperCase() : '')
        .join();

    return Scaffold(
      backgroundColor: TmColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Encabezado ──
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [TmColors.primaryDark, TmColors.primary],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(38),
                  bottomRight: Radius.circular(38),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(22, 56, 22, 28),
              child: Column(
                children: [
                  // Botón settings
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () => _abrirMenuAjustes(context),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.settings_outlined, color: Colors.white, size: 17),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Avatar
                  Container(
                    width: 86,
                    height: 86,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: TmColors.accent,
                      border: Border.all(color: Colors.white.withValues(alpha: 0.28), width: 4),
                      image: profile.avatarUrl != null
                          ? DecorationImage(
                        image: NetworkImage(profile.avatarUrl!),
                        fit: BoxFit.cover,
                      )
                          : null,
                    ),
                    child: profile.avatarUrl == null
                        ? Center(
                      child: Text(
                        iniciales,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          color: TmColors.primaryDark,
                        ),
                      ),
                    )
                        : null,
                  ),
                  const SizedBox(height: 10),

                  // Nombre
                  Text(
                    profile.name ?? profile.email.split('@')[0],
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 3),

                  // Bio ✅ desde BD
                  Text(
                    profile.bio ?? 'Sin biografía',
                    style: const TextStyle(fontSize: 13, color: Color(0x99FFFFFF)),
                  ),
                  const SizedBox(height: 4),

                  // Ubicación ✅ desde BD
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('📍', style: TextStyle(fontSize: 12)),
                      const SizedBox(width: 4),
                      Text(
                        profile.location ?? 'Sin ubicación',
                        style: const TextStyle(fontSize: 12, color: TmColors.accent),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Stats ✅ reseñas dinámicas
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.07),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        // Reseñas — conteo real
                        FutureBuilder<List<Review>>(
                          future: _reviewsFuture,
                          builder: (context, snapshot) {
                            final count = snapshot.data?.length ?? 0;
                            final valor = snapshot.connectionState == ConnectionState.done
                                ? '$count'
                                : '...';
                            return _statItem(valor, 'Reseñas', false);
                          },
                        ),
                        _statItem('38', 'Favoritos', true),  // TODO: conectar
                        _statItem('27', 'Visitas', true),    // TODO: conectar
                        _statItem('4.8', 'Calificación', true), // TODO: conectar
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Body ──
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 18, 22, 40),
              child: Column(
                children: [
                  // Tabs
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      children: [
                        _tabItem(0, 'Mis reseñas'),
                        _tabItem(1, 'Favoritos'),
                        _tabItem(2, 'Visitas'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  if (_tabActiva == 0)
                    FutureBuilder<List<Review>>(
                      future: _reviewsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return _mensajeVacio('❌', 'Error al cargar reseñas', snapshot.error.toString());
                        }
                        final reviews = snapshot.data ?? [];
                        if (reviews.isEmpty) {
                          return _mensajeVacio('⭐', 'Sin reseñas todavía', 'Tus reseñas aparecerán aquí');
                        }
                        return Column(
                          children: reviews.map((r) => _reviewTile(r)).toList(),
                        );
                      },
                    ),

                  if (_tabActiva == 1)
                    _mensajeVacio('❤️', 'Sin favoritos todavía', 'Guarda lugares que te gusten'),

                  if (_tabActiva == 2)
                    _mensajeVacio('🗺️', 'Sin visitas registradas', 'Marca los lugares que has visitado'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statItem(String value, String label, bool hasBorder) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: hasBorder
              ? const Border(left: BorderSide(color: Color(0x14FFFFFF), width: 1))
              : null,
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        child: Column(
          children: [
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
            const SizedBox(height: 1),
            Text(label, style: const TextStyle(fontSize: 10, color: Color(0x73FFFFFF)), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _tabItem(int index, String label) {
    final activa = _tabActiva == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _tabActiva = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: activa ? TmColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: activa ? Colors.white : TmColors.grey500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _reviewTile(Review review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: TmColors.accent.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(child: Text('⭐', style: TextStyle(fontSize: 18))),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Muestra nombre del destino si existe, si no el ID
                Text(
                  review.destinationName ?? review.destinationId,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1C2E30)),
                ),
                const SizedBox(height: 1),
                Text(
                  '${'★' * review.rating}${'☆' * (5 - review.rating)} · ${_formatDate(review.createdAt)}',
                  style: const TextStyle(fontSize: 12, color: TmColors.grey500),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: TmColors.grey500),
        ],
      ),
    );
  }

  Widget _mensajeVacio(String emoji, String titulo, String subtitulo) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 40)),
          const SizedBox(height: 12),
          Text(titulo, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1C2E30))),
          const SizedBox(height: 4),
          Text(subtitulo, style: const TextStyle(fontSize: 13, color: TmColors.grey500), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final diff = DateTime.now().difference(date);
    if (diff.inDays == 0) return 'Hoy';
    if (diff.inDays == 1) return 'Ayer';
    if (diff.inDays < 7) return 'Hace ${diff.inDays} días';
    if (diff.inDays < 30) return 'Hace ${(diff.inDays / 7).round()} semanas';
    if (diff.inDays < 365) return 'Hace ${(diff.inDays / 30).round()} meses';
    return 'Hace ${(diff.inDays / 365).round()} años';
  }
}