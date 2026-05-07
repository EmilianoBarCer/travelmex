import 'package:flutter/material.dart';
import '../../lobby/auth_provider.dart';

class ConfigInProfile extends StatelessWidget {
  final AuthProvider auth;
  const ConfigInProfile({super.key, required this.auth});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40, height: 4,
            margin: const EdgeInsets.only(top: 14, bottom: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFD4E8CE),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Título
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
            child: Row(
              children: [
                const Text(
                  'Mi cuenta',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1C2E30)),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 30, height: 30,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF5E8),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(Icons.close, size: 14, color: Color(0xFFF5C554)),
                  ),
                ),
              ],
            ),
          ),

          // Items
          _itemMenu(
            context,
            emoji: '👤',
            color: const Color(0x1F35858E),
            titulo: 'Editar perfil',
            subtitulo: 'Foto, nombre, biografía',
            onTap: () {
              Navigator.pop(context);
              // TODO: navegar a edit_profile_screen.dart
            },
          ),
          _itemMenu(
            context,
            emoji: '🔔',
            color: const Color(0x267DA78C),
            titulo: 'Notificaciones',
            subtitulo: 'Alertas y avisos',
            onTap: () {
              Navigator.pop(context);
              // TODO: navegar a notifications_screen.dart
            },
          ),
          _itemMenu(
            context,
            emoji: '🔒',
            color: const Color(0x4DC2D099),
            titulo: 'Privacidad y seguridad',
            subtitulo: 'Contraseña, sesiones activas',
            onTap: () {
              Navigator.pop(context);
              // TODO: navegar a privacy_screen.dart
            },
          ),
          _itemMenu(
            context,
            emoji: '🌐',
            color: const Color(0x1F35858E),
            titulo: 'Idioma',
            subtitulo: 'Español (México)',
            onTap: () {
              Navigator.pop(context);
              // TODO: navegar a language_screen.dart
            },
          ),

          const Divider(height: 1, indent: 22, endIndent: 22),

          // Cerrar sesión ── FUNCIONA
          _itemMenu(
            context,
            emoji: '🚪',
            color: const Color(0x1AE53E3E),
            titulo: 'Cerrar sesión',
            subtitulo: 'Salir de tu cuenta',
            tituloColor: const Color(0xFF975BB0),
            onTap: () async {
              Navigator.pop(context);
              await auth.signOut();
              if (context.mounted) {
                Navigator.of(context).pushReplacementNamed('/login');
              }
            },
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _itemMenu(
      BuildContext context, {
        required String emoji,
        required Color color,
        required String titulo,
        required String subtitulo,
        required VoidCallback onTap,
        Color tituloColor = const Color(0xFF1C2E30),
      }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
        child: Row(
          children: [
            Container(
              width: 38, height: 38,
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
              child: Center(child: Text(emoji, style: const TextStyle(fontSize: 18))),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titulo, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: tituloColor)),
                  const SizedBox(height: 1),
                  Text(subtitulo, style: const TextStyle(fontSize: 12, color: Color(0xFFF5C554))),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFFF5C554), size: 18),
          ],
        ),
      ),
    );
  }
}