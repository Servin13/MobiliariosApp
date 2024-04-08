import 'package:flutter/material.dart';
import 'package:mobiliarios/screens/bienvenidos_screen.dart';
import 'package:mobiliarios/screens/alta_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "bienvenido",
      routes: {
        "bienvenido": (context) => BienvenidoScreen(),
        "alta": (context) => AltaScreen(),
      },
    );
  }
}
