import 'package:flutter/material.dart';
// L'importazione di intl è stata rimossa per evitare errori di dipendenza

class DiarioDeVentasScreen extends StatefulWidget {
  const DiarioDeVentasScreen({super.key});

  @override
  State<DiarioDeVentasScreen> createState() => _DiarioDeVentasScreenState();
}

class _DiarioDeVentasScreenState extends State<DiarioDeVentasScreen> {
  final _formKey = GlobalKey<FormState>();

  // Variabili di Stato - Date
  DateTime _fechaDel = DateTime.now();
  DateTime _fechaAl = DateTime.now();

  // Variabili di Stato - Menu a discesa (Valori predefiniti)
  String _almacenSeleccionado = 'Todos';
  String _cajaSeleccionada = 'Todas';
  String _cajeroSeleccionado = 'Todos';
  String _monedaSeleccionada = 'Local';
  String _tipoReporte = 'General';
  String _agruparPor = 'Sin Agrupar';
  String _detallarFormasCobro = 'No';

  // Variabili di Stato - Caselle di controllo
  bool _foliosCancelados = false;
  bool _sinCobro = false;
  bool _soloDevoluciones = false;

  // Variabili di Stato - Scadenza (Esclusive)
  bool _chkMenor = false;
  bool _chkIgual = false;
  bool _chkMayor = false;

  // Controller di Testo
  final TextEditingController _clienteController = TextEditingController();
  final TextEditingController _vendedorController = TextEditingController();
  final TextEditingController _diasVencimientoController = TextEditingController();

  // Funzione nativa per formattare le date senza dipendenze esterne
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

  Widget _buildSeccionTitulo(String titulo) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0, top: 10.0),
      child: Text(
        titulo,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _clienteController.dispose();
    _vendedorController.dispose();
    _diasVencimientoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diario de Ventas'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- SEZIONE: FILTRI DI RICERCA ---
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSeccionTitulo('Filtros de Búsqueda'),
                      Row(
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
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: 'Almacén', border: OutlineInputBorder()),
                        value: _almacenSeleccionado,
                        items: ['Todos', 'Almacén Central', 'Sucursal 1'].map((String value) {
                          return DropdownMenuItem<String>(value: value, child: Text(value));
                        }).toList(),
                        onChanged: (newValue) => setState(() => _almacenSeleccionado = newValue!),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: 'Caja', border: OutlineInputBorder()),
                        value: _cajaSeleccionada,
                        items: ['Todas', 'Caja 1', 'Caja 2'].map((String value) {
                          return DropdownMenuItem<String>(value: value, child: Text(value));
                        }).toList(),
                        onChanged: (newValue) => setState(() => _cajaSeleccionada = newValue!),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: 'Cajero', border: OutlineInputBorder()),
                        value: _cajeroSeleccionado,
                        items: ['Todos', 'Juan Perez', 'Maria Lopez'].map((String value) {
                          return DropdownMenuItem<String>(value: value, child: Text(value));
                        }).toList(),
                        onChanged: (newValue) => setState(() => _cajeroSeleccionado = newValue!),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _clienteController,
                        decoration: InputDecoration(
                          labelText: 'Cliente',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () {
                              // Logica per cercare il cliente
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _vendedorController,
                        decoration: InputDecoration(
                          labelText: 'Vendedor',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () {
                              // Logica per cercare il venditore
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: 'Moneda', border: OutlineInputBorder()),
                        value: _monedaSeleccionada,
                        items: ['Local', 'Dólares', 'Euros'].map((String value) {
                          return DropdownMenuItem<String>(value: value, child: Text(value));
                        }).toList(),
                        onChanged: (newValue) => setState(() => _monedaSeleccionada = newValue!),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // --- SEZIONE: OPZIONI DEL REPORT ---
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSeccionTitulo('Opciones del Reporte'),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: 'Tipo de Reporte', border: OutlineInputBorder()),
                        value: _tipoReporte,
                        items: ['General', 'Detallado', 'Resumido'].map((String value) {
                          return DropdownMenuItem<String>(value: value, child: Text(value));
                        }).toList(),
                        onChanged: (newValue) => setState(() => _tipoReporte = newValue!),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: 'Agrupar Por', border: OutlineInputBorder()),
                        value: _agruparPor,
                        items: ['Sin Agrupar', 'Fecha', 'Cliente', 'Vendedor'].map((String value) {
                          return DropdownMenuItem<String>(value: value, child: Text(value));
                        }).toList(),
                        onChanged: (newValue) => setState(() => _agruparPor = newValue!),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: 'Detallar Formas de Cobro', border: OutlineInputBorder()),
                        value: _detallarFormasCobro,
                        items: ['No', 'Sí'].map((String value) {
                          return DropdownMenuItem<String>(value: value, child: Text(value));
                        }).toList(),
                        onChanged: (newValue) => setState(() => _detallarFormasCobro = newValue!),
                      ),
                      const SizedBox(height: 8),
                      CheckboxListTile(
                        title: const Text('Folios Cancelados'),
                        value: _foliosCancelados,
                        onChanged: (bool? value) => setState(() => _foliosCancelados = value ?? false),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      ),
                      CheckboxListTile(
                        title: const Text('Sin Cobro (PPD)'),
                        value: _sinCobro,
                        onChanged: (bool? value) => setState(() => _sinCobro = value ?? false),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      ),
                      CheckboxListTile(
                        title: const Text('Solo Devoluciones'),
                        value: _soloDevoluciones,
                        onChanged: (bool? value) => setState(() => _soloDevoluciones = value ?? false),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // --- SEZIONE: SCADENZA ---
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSeccionTitulo('Vencimiento'),
                      TextFormField(
                        controller: _diasVencimientoController,
                        decoration: const InputDecoration(
                          labelText: 'Días Vencimiento',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: CheckboxListTile(
                              title: const Text('Menor', style: TextStyle(fontSize: 13)),
                              value: _chkMenor,
                              onChanged: (bool? value) {
                                setState(() {
                                  _chkMenor = value ?? false;
                                  if (_chkMenor) {
                                    _chkIgual = false;
                                    _chkMayor = false;
                                  }
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                          Expanded(
                            child: CheckboxListTile(
                              title: const Text('Igual', style: TextStyle(fontSize: 13)),
                              value: _chkIgual,
                              onChanged: (bool? value) {
                                setState(() {
                                  _chkIgual = value ?? false;
                                  if (_chkIgual) {
                                    _chkMenor = false;
                                    _chkMayor = false;
                                  }
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                          Expanded(
                            child: CheckboxListTile(
                              title: const Text('Mayor', style: TextStyle(fontSize: 13)),
                              value: _chkMayor,
                              onChanged: (bool? value) {
                                setState(() {
                                  _chkMayor = value ?? false;
                                  if (_chkMayor) {
                                    _chkMenor = false;
                                    _chkIgual = false;
                                  }
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Pulsante di Azione
              ElevatedButton.icon(
                onPressed: () {
                  // Logica per generare il report
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Generando reporte...')),
                  );
                },
                icon: const Icon(Icons.print),
                label: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Text('Generar Reporte', style: TextStyle(fontSize: 16)),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}