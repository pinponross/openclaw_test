import 'package:flutter/material.dart'; 

class InventariosScreen extends StatefulWidget {
  const InventariosScreen({super.key});

  @override
  State<InventariosScreen> createState() => _InventariosScreenState();
}

class _InventariosScreenState extends State<InventariosScreen> {

    // Lista de items para la pestaña de Inventarios
  final List<Map<String, dynamic>> _inventariosItems = [
    {
      'title': 'Artículos / Servicios',
      'icon': Icons.category,
    }, // Categorías/Artículos
    {'title': 'Existencias', 'icon': Icons.inventory_2}, // Cajas/Existencias
  ];


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _inventariosItems.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(
            _inventariosItems[index]['icon'],
            color: Theme.of(context).colorScheme.primary,
          ),
          title: Text(_inventariosItems[index]['title']),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // Lógica futura para cada item de inventarios
          },
        );
      },
    );
  }
} 