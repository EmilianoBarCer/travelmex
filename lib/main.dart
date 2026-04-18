import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/location_screen.dart';
import 'screens/add_review_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();


  await Supabase.initialize(
    url: 'https://ragddoryqrckalferilf.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJhZ2Rkb3J5cXJja2FsZmVyaWxmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzY0OTU0OTUsImV4cCI6MjA5MjA3MTQ5NX0.MEIHXvvdNXdVV8_PBuL-lYjI_9DcpjrnydkBulS-8sI',
  );

  runApp(const TravelMexApp());
}

class TravelMexApp extends StatelessWidget {
  const TravelMexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TravelMex',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
          primary: Colors.deepOrange,
          secondary: Colors.teal,
          surface: const Color(0xFFF8F9FA),
        ),
        textTheme: GoogleFonts.latoTextTheme(),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/add_review': (context) => const AddReviewScreen(),
      },
    );
  }
}