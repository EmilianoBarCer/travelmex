import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/constants/supabase_keys.dart';
import 'core/theme/app_theme.dart';
import 'lobby/auth_provider.dart';
import 'lobby/login/login_screen.dart';
import 'lobby/register/register_screen.dart';
import 'home/home_screen.dart';
import 'perfil/profile_screen.dart';
import 'map/map_screen.dart';
import 'destino/details_screen.dart';
import 'lobby/auth_gate.dart';
import 'home/home_provider.dart';
import 'search/search_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabasePublishableKey,
  );

  runApp(const AplicacionTravelMex());
}

class AplicacionTravelMex extends StatelessWidget {
  const AplicacionTravelMex({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
      ],
      child: MaterialApp(
        title: 'TravelMex',
        debugShowCheckedModeBanner: false,
        theme: TmTheme.light,
        home: const AuthGate(),
        routes: {
          '/login':       (_) => const PantallaLogin(),
          '/registrarse': (_) => const PantallaRegistro(),
          '/inicio':      (_) => const HomeScreen(),
          '/perfil':      (_) => const ProfileScreen(),
          '/mapa':        (_) => const MapScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/detalles') {
            // ✅ DetailsScreen espera un String (id), no un objeto Destination
            final destinationId = settings.arguments as String?;
            if (destinationId != null) {
              return MaterialPageRoute(
                builder: (_) => const DetailsScreen(),
              );
            }
          }
          return null;
        },
      ),
    );
  }
}
