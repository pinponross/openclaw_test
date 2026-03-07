import 'package:flutter/material.dart';

class ConfigAppScreen extends StatefulWidget {
  const ConfigAppScreen({super.key});

  @override
  State<ConfigAppScreen> createState() => _ConfigAppScreenState();
}

class _ConfigAppScreenState extends State<ConfigAppScreen> {
  final _urlController = TextEditingController();
  bool _rememberGroupAndDb = false;
  String? _selectedGroup = 'Fierro y Lamina'; // Valor inicial de muestra

  final List<String> _groupOptions = [
    'Fierro y Lamina',
    'DEIMAN',
  ];

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Ajustes de Conexión',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            
            // Campo URL Servidor
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: 'URL Servidor SuperADMINISTRADOR',
                hintText: 'http://sa.superadministrador.com.mx:1500/Superadministrador/',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 20),

            // Dropdown Grupo de Base de Datos
            const Text(
              'Grupo de base de datos',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedGroup,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[50],
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              items: _groupOptions.map((String group) {
                return DropdownMenuItem<String>(
                  value: group,
                  child: Text(group),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedGroup = newValue;
                });
              },
              icon: const Icon(Icons.arrow_drop_down),
              elevation: 16,
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
            const SizedBox(height: 20),
            
            // Checkbox Recordar Último Grupo y BD
            CheckboxListTile(
              title: const Text('Recordar Último Grupo y Base de Datos'),
              value: _rememberGroupAndDb,
              onChanged: (bool? value) {
                setState(() {
                  _rememberGroupAndDb = value ?? false;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              activeColor: Theme.of(context).colorScheme.primary,
            ),
            
            const Spacer(),
            
            // Botones
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Regresa al widget de inicio
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(color: Theme.of(context).colorScheme.primary),
                    ),
                    child: Text(
                      'Cancelar',
                      style: TextStyle(color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Lógica de guardado
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Configuración guardada (Endpoints pendientes)')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: const Text('Guardar'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
