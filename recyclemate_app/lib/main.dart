import 'package:flutter/material.dart';
import 'package:recyclemate_app/Pages/forget_password.dart';
import 'package:recyclemate_app/Pages/home_page.dart';
import 'package:recyclemate_app/Pages/onboard_page.dart';
import 'services/routes.dart';
import 'Pages/login_page.dart';
import 'Pages/register_page.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'RecycleMate',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Inter',
        ),
        // home: const MyHomePage(title: 'Flutter Form Widget'),
        initialRoute: Routes.OnStart,
        routes: {
          Routes.OnStart: (context) => OnStart(),
          Routes.LoginPage: (context) =>  LoginPage(),
          Routes.RegisterPage: (context) => const RegisterPage(),
          Routes.ForgetPassword: (context) => const ForgetPassword(),
          Routes.HomePageDummy: (context) => const HomePageDummy(),
        });
  }
}