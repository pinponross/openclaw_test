import 'package:flutter/material.dart';

class ProduccionScreen extends StatefulWidget {
  const ProduccionScreen({super.key});

  @override
  State<ProduccionScreen> createState() => _ProduccionScreenState();
}

class _ProduccionScreenState extends State<ProduccionScreen> {
  // Lista de opciones para Producción
  final List<Map<String, dynamic>> _produccionItems = [
    {'title': 'Calendario', 'icon': Icons.calendar_month}, // Icono para Calendario
    {'title': 'Apartado', 'icon': Icons.bookmark_add}, // Icono para crear un apartado
    {'title': 'Lista de Apartados', 'icon': Icons.list_alt}, // Icono para la lista
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Producción'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: _produccionItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(
              _produccionItems[index]['icon'],
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text(_produccionItems[index]['title']),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Lógica futura para cada item
            },
          );
        },
      ),
    );
  }
}