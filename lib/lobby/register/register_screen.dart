import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth_provider.dart'; // ✅

class PantallaRegistro extends StatefulWidget {
  const PantallaRegistro({super.key});

  @override
  State<PantallaRegistro> createState() => _PantallaRegistroState();
}

class _PantallaRegistroState extends State<PantallaRegistro> {
  final controladorNombre = TextEditingController();
  final controladorCorreo = TextEditingController();
  final controladorContrasena = TextEditingController();
  final controladorConfirmarContrasena = TextEditingController();
  bool mostrarContrasena = false;
  bool mostrarConfirmar = false;
  bool aceptaTerminos = false;

  static const Color primario    = Color(0xFFC62300);
  static const Color primarioDark = Color(0xFF8D1B02);
  static const Color acento1     = Color(0xFFFAD017);
  static const Color acento2     = Color(0xFFDFC2F8);
  static const Color borde       = Color(0xFFD4E8CE);
  static const Color texto       = Color(0xFF1C2E30);
  static const Color muted       = Color(0xFFF5C554);

  @override
  void dispose() {
    controladorNombre.dispose();
    controladorCorreo.dispose();
    controladorContrasena.dispose();
    controladorConfirmarContrasena.dispose();
    super.dispose();
  }

  Future<void> _registrarse(BuildContext context) async {
    final nombre = controladorNombre.text.trim();
    final correo = controladorCorreo.text.trim();
    final contrasena = controladorContrasena.text.trim();
    final confirmar = controladorConfirmarContrasena.text.trim();

    if (nombre.isEmpty || correo.isEmpty || contrasena.isEmpty) {
      _mostrarError('Por favor completa todos los campos');
      return;
    }
    if (contrasena.length < 6) {
      _mostrarError('La contraseña debe tener al menos 6 caracteres');
      return;
    }
    if (contrasena != confirmar) {
      _mostrarError('Las contraseñas no coinciden');
      return;
    }
    if (!aceptaTerminos) {
      _mostrarError('Debes aceptar los términos y condiciones');
      return;
    }

    final auth = context.read<AuthProvider>(); // ✅

    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final exitoso = await auth.signUp( // ✅ registrarse → signUp
      email: correo,                   // ✅ correo → email
      password: contrasena,            // ✅ contrasena → password
      name: nombre,                    // ✅ nombre → name
    );

    if (exitoso) {
      if (!mounted) return;
      messenger.showSnackBar(
        const SnackBar(content: Text('¡Bienvenido a TravelMex!')),
      );
      Future.delayed(const Duration(seconds: 2), () {
        navigator.pushReplacementNamed('/inicio');
      });
    } else {
      if (!mounted) return;
      _mostrarError(auth.error ?? 'Error al registrarse'); // ✅
    }
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
  }

  InputDecoration _decoracionCampo(String hint) {
    return InputDecoration(
      hintText: hint,
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
    );
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
                // Encabezado
                Container(
                  height: 220,
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
                        'Únete a nuestra comunidad',
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
                        'Crea tu cuenta',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: texto),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Regístrate para guardar tus viajes y reseñas',
                        style: TextStyle(fontSize: 13, color: muted),
                      ),
                      const SizedBox(height: 24),

                      const Text('NOMBRE COMPLETO', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: texto, letterSpacing: 0.5)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: controladorNombre,
                        enabled: !auth.isLoading, // ✅
                        style: const TextStyle(fontSize: 14, color: texto),
                        decoration: _decoracionCampo('Tu nombre'),
                      ),
                      const SizedBox(height: 14),

                      const Text('CORREO ELECTRÓNICO', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: texto, letterSpacing: 0.5)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: controladorCorreo,
                        enabled: !auth.isLoading, // ✅
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(fontSize: 14, color: texto),
                        decoration: _decoracionCampo('correo@ejemplo.com'),
                      ),
                      const SizedBox(height: 14),

                      const Text('CONTRASEÑA', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: texto, letterSpacing: 0.5)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: controladorContrasena,
                        enabled: !auth.isLoading, // ✅
                        obscureText: !mostrarContrasena,
                        style: const TextStyle(fontSize: 14, color: texto),
                        decoration: _decoracionCampo('Mín. 6 caracteres').copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(mostrarContrasena ? Icons.visibility : Icons.visibility_off, color: texto),
                            onPressed: () => setState(() => mostrarContrasena = !mostrarContrasena),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      const Text('CONFIRMAR CONTRASEÑA', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: texto, letterSpacing: 0.5)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: controladorConfirmarContrasena,
                        enabled: !auth.isLoading, // ✅
                        obscureText: !mostrarConfirmar,
                        style: const TextStyle(fontSize: 14, color: texto),
                        decoration: _decoracionCampo('Repite tu contraseña').copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(mostrarConfirmar ? Icons.visibility : Icons.visibility_off, color: texto),
                            onPressed: () => setState(() => mostrarConfirmar = !mostrarConfirmar),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Términos
                      Row(
                        children: [
                          Checkbox(
                            value: aceptaTerminos,
                            activeColor: primario,
                            onChanged: auth.isLoading // ✅
                                ? null
                                : (val) => setState(() => aceptaTerminos = val ?? false),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => aceptaTerminos = !aceptaTerminos),
                              child: const Text(
                                'Acepto los términos y condiciones',
                                style: TextStyle(fontSize: 13, color: texto),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Botón
                      SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          onPressed: auth.isLoading // ✅
                              ? null
                              : () => _registrarse(context),
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
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                              : const Text(
                            'Registrarse',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Login
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('¿Ya tienes cuenta? ', style: TextStyle(fontSize: 13, color: muted)),
                          GestureDetector(
                            onTap: () => Navigator.of(context).pushNamed('/login'),
                            child: const Text(
                              'Inicia sesión',
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