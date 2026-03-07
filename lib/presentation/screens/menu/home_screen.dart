import 'package:flutter/material.dart';

class HomePrincipalScreen extends StatefulWidget {
  const HomePrincipalScreen({super.key});

  @override
  State<HomePrincipalScreen> createState() => _HomePrincipalScreenState();
}

class _HomePrincipalScreenState extends State<HomePrincipalScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Imagen de fondo que abarca el 75% de la pantalla
        FractionallySizedBox(
          widthFactor: 0.75,
          heightFactor: 0.75,
          child: Image.asset(
            'assets/bg.png',
            fit: BoxFit.contain, // Mantiene la proporción de la imagen
          ),
        ),
        // Contenido por encima del fondo
        const Center(
          child: Text(
            'HOME PRINCIPAL',
            style: TextStyle(
              fontSize: 24, 
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}