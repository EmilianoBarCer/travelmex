import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../proveedores/proveedor_autenticacion.dart';

class PantallaLogin extends StatefulWidget {
  const PantallaLogin({Key? key}) : super(key: key);

  @override
  State<PantallaLogin> createState() => _PantallaLoginState();
}

class _PantallaLoginState extends State<PantallaLogin> {
  final controladorCorreo = TextEditingController();
  final controladorContrasena = TextEditingController();
  bool mostrarContrasena = false;

  @override
  void dispose() {
    controladorCorreo.dispose();
    controladorContrasena.dispose();
    super.dispose();
  }

  void _iniciarSesion(BuildContext context) async {
    final correo = controladorCorreo.text.trim();
    final contrasena = controladorContrasena.text.trim();

    if (correo.isEmpty || contrasena.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos')),
      );
      return;
    }

    final proveedor = context.read<ProveedorAutenticacion>();
    final exitoso = await proveedor.iniciarSesion(
      correo: correo,
      contrasena: contrasena,
    );

    if (exitoso) {
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/inicio');
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(proveedor.error ?? 'Error al iniciar sesión')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ProveedorAutenticacion>(
        builder: (context, proveedor, child) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  Icon(
                    Icons.public,
                    size: 80,
                    color: Colors.blue.shade700,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'TravelMex',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Descubre y comparte destinos increíbles',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 50),
                  TextField(
                    controller: controladorCorreo,
                    decoration: InputDecoration(
                      hintText: 'Correo electrónico',
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    enabled: !proveedor.cargando,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: controladorContrasena,
                    decoration: InputDecoration(
                      hintText: 'Contraseña',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          mostrarContrasena
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            mostrarContrasena = !mostrarContrasena;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    obscureText: !mostrarContrasena,
                    enabled: !proveedor.cargando,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed:
                          proveedor.cargando ? null : () => _iniciarSesion(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: proveedor.cargando
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'Iniciar sesión',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('¿No tienes cuenta? '),
                      GestureDetector(
                        onTap: () =>
                            Navigator.of(context).pushNamed('/registrarse'),
                        child: Text(
                          'Regístrate aquí',
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
