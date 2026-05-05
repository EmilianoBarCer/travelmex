import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../proveedores/proveedor_autenticacion.dart';
import '../../servicios/servicio_supabase.dart';
import '../../modelos/modelo_destino.dart';
import '../../modelos/modelo_resena.dart';
import '../resenas/pantalla_agregar_resena.dart';

class PantallaDetalles extends StatefulWidget {
  final ModeloDestino destino;

  const PantallaDetalles({
    Key? key,
    required this.destino,
  }) : super(key: key);

  @override
  State<PantallaDetalles> createState() => _PantallaDetallesState();
}

class _PantallaDetallesState extends State<PantallaDetalles> {
  late SupabaseService servicio;
  List<ModeloResena> resenas = [];
  bool cargandoResenas = true;

  @override
  void initState() {
    super.initState();
    servicio = SupabaseService.instancia;
    _cargarResenas();
  }

  Future<void> _cargarResenas() async {
    setState(() => cargandoResenas = true);
    resenas = await servicio.obtenerResenasPorDestino(widget.destino.id);
    setState(() => cargandoResenas = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Destino'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen
            Container(
              width: double.infinity,
              height: 250,
              color: Colors.grey.shade300,
              child: widget.destino.urlImagen != null
                  ? Image.network(
                      widget.destino.urlImagen!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(Icons.image_not_supported),
                        );
                      },
                    )
                  : const Center(
                      child: Icon(Icons.location_on, size: 80),
                    ),
            ),

            // Header Info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.destino.nombre,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      if (widget.destino.esDestacado)
                        const Icon(Icons.star, color: Colors.amber, size: 24),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: Colors.red),
                      const SizedBox(width: 4),
                      Text(widget.destino.ubicacion),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star, size: 20, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.destino.calificacionPromedio.toStringAsFixed(1)}/5',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                      Text(
                        '\$${widget.destino.precioPorNoche.toStringAsFixed(2)}/noche',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: Colors.green),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  const SizedBox(height: 16),
                  Text(
                    'Descripción',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(widget.destino.descripcion),
                ],
              ),
            ),

            // Botón de agregar reseña
            Padding(
              padding: const EdgeInsets.all(16),
              child: Consumer<ProveedorAutenticacion>(
                builder: (context, proveedor, child) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: proveedor.estaAutenticado
                          ? () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => PantallaAgregarResena(
                                    destinoId: widget.destino.id,
                                    nombreDestino: widget.destino.nombre,
                                  ),
                                ),
                              ).then((_) {
                                _cargarResenas();
                              });
                            }
                          : () {
                              Navigator.of(context).pushNamed('/login');
                            },
                      icon: const Icon(Icons.rate_review),
                      label: Text(
                        proveedor.estaAutenticado
                            ? 'Agregar reseña'
                            : 'Inicia sesión para reseñar',
                      ),
                    ),
                  );
                },
              ),
            ),

            // Reseñas
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Reseñas (${resenas.length})',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),

            if (cargandoResenas)
              const Center(child: CircularProgressIndicator())
            else if (resenas.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    'No hay reseñas aún. ¡Sé el primero en reseñar!',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: resenas.length,
                itemBuilder: (context, index) {
                  final resena = resenas[index];
                  return _tarjetaResena(context, resena);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _tarjetaResena(BuildContext context, ModeloResena resena) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  child: Icon(Icons.person),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        resena.nombreUsuario ?? 'Usuario anónimo',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        resena.tiempoTranscurrido,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Row(
                  children: List.generate(5, (i) {
                    return Icon(
                      Icons.star,
                      size: 16,
                      color: i < resena.calificacion
                          ? Colors.amber
                          : Colors.grey.shade300,
                    );
                  }),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(resena.comentario),
          ],
        ),
      ),
    );
  }
}
