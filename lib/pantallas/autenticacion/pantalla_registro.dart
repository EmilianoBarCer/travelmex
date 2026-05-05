import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../proveedores/proveedor_autenticacion.dart';

class PantallaRegistro extends StatefulWidget {
  const PantallaRegistro({Key? key}) : super(key: key);

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

  @override
  void dispose() {
    controladorNombre.dispose();
    controladorCorreo.dispose();
    controladorContrasena.dispose();
    controladorConfirmarContrasena.dispose();
    super.dispose();
  }

  void _registrarse(BuildContext context) async {
    final nombre = controladorNombre.text.trim();
    final correo = controladorCorreo.text.trim();
    final contrasena = controladorContrasena.text.trim();
    final confirmarContrasena = controladorConfirmarContrasena.text.trim();

    // Validaciones
    if (nombre.isEmpty || correo.isEmpty || contrasena.isEmpty) {
      _mostrarError('Por favor completa todos los campos');
      return;
    }

    if (contrasena.length < 6) {
      _mostrarError('La contraseña debe tener al menos 6 caracteres');
      return;
    }

    if (contrasena != confirmarContrasena) {
      _mostrarError('Las contraseñas no coinciden');
      return;
    }

    if (!aceptaTerminos) {
      _mostrarError('Debes aceptar los términos y condiciones');
      return;
    }

    final proveedor = context.read<ProveedorAutenticacion>();
    final exitoso = await proveedor.registrarse(
      correo: correo,
      contrasena: contrasena,
      nombre: nombre,
    );

    if (exitoso) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Bienvenido a TravelMex!'),
          duration: Duration(seconds: 2),
        ),
      );
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context).pushReplacementNamed('/inicio');
      });
    } else {
      if (!mounted) return;
      _mostrarError(proveedor.error ?? 'Error al registrarse');
    }
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Cuenta'),
        elevation: 0,
      ),
      body: Consumer<ProveedorAutenticacion>(
        builder: (context, proveedor, child) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Icon(
                    Icons.person_add,
                    size: 60,
                    color: Colors.blue.shade700,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Únete a nuestra comunidad',
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    controller: controladorNombre,
                    decoration: InputDecoration(
                      hintText: 'Nombre completo',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    enabled: !proveedor.cargando,
                  ),
                  const SizedBox(height: 16),
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
                      hintText: 'Contraseña (mín. 6 caracteres)',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(mostrarContrasena
                            ? Icons.visibility
                            : Icons.visibility_off),
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
                  const SizedBox(height: 16),
                  TextField(
                    controller: controladorConfirmarContrasena,
                    decoration: InputDecoration(
                      hintText: 'Confirmar contraseña',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(mostrarConfirmar
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            mostrarConfirmar = !mostrarConfirmar;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    obscureText: !mostrarConfirmar,
                    enabled: !proveedor.cargando,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Checkbox(
                        value: aceptaTerminos,
                        onChanged: proveedor.cargando
                            ? null
                            : (valor) {
                                setState(() {
                                  aceptaTerminos = valor ?? false;
                                });
                              },
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              aceptaTerminos = !aceptaTerminos;
                            });
                          },
                          child: Text(
                            'Acepto los términos y condiciones',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: proveedor.cargando
                          ? null
                          : () => _registrarse(context),
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
                              'Registrarse',
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
                      const Text('¿Ya tienes cuenta? '),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pushNamed('/login'),
                        child: Text(
                          'Inicia sesión',
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
