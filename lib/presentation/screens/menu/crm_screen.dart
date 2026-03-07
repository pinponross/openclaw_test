import 'package:flutter/material.dart';

class CrmScreen extends StatefulWidget {
  const CrmScreen({super.key});

  @override
  State<CrmScreen> createState() => _CrmScreenState();
}

class _CrmScreenState extends State<CrmScreen> {
  // Lista de opciones para CRM
  final List<Map<String, dynamic>> _crmItems = [
    {'title': 'Tablero de Actividades', 'icon': Icons.dashboard}, // Icono de tablero
    {'title': 'Actividades', 'icon': Icons.assignment}, // Icono de tareas/asignaciones
    {'title': 'Prospectos', 'icon': Icons.person_search}, // Icono de búsqueda de personas/prospectos
    {'title': 'Oportunidades', 'icon': Icons.lightbulb}, // Icono de idea/oportunidad
    {'title': 'Visitas', 'icon': Icons.location_on}, // Icono de pin de ubicación
    {'title': 'Iniciar Visita', 'icon': Icons.play_circle_fill}, // Icono de iniciar/play
    {'title': 'Soporte', 'icon': Icons.support_agent}, // Icono de agente de soporte
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRM'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: _crmItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(
              _crmItems[index]['icon'],
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text(_crmItems[index]['title']),
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