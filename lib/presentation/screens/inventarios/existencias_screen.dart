import 'package:flutter/material.dart';

class ExistenciasScreen extends StatefulWidget {
  const ExistenciasScreen({super.key});

  @override
  State<ExistenciasScreen> createState() => _ExistenciasScreenState();
}

class _ExistenciasScreenState extends State<ExistenciasScreen> {
  final _formKey = GlobalKey<FormState>();

  // --- VARIABLES DE ESTADO (Filtros y Opciones) ---
  DateTime _fechaDel = DateTime.now();
  DateTime _fechaAl = DateTime.now();

  // Opciones (Checkboxes)
  bool _costoUltimaCompra = false;
  bool _costoVenta = true;
  bool _consolidadoSucursal = false;
  bool _consolidadoSucursalColumna = false;
  bool _soloExistencia = false;
  bool _incluirServicios = false;
  bool _desglosarLotes = false;

  // Combos y Filtros de Texto
  String _almacenSeleccionado = 'Todos';
  String _listaPrecios = 'Precio 1';
  String _moneda = 'Local';
  
  final TextEditingController _articuloController = TextEditingController();
  final TextEditingController _lineaController = TextEditingController();
  final TextEditingController _marcaController = TextEditingController();
  final TextEditingController _tipoController = TextEditingController();

  // Formateador de fecha simple (sin dependencias externas)
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Future<void> _selectDate(BuildContext context, bool isDel) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isDel ? _fechaDel : _fechaAl,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isDel) {
          _fechaDel = picked;
        } else {
          _fechaAl = picked;
        }
      });
    }
  }

  // Widget para agrupar controles (Equivalente al CtrlFieldSet en React)
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
  void dispose() {
    _articuloController.dispose();
    _lineaController.dispose();
    _marcaController.dispose();
    _tipoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verificador de Costos y Existencias'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // --- SECCIÓN: RANGO DE FECHAS ---
              _buildFieldSet(
                titulo: 'Periodo de Consulta',
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectDate(context, true),
                        child: InputDecorator(
                          decoration: const InputDecoration(labelText: 'Del', border: OutlineInputBorder()),
                          child: Text(_formatDate(_fechaDel)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectDate(context, false),
                        child: InputDecorator(
                          decoration: const InputDecoration(labelText: 'Al', border: OutlineInputBorder()),
                          child: Text(_formatDate(_fechaAl)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // --- SECCIÓN: OPCIONES ---
              _buildFieldSet(
                titulo: 'Opciones de Visualización',
                child: Column(
                  children: [
                    CheckboxListTile(
                      title: const Text('Costo de Última Compra'),
                      value: _costoUltimaCompra,
                      onChanged: (val) {
                        setState(() {
                          _costoUltimaCompra = val!;
                          if (_costoUltimaCompra) _costoVenta = false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                      dense: true,
                    ),
                    CheckboxListTile(
                      title: const Text('Costo de Venta'),
                      value: _costoVenta,
                      onChanged: (val) {
                        setState(() {
                          _costoVenta = val!;
                          if (_costoVenta) _costoUltimaCompra = false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                      dense: true,
                    ),
                    CheckboxListTile(
                      title: const Text('Consolidado por Sucursal'),
                      value: _consolidadoSucursal,
                      onChanged: (val) => setState(() => _consolidadoSucursal = val!),
                      controlAffinity: ListTileControlAffinity.leading,
                      dense: true,
                    ),
                    CheckboxListTile(
                      title: const Text('Solo Existencia'),
                      value: _soloExistencia,
                      onChanged: (val) => setState(() => _soloExistencia = val!),
                      controlAffinity: ListTileControlAffinity.leading,
                      dense: true,
                    ),
                  ],
                ),
              ),

              // --- SECCIÓN: FILTROS ---
              _buildFieldSet(
                titulo: 'Filtros de Artículos',
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Almacén', border: OutlineInputBorder()),
                      value: _almacenSeleccionado,
                      items: ['Todos', 'Almacén Central', 'Sucursal Norte']
                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (val) => setState(() => _almacenSeleccionado = val!),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _articuloController,
                      decoration: const InputDecoration(
                        labelText: 'Artículo (Rango o Clave)',
                        border: OutlineInputBorder(),
                        helperText: 'Ejemplo: ART001, ART005-ART010',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _lineaController,
                      enabled: !_costoUltimaCompra, // Lógica del JS
                      decoration: const InputDecoration(
                        labelText: 'Línea',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Moneda', border: OutlineInputBorder()),
                      value: _moneda,
                      items: ['Local', 'Dólares']
                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (val) => setState(() => _moneda = val!),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // --- ACCIONES ---
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Simular "Ver por Pantalla"
                      },
                      icon: const Icon(Icons.monitor),
                      label: const Text('Ver por Pantalla'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Simular Impresión
                      },
                      icon: const Icon(Icons.print),
                      label: const Text('Imprimir'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}