import 'package:flutter/material.dart';
import 'package:recyclemate_app/Pages/forget_password.dart';
import 'package:recyclemate_app/Pages/home_page.dart';
import 'package:recyclemate_app/Pages/onboard_page.dart';
import 'package:recyclemate_app/Pages/search_page.dart';
import 'package:recyclemate_app/Pages/educational_guide_page.dart';
import 'services/routes.dart';
import 'Pages/login_page.dart';
import 'Pages/register_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/scan_history_screen.dart';
import 'screens/scan_screen.dart';

void main() async {
  // Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RecycleMate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Inter'),
      initialRoute: Routes.onStart,
      routes: {
        Routes.onStart: (context) => const OnStart(),
        Routes.loginPage: (context) => const LoginPage(),
        Routes.registerPage: (context) => const RegisterPage(),
        Routes.forgetPassword: (context) => const ForgetPassword(),
        Routes.homePageDummy: (context) => const HomePageDummy(),
        Routes.scanScreen: (context) => const ScanScreen(),
        Routes.scanHistoryScreen: (context) => const ScanHistoryScreen(),
        Routes.searchPage: (context) => const SearchPage(),
        Routes.educationalGuide: (context) => const EducationalGuidePage(),
      },
    );
  }
}
