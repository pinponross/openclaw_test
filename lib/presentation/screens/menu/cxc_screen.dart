// ... existing code ...
import 'package:flutter/material.dart';

class CxcScreen extends StatelessWidget {
  const CxcScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Lista de opciones para CxC
    final List<Map<String, dynamic>> cxcItems = [
      {'title': 'Clientes / Deudores', 'icon': Icons.people_alt}, // Icono para Clientes
      {'title': 'Captura de Pagos', 'icon': Icons.price_check}, // Icono para Captura de Pagos
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cuentas por Cobrar'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: cxcItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(
              cxcItems[index]['icon'],
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text(cxcItems[index]['title']),
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