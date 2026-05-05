import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../proveedores/proveedor_autenticacion.dart';
import '../../servicios/servicio_supabase.dart';
import '../../modelos/modelo_resena.dart';

class PantallaAgregarResena extends StatefulWidget {
  final String destinoId;
  final String nombreDestino;

  const PantallaAgregarResena({
    Key? key,
    required this.destinoId,
    required this.nombreDestino,
  }) : super(key: key);

  @override
  State<PantallaAgregarResena> createState() => _PantallaAgregarResenaState();
}

class _PantallaAgregarResenaState extends State<PantallaAgregarResena> {
  final controladorComentario = TextEditingController();
  int calificacion = 5;
  bool guardando = false;

  @override
  void dispose() {
    controladorComentario.dispose();
    super.dispose();
  }

  Future<void> _guardarResena() async {
    if (controladorComentario.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor escribe un comentario')),
      );
      return;
    }

    setState(() => guardando = true);

    final proveedor = context.read<ProveedorAutenticacion>();
    if (proveedor.usuario == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes iniciar sesión')),
      );
      setState(() => guardando = false);
      return;
    }

    try {
      final servicio = SupabaseService.instancia;
      await servicio.crearResena(
        idDestino: widget.destinoId,
        idUsuario: proveedor.usuario!.id,
        comentario: controladorComentario.text.trim(),
        calificacion: calificacion,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('¡Reseña guardada exitosamente!')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() => guardando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reseña de ${widget.nombreDestino}'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Calificación
              Text(
                'Tu calificación',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          calificacion = index + 1;
                        });
                      },
                      child: Icon(
                        Icons.star,
                        size: 40,
                        color: index < calificacion
                            ? Colors.amber
                            : Colors.grey.shade300,
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 8),
              Text(
                '$calificacion/5 estrellas',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              // Comentario
              Text(
                'Tu comentario',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controladorComentario,
                decoration: InputDecoration(
                  hintText: 'Cuéntanos qué te pareció este lugar...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 5,
                minLines: 4,
                enabled: !guardando,
              ),
              const SizedBox(height: 32),
              // Botones
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: guardando ? null : () => Navigator.of(context).pop(),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: guardando ? null : _guardarResena,
                      child: guardando
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Text('Publicar reseña'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
