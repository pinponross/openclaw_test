import 'package:flutter/material.dart';

class ComprasScreen extends StatefulWidget {
  const ComprasScreen({super.key});

  @override
  State<ComprasScreen> createState() => _ComprasScreenState();
}

class _ComprasScreenState extends State<ComprasScreen> {
  // Lista de opciones para Compras
  final List<Map<String, dynamic>> _comprasItems = [
    {'title': 'Emitir Comprobantes de Compra', 'icon': Icons.receipt}, // Icono para comprobantes
    {'title': 'Diario de Compras', 'icon': Icons.description}, // Icono semejante a hojas
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compras'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: _comprasItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(
              _comprasItems[index]['icon'],
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text(_comprasItems[index]['title']),
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