import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../proveedores/proveedor_autenticacion.dart';
import '../../servicios/servicio_supabase.dart';
import '../../modelos/modelo_destino.dart';

class PantallaInicio extends StatefulWidget {
  const PantallaInicio({Key? key}) : super(key: key);

  @override
  State<PantallaInicio> createState() => _PantallaInicioState();
}

class _PantallaInicioState extends State<PantallaInicio> {
  late SupabaseService servicio;
  List<ModeloDestino> destinos = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    servicio = SupabaseService.instancia;
    _cargarDestinos();
  }

  Future<void> _cargarDestinos() async {
    setState(() => cargando = true);
    destinos = await servicio.obtenerDestinos();
    setState(() => cargando = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TravelMex'),
        elevation: 0,
        actions: [
          Consumer<ProveedorAutenticacion>(
            builder: (context, proveedor, child) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed('/perfil');
                    },
                    child: Row(
                      children: [
                        if (proveedor.usuario?.avatarUrl != null)
                          CircleAvatar(
                            radius: 16,
                            backgroundImage: NetworkImage(
                              proveedor.usuario!.avatarUrl!,
                            ),
                          )
                        else
                          const CircleAvatar(
                            radius: 16,
                            child: Icon(Icons.person, size: 16),
                          ),
                        const SizedBox(width: 8),
                        Text(
                          proveedor.usuario?.nombre ?? 'Usuario',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _cargarDestinos,
              child: ListView.builder(
                itemCount: destinos.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Descubre destinos',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Explora lugares increíbles para visitar',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    );
                  }

                  final destino = destinos[index - 1];

                  return _tarjetaDestino(context, destino);
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/mapa');
        },
        child: const Icon(Icons.map),
      ),
    );
  }

  Widget _tarjetaDestino(BuildContext context, ModeloDestino destino) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          '/detalles',
          arguments: destino,
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
              ),
              child: destino.urlImagen != null
                  ? Image.network(
                      destino.urlImagen!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.image_not_supported),
                        );
                      },
                    )
                  : Container(
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.location_on),
                    ),
            ),
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
                          destino.nombre,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (destino.esDestacado)
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              '⭐ Destacado',
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    destino.descripcion,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star, size: 16, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            '${destino.calificacionPromedio.toStringAsFixed(1)}/5',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      Text(
                        '\$${destino.precioPorNoche.toStringAsFixed(2)}/noche',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
