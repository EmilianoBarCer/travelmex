import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../proveedores/proveedor_autenticacion.dart';

class PantallaPerfil extends StatefulWidget {
  const PantallaPerfil({Key? key}) : super(key: key);

  @override
  State<PantallaPerfil> createState() => _PantallaPerfilState();
}

class _PantallaPerfilState extends State<PantallaPerfil> {
  late TextEditingController controladorNombre;
  late TextEditingController controladorBio;
  late TextEditingController controladorTelefono;
  bool enEdicion = false;
  bool guardando = false;

  @override
  void initState() {
    super.initState();
    _inicializarControladores();
  }

  void _inicializarControladores() {
    final usuario = context.read<ProveedorAutenticacion>().usuario;
    controladorNombre = TextEditingController(text: usuario?.nombre ?? '');
    controladorBio = TextEditingController(text: usuario?.bio ?? '');
    controladorTelefono = TextEditingController(text: usuario?.telefono ?? '');
  }

  @override
  void dispose() {
    controladorNombre.dispose();
    controladorBio.dispose();
    controladorTelefono.dispose();
    super.dispose();
  }

  Future<void> _guardarCambios() async {
    setState(() => guardando = true);

    final proveedor = context.read<ProveedorAutenticacion>();
    final exitoso = await proveedor.actualizarPerfil(
      nombre: controladorNombre.text.trim(),
      bio: controladorBio.text.trim(),
      telefono: controladorTelefono.text.trim(),
    );

    if (exitoso) {
      setState(() {
        enEdicion = false;
        guardando = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil actualizado exitosamente')),
      );
    } else {
      setState(() => guardando = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(proveedor.error ?? 'Error al guardar')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        actions: [
          if (enEdicion)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: guardando
                    ? null
                    : () {
                        _guardarCambios();
                      },
                child: guardando
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Guardar'),
              ),
            ),
        ],
      ),
      body: Consumer<ProveedorAutenticacion>(
        builder: (context, proveedor, child) {
          final usuario = proveedor.usuario;

          if (usuario == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.person_off, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('No hay sesión activa'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pushNamed('/login'),
                    child: const Text('Iniciar sesión'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                // Avatar Section
                Container(
                  color: Colors.blue.shade100,
                  padding: const EdgeInsets.all(24),
                  width: double.infinity,
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: usuario.avatarUrl != null
                            ? NetworkImage(usuario.avatarUrl!)
                            : null,
                        child: usuario.avatarUrl == null
                            ? const Icon(Icons.person, size: 50)
                            : null,
                      ),
                      const SizedBox(height: 16),
                      if (!enEdicion)
                        Column(
                          children: [
                            Text(
                              usuario.nombre ?? 'Usuario',
                              style:
                                  Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              usuario.email,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Edit Button
                      if (!enEdicion)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              setState(() => enEdicion = true);
                            },
                            icon: const Icon(Icons.edit),
                            label: const Text('Editar perfil'),
                          ),
                        )
                      else
                        // Edit Form
                        Column(
                          children: [
                            TextField(
                              controller: controladorNombre,
                              decoration: InputDecoration(
                                labelText: 'Nombre',
                                prefixIcon: const Icon(Icons.person),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              enabled: !guardando,
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: controladorBio,
                              decoration: InputDecoration(
                                labelText: 'Bio',
                                prefixIcon: const Icon(Icons.description),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              maxLines: 3,
                              enabled: !guardando,
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: controladorTelefono,
                              decoration: InputDecoration(
                                labelText: 'Teléfono',
                                prefixIcon: const Icon(Icons.phone),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              enabled: !guardando,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: guardando
                                        ? null
                                        : () {
                                            _inicializarControladores();
                                            setState(() => enEdicion = false);
                                          },
                                    child: const Text('Cancelar'),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed:
                                        guardando ? null : _guardarCambios,
                                    child: const Text('Guardar'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 16),
                      // Information Section
                      ListTile(
                        title: const Text('Email'),
                        subtitle: Text(usuario.email),
                        leading: const Icon(Icons.email),
                      ),
                      if (usuario.telefono != null && usuario.telefono!.isNotEmpty)
                        ListTile(
                          title: const Text('Teléfono'),
                          subtitle: Text(usuario.telefono!),
                          leading: const Icon(Icons.phone),
                        ),
                      if (usuario.bio != null && usuario.bio!.isNotEmpty)
                        ListTile(
                          title: const Text('Bio'),
                          subtitle: Text(usuario.bio!),
                          leading: const Icon(Icons.description),
                        ),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 16),
                      // Logout Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            await proveedor.cerrarSesion();
                            if (!mounted) return;
                            Navigator.of(context)
                                .pushReplacementNamed('/login');
                          },
                          icon: const Icon(Icons.logout),
                          label: const Text('Cerrar sesión'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                        ),
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
