import 'package:flutter/material.dart';
import 'package:recyclemate_app/forget_password.dart';
import 'routes.dart';
import 'login_page.dart';
import 'register_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Form Widget',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // home: const MyHomePage(title: 'Flutter Form Widget'),
        initialRoute: Routes.LoginPage,
        routes: {
          Routes.LoginPage: (context) =>  LoginPage(),
          Routes.RegisterPage: (context) => const RegisterPage(),
          Routes.ForgetPassword: (context) => const ForgetPassword(),
        });
  }
}