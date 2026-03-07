import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class RealizarEncuestaScreen extends StatefulWidget {
  const RealizarEncuestaScreen({super.key});

  @override
  State<RealizarEncuestaScreen> createState() => _RealizarEncuestaScreenState();
}

class _RealizarEncuestaScreenState extends State<RealizarEncuestaScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controladores de texto para los campos de la encuesta
  final TextEditingController _serieController = TextEditingController();
  final TextEditingController _folioController = TextEditingController();
  final TextEditingController _clienteController = TextEditingController();
  final TextEditingController _choferController = TextEditingController();
  final TextEditingController _vehiculoController = TextEditingController();
  final TextEditingController _claveEncuestaController = TextEditingController();

  // Variables para el manejo de la firma
  List<Offset?> _points = <Offset?>[];
  final GlobalKey _boundaryKey = GlobalKey();
  
  bool _isLoading = false;

  @override
  void dispose() {
    _serieController.dispose();
    _folioController.dispose();
    _clienteController.dispose();
    _choferController.dispose();
    _vehiculoController.dispose();
    _claveEncuestaController.dispose();
    super.dispose();
  }

  // Método para limpiar el lienzo de firma (clicLimpiar en Java)
  void _limpiarFirma() {
    setState(() {
      _points.clear();
    });
  }

  // Simulación de validación de comprobante (clicValidarComprobante en Java)
  Future<void> _validarComprobante() async {
    if (_serieController.text.isEmpty || _folioController.text.isEmpty) {
      _mostrarAlerta("Aviso", "Indique Serie y Folio para validar.");
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Simulación de petición a "Ventas/VerificarComprobanteFirmadoExiste"
      await Future.delayed(const Duration(seconds: 1));
      
      // Simulación de respuesta exitosa
      _mostrarAlerta("Validación", "Comprobante verificado correctamente.");
    } catch (e) {
      _mostrarAlerta("Error", "Ocurrió un error al verificar el comprobante.");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Método para guardar la encuesta y la firma (EnviarFirmaAtravesdeAjax en Java)
  Future<void> _guardarEncuesta() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_points.isEmpty) {
      _mostrarAlerta("Aviso", "Por favor, firme la encuesta antes de guardar.");
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Capturar la firma como imagen
      RenderRepaintBoundary? boundary = _boundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      ui.Image image = await boundary!.toImage(pixelRatio: 2.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      String base64Firma = base64Encode(pngBytes);

      // Crear el objeto de envío (equivalente al JSONObject en Java)
      Map<String, dynamic> encuestaData = {
        "Serie": _serieController.text,
        "Folio": _folioController.text,
        "NombreCliente": _clienteController.text,
        "NombreChofer": _choferController.text,
        "NombreVehiculo": _vehiculoController.text,
        "ClaveEncuesta": _claveEncuestaController.text,
        "FirmaBase64": base64Firma,
      };

      // Simulación de petición Ajax a "Ventas/EstablecerFirmaDeEncuestaSatisfaccion"
      print("Enviando encuesta: ${jsonEncode(encuestaData)}");
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;
      _mostrarAlerta("Éxito", "Encuesta de satisfacción guardada correctamente.", onConfirm: () {
        Navigator.of(context).pop();
      });
    } catch (e) {
      _mostrarAlerta("Error", "Error al procesar la encuesta: $e");
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
        title: const Text('Encuesta de Satisfacción'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- Sección del Comprobante ---
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _serieController,
                          decoration: const InputDecoration(labelText: "Serie", border: OutlineInputBorder()),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: _folioController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: "Folio", border: OutlineInputBorder()),
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton.filled(
                        onPressed: _isLoading ? null : _validarComprobante,
                        icon: const Icon(Icons.check_circle_outline),
                        tooltip: "Validar",
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // --- Datos de la Encuesta ---
                  TextFormField(
                    controller: _clienteController,
                    decoration: const InputDecoration(labelText: "Nombre Cliente", border: OutlineInputBorder(), prefixIcon: Icon(Icons.person)),
                    validator: (v) => v!.isEmpty ? "Campo Requerido" : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _choferController,
                    decoration: const InputDecoration(labelText: "Nombre Chofer", border: OutlineInputBorder(), prefixIcon: Icon(Icons.local_shipping)),
                    validator: (v) => v!.isEmpty ? "Campo Requerido" : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _vehiculoController,
                    decoration: const InputDecoration(labelText: "Vehículo", border: OutlineInputBorder(), prefixIcon: Icon(Icons.directions_car)),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _claveEncuestaController,
                    decoration: const InputDecoration(labelText: "Clave Encuesta", border: OutlineInputBorder(), prefixIcon: Icon(Icons.assignment)),
                  ),
                  
                  const SizedBox(height: 20),
                  const Text("Firma de Conformidad:", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  
                  // --- Lienzo de Firma ---
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      color: Colors.white,
                    ),
                    child: RepaintBoundary(
                      key: _boundaryKey,
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          setState(() {
                            RenderBox object = context.findRenderObject() as RenderBox;
                            Offset localPosition = object.globalToLocal(details.globalPosition);
                            _points.add(localPosition);
                          });
                        },
                        onPanEnd: (_) => _points.add(null),
                        child: CustomPaint(
                          painter: SignaturePainter(points: _points),
                          size: Size.infinite,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // --- Botones de Acción ---
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _limpiarFirma,
                          icon: const Icon(Icons.delete_outline),
                          label: const Text("LIMPIAR"),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isLoading ? null : _guardarEncuesta,
                          icon: const Icon(Icons.save),
                          label: const Text("GUARDAR"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.white,
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
          if (_isLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}

class SignaturePainter extends CustomPainter {
  final List<Offset?> points;
  SignaturePainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(SignaturePainter oldDelegate) => true;
}