import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth_provider.dart';

class PantallaLogin extends StatefulWidget {
  const PantallaLogin({super.key});

  @override
  State<PantallaLogin> createState() => _PantallaLoginState();
}

class _PantallaLoginState extends State<PantallaLogin> {
  final controladorCorreo = TextEditingController();
  final controladorContrasena = TextEditingController();
  bool mostrarContrasena = false;

  static const Color primario    = Color(0xFFC62300);
  static const Color primarioDark = Color(0xFF8D1B02);
  static const Color acento1     = Color(0xFFFAD017);
  static const Color acento2     = Color(0xFFDFC2F8);
  static const Color borde       = Color(0xFFD4E8CE);
  static const Color texto       = Color(0xFF1C2E30);
  static const Color muted       = Color(0xFFF5C554);

  @override
  void dispose() {
    controladorCorreo.dispose();
    controladorContrasena.dispose();
    super.dispose();
  }

  void _iniciarSesion(BuildContext context) async {
    final correo = controladorCorreo.text.trim();
    final contrasena = controladorContrasena.text.trim();

    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    if (correo.isEmpty || contrasena.isEmpty) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos')),
      );
      return;
    }

    final auth = context.read<AuthProvider>(); // ✅
    final exitoso = await auth.signIn(         // ✅ iniciarSesion → signIn
      email: correo,                           // ✅ correo → email
      password: contrasena,                    // ✅ contrasena → password
    );

    if (exitoso) {
      if (!mounted) return;
      navigator.pushReplacementNamed('/inicio');
    } else {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text(auth.error ?? 'Error al iniciar sesión')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<AuthProvider>( // ✅
        builder: (context, auth, child) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Encabezado gradiente
                Container(
                  height: 250,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [primarioDark, primario],
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                          children: [
                            TextSpan(text: 'Travel'),
                            TextSpan(
                              text: 'Mex',
                              style: TextStyle(color: acento1),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Descubre y comparte destinos increíbles',
                        style: TextStyle(fontSize: 13, color: Color(0x8CFFFFFF)),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),

                // Formulario
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Bienvenido de nuevo',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: texto),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Inicia sesión para continuar',
                        style: TextStyle(fontSize: 13, color: muted),
                      ),
                      const SizedBox(height: 24),

                      const Text(
                        'CORREO ELECTRÓNICO',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: texto, letterSpacing: 0.5),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: controladorCorreo,
                        enabled: !auth.isLoading, // ✅
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(fontSize: 14, color: texto),
                        decoration: InputDecoration(
                          hintText: 'correo@ejemplo.com',
                          filled: true,
                          fillColor: acento2,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: borde, width: 1.5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: borde, width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: primario, width: 1.5),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                      ),
                      const SizedBox(height: 14),

                      const Text(
                        'CONTRASEÑA',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: texto, letterSpacing: 0.5),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: controladorContrasena,
                        enabled: !auth.isLoading, // ✅
                        obscureText: !mostrarContrasena,
                        style: const TextStyle(fontSize: 14, color: texto),
                        decoration: InputDecoration(
                          hintText: '••••••••',
                          filled: true,
                          fillColor: acento2,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: borde, width: 1.5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: borde, width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: primario, width: 1.5),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          suffixIcon: IconButton(
                            icon: Icon(
                              mostrarContrasena ? Icons.visibility : Icons.visibility_off,
                              color: texto,
                            ),
                            onPressed: () => setState(() => mostrarContrasena = !mostrarContrasena),
                          ),
                        ),
                      ),

                      // Olvidé contraseña
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            '¿Olvidaste tu contraseña?',
                            style: TextStyle(fontSize: 12, color: primario, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Botón
                      SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          onPressed: auth.isLoading // ✅
                              ? null
                              : () => _iniciarSesion(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primario,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: auth.isLoading // ✅
                              ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                              : const Text(
                            'Iniciar sesión',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),

                      // Divider
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 18),
                        child: Row(
                          children: [
                            Expanded(child: Divider(color: borde, thickness: 1)),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Text('o', style: TextStyle(fontSize: 12, color: muted)),
                            ),
                            Expanded(child: Divider(color: borde, thickness: 1)),
                          ],
                        ),
                      ),

                      // Registro
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('¿No tienes cuenta? ', style: TextStyle(fontSize: 13, color: muted)),
                          GestureDetector(
                            onTap: () => Navigator.of(context).pushNamed('/registrarse'),
                            child: const Text(
                              'Regístrate',
                              style: TextStyle(fontSize: 13, color: primario, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}