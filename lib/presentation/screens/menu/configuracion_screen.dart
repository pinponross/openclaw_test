// Lista de items para la pestaña de Configuración
import 'package:flutter/material.dart';

final List<Map<String, dynamic>> _configItems = [
  {'title': 'Crear Contraseña', 'icon': Icons.vpn_key},
];

class ConfiguracionScreen extends StatelessWidget {
  const ConfiguracionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: _configItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(
              _configItems[index]['icon'],
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text(_configItems[index]['title']),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Lógica futura para cada item de configuración
            },
          );
        },
      ),
    );
  }
}
