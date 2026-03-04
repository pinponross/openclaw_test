import 'package:flutter/material.dart';
import 'login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Color Primario: #205599 (Azul oscuro)
    // Color Secundario: Variante clara del color primario
    const Color primaryColor = Color(0xFF205599);
    const Color secondaryColor = Color(0xFF4B87D1); // Tono más claro

    return MaterialApp(
      title: 'SuperADMINISTRADOR',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          primary: primaryColor,
          secondary: secondaryColor,
        ),
        useMaterial3: true,
        primaryColor: primaryColor,
      ),
      home: const LoginScreen(),
    );
  }
}
