import 'package:flutter/material.dart';

class ConsultaPorArticuloScreen extends StatefulWidget {
  const ConsultaPorArticuloScreen({super.key});

  @override
  State<ConsultaPorArticuloScreen> createState() => _ConsultaPorArticuloScreenState();
}

class _ConsultaPorArticuloScreenState extends State<ConsultaPorArticuloScreen> {
  final TextEditingController _articuloController = TextEditingController();
  String _almacenSeleccionado = 'Todos';

  // Datos de ejemplo para simular el estado interno de la consulta
  final List<Map<String, dynamic>> _existencias = [
    {
      'sucursal': 'Sucursal Central',
      'existencia': 150.0,
      'pedidos': 10.0,
      'apartados': 5.0,
      'disponible': 135.0,
      'costo': 25.50
    },
    {
      'sucursal': 'Sucursal Norte',
      'existencia': 45.0,
      'pedidos': 0.0,
      'apartados': 2.0,
      'disponible': 43.0,
      'costo': 26.00
    },
  ];

  final List<Map<String, dynamic>> _comprasProvDetalle = [
    {'nombre': 'Proveedor Global S.A.', 'ultimoCosto': 24.50},
    {'nombre': 'Distribuidora del Norte', 'ultimoCosto': 25.00},
  ];

  double _costoGlobal = 25.75;

  @override
  void dispose() {
    _articuloController.dispose();
    super.dispose();
  }

  // Widget para simular el CtrlFieldSet
  Widget _buildFieldSet({required String titulo, required Widget child}) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const Divider(),
            child,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consulta por Artículo'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Sección de Filtros (Similares a los controles superiores en React)
            _buildFieldSet(
              titulo: 'Búsqueda',
              child: Column(
                children: [
                  TextFormField(
                    controller: _articuloController,
                    decoration: InputDecoration(
                      labelText: 'Artículo (Clave / Nombre)',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          // Lógica de búsqueda (buscarArticulo en JS)
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Almacén',
                      border: OutlineInputBorder(),
                    ),
                    value: _almacenSeleccionado,
                    items: ['Todos', 'Almacén Central', 'Bodega Alterna']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (val) {
                      setState(() => _almacenSeleccionado = val!);
                    },
                  ),
                ],
              ),
            ),

            // Sección de Existencias (Equivalente al CtrlDataGrid en React)
            _buildFieldSet(
              titulo: 'Existencias por Sucursal',
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 20,
                  columns: const [
                    DataColumn(label: Text('Sucursal')),
                    DataColumn(label: Text('Existencia'), numeric: true),
                    DataColumn(label: Text('Apartados'), numeric: true),
                    DataColumn(label: Text('Disponible'), numeric: true),
                  ],
                  rows: _existencias.map((item) {
                    return DataRow(cells: [
                      DataCell(Text(item['sucursal'])),
                      DataCell(Text(item['existencia'].toString())),
                      DataCell(Text(item['apartados'].toString())),
                      DataCell(Text(
                        item['disponible'].toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )),
                    ]);
                  }).toList(),
                ),
              ),
            ),

            // Sección de Costo Global y Compras
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Columna de Costo Global
                Expanded(
                  flex: 3,
                  child: _buildFieldSet(
                    titulo: 'Costo Global',
                    child: Column(
                      children: [
                        Text(
                          '\$${_costoGlobal.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Costo promedio de todas las sucursales con existencia.',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Columna de Compras por Proveedor
                Expanded(
                  flex: 7,
                  child: _buildFieldSet(
                    titulo: 'Últimas Compras',
                    child: SizedBox(
                      height: 120,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _comprasProvDetalle.length,
                        itemBuilder: (context, index) {
                          final item = _comprasProvDetalle[index];
                          return ListTile(
                            dense: true,
                            leading: const Icon(Icons.business, size: 20),
                            title: Text(item['nombre'], style: const TextStyle(fontSize: 13)),
                            subtitle: Text('Costo: \$${item['ultimoCosto']}'),
                            trailing: const Icon(Icons.arrow_forward_ios, size: 12),
                            onTap: () {
                              // Lógica para ver detalles de compra por proveedor
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}