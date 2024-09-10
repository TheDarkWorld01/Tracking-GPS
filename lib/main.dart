import 'package:flutter/material.dart';
import 'package:bottrack/pages/splash.dart';
import 'package:bottrack/pages/welcome.dart';
import 'package:bottrack/pages/register.dart';
import 'package:bottrack/pages/login.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ), //ThemeData
      routes: {
        "/"         : (context) => SplashScreen(),
        "Welcome"   : (context) => WelcomeScreen(),
        "Register"  : (context) => RegisterPage(),
        "Login"     : (context) => LoginPage(),
      },
    );
  }
}
