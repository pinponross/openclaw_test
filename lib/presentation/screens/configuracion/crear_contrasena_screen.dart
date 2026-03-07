import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';

class CrearContrasenaScreen extends StatefulWidget {
  final bool solicitarCliente; // Recibido como parámetro, equivalente al Intent en Android

  const CrearContrasenaScreen({
    super.key, 
    this.solicitarCliente = false,
  });

  @override
  State<CrearContrasenaScreen> createState() => _CrearContrasenaScreenState();
}

class _CrearContrasenaScreenState extends State<CrearContrasenaScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controladores de texto
  final TextEditingController _contrasenaActualController = TextEditingController();
  final TextEditingController _contrasenaTemporalController = TextEditingController();
  final TextEditingController _claveClienteController = TextEditingController();
  final TextEditingController _importeFacturaController = TextEditingController();

  int _randomNum = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _generarContrasena();
  }

  @override
  void dispose() {
    _contrasenaActualController.dispose();
    _contrasenaTemporalController.dispose();
    _claveClienteController.dispose();
    _importeFacturaController.dispose();
    super.dispose();
  }

  // Equivalente a GenerarContrasena() en Java
  void _generarContrasena() {
    setState(() {
      _randomNum = Random().nextInt(9000) + 1000;
      _contrasenaTemporalController.text = _randomNum.toString();
    });
  }

  // Equivalente a clicAceptar() en Java
  Future<void> _clicAceptar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Construcción del objeto JSON equivalente al del Java
      Map<String, dynamic> obj = {
        "ContrasenaActual": _contrasenaActualController.text,
        "ContrasenaTemporal": _randomNum,
      };

      if (widget.solicitarCliente) {
        obj["Cliente"] = {"Clave": _claveClienteController.text};
        obj["Importe"] = _importeFacturaController.text;
      }

      // Simulación de AjaxRequest y Base64 encoding
      String jsonString = jsonEncode(obj);
      String json64 = base64Encode(utf8.encode(jsonString));

      // Aquí iría la llamada real a tu API (AjaxRequest)
      await Future.delayed(const Duration(seconds: 2)); // Simulación de red

      // Simulación de respuesta exitosa
      if (!mounted) return;
      
      _mostrarAlerta(
        "Éxito", 
        "Se Generó la Contraseña Temporal $_randomNum para Autorizar.",
        onConfirm: () => Navigator.of(context).pop(), // Cierra la pantalla
      );

    } catch (e) {
      _mostrarAlerta("Error", "Ocurrió un error al procesar la solicitud.");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _mostrarAlerta(String titulo, String mensaje, {VoidCallback? onConfirm}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(titulo),
        content: Text(mensaje),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (onConfirm != null) onConfirm();
            },
            child: const Text("Aceptar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Contraseña'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Contraseña Temporal para Autorización",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  
                  // Campo Contraseña Temporal (Solo lectura como en Android)
                  TextFormField(
                    controller: _contrasenaTemporalController,
                    readOnly: true,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blue),
                    decoration: const InputDecoration(
                      labelText: "Temporal",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Campo Contraseña Actual
                  TextFormField(
                    controller: _contrasenaActualController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Contraseña Actual",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                    ),
                    validator: (value) => (value == null || value.isEmpty) ? "Requerido" : null,
                  ),

                  // Sección de Cliente (Condicional según solicitarCliente)
                  if (widget.solicitarCliente) ...[
                    const SizedBox(height: 20),
                    const Divider(),
                    const Text("Datos del Cliente", style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _claveClienteController,
                      decoration: const InputDecoration(
                        labelText: "Clave Cliente",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) => (value == null || value.isEmpty) ? "Requerido" : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _importeFacturaController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Importe Factura",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                      validator: (value) => (value == null || value.isEmpty) ? "Requerido" : null,
                    ),
                  ],

                  const SizedBox(height: 30),
                  
                  // Botón Generar Otra
                  OutlinedButton.icon(
                    onPressed: _isLoading ? null : _generarContrasena,
                    icon: const Icon(Icons.refresh),
                    label: const Text("Generar Otra"),
                    style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Botón Aceptar
                  ElevatedButton(
                    onPressed: _isLoading ? null : _clicAceptar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text("Aceptar", style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            ),
          ),
          
          // Indicador de carga (Equivalente al BusyIndicator)
          if (_isLoading)
            Container(
              color: Colors.black26,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}