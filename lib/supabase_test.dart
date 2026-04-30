import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'constants/supabase_keys.dart';
import 'travelmex.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  runApp(const SupabaseTestApp());
}

class SupabaseTestApp extends StatelessWidget {
  const SupabaseTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Supabase Test',
      theme: TmTheme.light,
      home: const SupabaseTestScreen(),
    );
  }
}

class SupabaseTestScreen extends StatefulWidget {
  const SupabaseTestScreen({super.key});

  @override
  State<SupabaseTestScreen> createState() => _SupabaseTestScreenState();
}

class _SupabaseTestScreenState extends State<SupabaseTestScreen> {
  String _status = 'Probando conexión...';
  final List<String> _results = [];

  @override
  void initState() {
    super.initState();
    _testConnection();
  }

  Future<void> _testConnection() async {
    try {
      // Test 1: Basic connection
      setState(() {
        _status = 'Probando conexión básica...';
      });

      final client = Supabase.instance.client;
      await Future.delayed(const Duration(seconds: 1)); // Small delay

      setState(() {
        _results.add('✅ Conexión básica exitosa');
        _status = 'Probando consulta de categorías...';
      });

      // Test 2: Fetch categories
      final categoriesResponse = await client
          .from('categories')
          .select()
          .limit(5);

      setState(() {
        _results.add('✅ Consulta de categorías exitosa: ${categoriesResponse.length} registros');
        _status = 'Probando consulta de destinos...';
      });

      // Test 3: Fetch destinations
      final destinationsResponse = await client
          .from('destinations')
          .select()
          .limit(3);

      setState(() {
        _results.add('✅ Consulta de destinos exitosa: ${destinationsResponse.length} registros');
        _status = 'Probando consulta de reseñas...';
      });

      // Test 4: Fetch reviews
      final reviewsResponse = await client
          .from('reviews')
          .select()
          .limit(2);

      setState(() {
        _results.add('✅ Consulta de reseñas exitosa: ${reviewsResponse.length} registros');
        _status = '¡Todas las pruebas pasaron exitosamente! 🎉';
      });

    } catch (e) {
      setState(() {
        _status = '❌ Error en la conexión';
        _results.add('Error: $e');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prueba de Supabase'),
        backgroundColor: TmColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _status,
              style: TmTheme.light.textTheme.headlineSmall?.copyWith(
                color: _status.contains('❌') ? TmColors.error : TmColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Resultados de las pruebas:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _results.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      _results[index],
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _testConnection,
              style: ElevatedButton.styleFrom(
                backgroundColor: TmColors.primary,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Probar de Nuevo'),
            ),
          ],
        ),
      ),
    );
  }
}