import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/scan_history_screen.dart';
import 'screens/scan_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
  } catch (e) {
    // ignore: avoid_print
    print('Firebase initialization error: $e');
  }

  runApp(const RecycleMateApp());
}

class RecycleMateApp extends StatelessWidget {
  const RecycleMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RecycleMate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const ScanScreen(),
      routes: {
        '/scan': (context) => const ScanScreen(),
        '/scan-history': (context) => const ScanHistoryScreen(),
      },
    );
  }
}
