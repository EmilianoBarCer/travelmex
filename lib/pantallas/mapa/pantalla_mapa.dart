import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import '../../servicios/servicio_supabase.dart';
import '../../modelos/modelo_destino.dart';
import '../../utilidades/configuracion_google_maps.dart';

class PantallaMapa extends StatefulWidget {
  const PantallaMapa({Key? key}) : super(key: key);

  @override
  State<PantallaMapa> createState() => _PantallaMapaState();
}

class _PantallaMapaState extends State<PantallaMapa> {
  late GoogleMapController controladorMapa;
  Set<Marker> marcadores = {};
  Set<Polyline> polilineas = {};
  LocationData? ubicacionActual;
  List<ModeloDestino> destinos = [];
  bool cargando = true;

  // Coordenadas iniciales de Guadalajara (desde configuración)
  static const LatLng ubicacionInicial = LatLng(LATITUD_GUADALAJARA, LONGITUD_GUADALAJARA);

  @override
  void initState() {
    super.initState();
    _cargarDestinos();
    _solicitarPermisoUbicacion();
  }

  Future<void> _cargarDestinos() async {
    try {
      final servicio = SupabaseService.instancia;
      destinos = await servicio.obtenerDestinos();

      // Crear marcadores para cada destino
      for (var destino in destinos) {
        marcadores.add(
          Marker(
            markerId: MarkerId(destino.id),
            position: LatLng(destino.latitud, destino.longitud),
            infoWindow: InfoWindow(
              title: destino.nombre,
              snippet: '\$${destino.precioPorNoche}/noche',
            ),
            onTap: () {
              _mostrarDetallesDestino(destino);
            },
          ),
        );
      }

      setState(() => cargando = false);
    } catch (e) {
      debugPrint('Error cargando destinos: $e');
      setState(() => cargando = false);
    }
  }

  Future<void> _solicitarPermisoUbicacion() async {
    final location = Location();
    bool permisoOtorgado = await location.hasPermission() == PermissionStatus.granted;

    if (!permisoOtorgado) {
      permisoOtorgado = await location.requestPermission() == PermissionStatus.granted;
    }

    if (permisoOtorgado) {
      try {
        ubicacionActual = await location.getLocation();
        setState(() {});
      } catch (e) {
        debugPrint('Error obteniendo ubicación: $e');
      }
    }
  }

  void _mostrarDetallesDestino(ModeloDestino destino) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      destino.nombre,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(destino.descripcion),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 18),
                      const SizedBox(width: 4),
                      Text('${destino.calificacionPromedio.toStringAsFixed(1)}/5'),
                    ],
                  ),
                  Text('\$${destino.precioPorNoche.toStringAsFixed(2)}/noche'),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.of(context).pushNamed(
                      '/detalles',
                      arguments: destino,
                    );
                  },
                  child: const Text('Ver detalles'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _irAUbicacionActual() {
    if (ubicacionActual != null) {
      controladorMapa.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(ubicacionActual!.latitude!, ubicacionActual!.longitude!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa de Destinos'),
      ),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: ubicacionInicial,
                zoom: ZOOM_DEFECTO,
              ),
              onMapCreated: (controller) {
                controladorMapa = controller;
              },
              markers: marcadores,
              polylines: polilineas,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
            ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            mini: true,
            onPressed: _irAUbicacionActual,
            child: const Icon(Icons.my_location),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            mini: true,
            onPressed: () {
              controladorMapa.animateCamera(
                CameraUpdate.newLatLng(ubicacionInicial),
              );
            },
            child: const Icon(Icons.home),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controladorMapa.dispose();
    super.dispose();
  }
}
