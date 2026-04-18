// ignore_for_file: avoid_print

import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  print('🚀 Iniciando prueba de conexión con Supabase...');

  try {
    await Supabase.initialize(
      url: 'https://ragddoryqrckalferilf.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJhZ2Rkb3J5cXJja2FsZmVyaWxmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzY0OTU0OTUsImV4cCI6MjA5MjA3MTQ5NX0.MEIHXvvdNXdVV8_PBuL-lYjI_9DcpjrnydkBulS-8sI',
    );

    print('✅ Supabase inicializado correctamente');

    final client = Supabase.instance.client;
    print('🔍 Probando consulta de categorías...');

    final categories = await client
        .from('categories')
        .select()
        .limit(5);

    print('✅ Categorías encontradas: ${categories.length}');
    for (var category in categories) {
      print('  - ${category['name']} (${category['icon_name']})');
    }

    print('🔍 Probando consulta de destinos...');
    final destinations = await client
        .from('destinations')
        .select()
        .limit(3);

    print('✅ Destinos encontrados: ${destinations.length}');
    for (var dest in destinations) {
      print('  - ${dest['name']} en ${dest['location']}');
    }

    print('🎉 ¡Todas las pruebas pasaron exitosamente!');
    print('📱 Tu aplicación TravelMex está lista para funcionar.');

  } catch (e) {
    print('❌ Error en la conexión: $e');
    print('💡 Asegúrate de:');
    print('   1. Haber ejecutado schema.sql en Supabase SQL Editor');
    print('   2. Haber ejecutado seed.sql para poblar datos');
    print('   3. Que tu URL y anonKey sean correctos');
  }
}