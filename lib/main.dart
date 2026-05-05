import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'constantes/claves_supabase.dart';
import 'tema/tema_app.dart';
import 'proveedores/proveedor_autenticacion.dart';
import 'pantallas/autenticacion/pantalla_login.dart';
import 'pantallas/autenticacion/pantalla_registro.dart';
import 'pantallas/inicio/pantalla_inicio.dart';
import 'pantallas/perfil/pantalla_perfil.dart';
import 'pantallas/mapa/pantalla_mapa.dart';
import 'pantallas/detalles/pantalla_detalles.dart';
import 'pantallas/diseno/pantalla_diseno.dart';
import 'modelos/modelo_destino.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: urlSupabase,
    anonKey: clavAnonSupabase,
  );

  runApp(const AplicacionTravelMex());
}

class AplicacionTravelMex extends StatelessWidget {
  const AplicacionTravelMex({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProveedorAutenticacion()),
      ],
      child: MaterialApp(
        title: 'TravelMex',
        debugShowCheckedModeBanner: false,
        theme: TemaApp.tema,
        home: const ObtenerPantallaPrincipal(),
        routes: {
          '/login': (_) => const PantallaLogin(),
          '/registrarse': (_) => const PantallaRegistro(),
          '/inicio': (_) => const PantallaInicio(),
          '/perfil': (_) => const PantallaPerfil(),
          '/mapa': (_) => const PantallaMapa(),
          '/diseno': (_) => const PantallaDiseno(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/detalles') {
            final destino = settings.arguments as ModeloDestino?;
            if (destino != null) {
              return MaterialPageRoute(
                builder: (_) => PantallaDetalles(destino: destino),
              );
            }
          }
          return null;
        },
      ),
    );
  }
}

/// Obtiene la pantalla principal según el estado de autenticación
class ObtenerPantallaPrincipal extends StatelessWidget {
  const ObtenerPantallaPrincipal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProveedorAutenticacion>(
      builder: (context, proveedor, child) {
        if (proveedor.cargando) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    'Cargando TravelMex...',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          );
        }

        return proveedor.estaAutenticado
            ? const PantallaInicio()
            : const PantallaLogin();
      },
    );
  }
}