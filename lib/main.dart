import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'constants/supabase_keys.dart';
import 'theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'screens/auth/auth_gate.dart';
import 'screens/auth/register_screen.dart';
import 'screens/details/details_screen.dart';
import 'screens/add_review_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  runApp(const TravelMexApp());
}

class TravelMexApp extends StatelessWidget {
  const TravelMexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'TravelMex',
        debugShowCheckedModeBanner: false,
        theme: TmTheme.light,
        home: const AuthGate(),
        routes: {
          '/register': (_) => const RegisterScreen(),
          '/add_review': (_) => const AddReviewScreen(),
        },
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(
                builder: (context) => const AuthGate(),
              );
            case '/details':
              return MaterialPageRoute(
                builder: (context) => const DetailsScreen(),
                settings: settings,
              );
            default:
              return null;
          }
        },
      ),
    );
  }
}