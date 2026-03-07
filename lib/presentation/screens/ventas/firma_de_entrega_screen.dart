import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class FirmaDeEntregaScreen extends StatefulWidget {
  const FirmaDeEntregaScreen({super.key});

  @override
  State<FirmaDeEntregaScreen> createState() => _FirmaDeEntregaScreenState();
}

class _FirmaDeEntregaScreenState extends State<FirmaDeEntregaScreen> {
  // Lista de puntos para almacenar el trazo de la firma
  List<Offset?> _points = <Offset?>[];
  
  // Clave global para capturar el RepaintBoundary y convertirlo en imagen
  final GlobalKey _boundaryKey = GlobalKey();
  
  bool _isSaving = false;

  // Método para limpiar el lienzo (equivalente a clicLimpiar en Java)
  void _limpiarFirma() {
    setState(() {
      _points.clear();
    });
  }

  // Método para guardar y enviar la firma (equivalente a clicGuardar en Java)
  Future<void> _guardarFirma() async {
    if (_points.isEmpty) {
      _mostrarAlerta("Aviso", "Por favor, realice una firma antes de guardar.");
      return;
    }

    setState(() => _isSaving = true);

    try {
      // Capturar el widget como imagen
      RenderRepaintBoundary? boundary = _boundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;

      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      
      if (byteData != null) {
        Uint8List pngBytes = byteData.buffer.asUint8List();
        
        // Convertir a Base64 (equivalente a la lógica de EnviarFirmaAtravesdeAjax en Java)
        String base64Image = base64Encode(pngBytes);
        
        // Simulación de envío Ajax
        await Future.delayed(const Duration(seconds: 2));

        if (!mounted) return;
        
        _mostrarAlerta(
          "Éxito", 
          "Firma guardada y enviada correctamente.",
          onConfirm: () => Navigator.of(context).pop(),
        );
      }
    } catch (e) {
      _mostrarAlerta("Error", "No se pudo procesar la firma: $e");
    } finally {
      setState(() => _isSaving = false);
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
        title: const Text('Firma de Entrega'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _isSaving ? null : _limpiarFirma,
            tooltip: 'Limpiar',
          ),
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Por favor, firme dentro del recuadro blanco:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade400, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: RepaintBoundary(
                    key: _boundaryKey,
                    child: GestureDetector(
                      onPanUpdate: (DragUpdateDetails details) {
                        setState(() {
                          RenderBox object = context.findRenderObject() as RenderBox;
                          Offset localPosition = object.globalToLocal(details.globalPosition);
                          // Ajuste para que los puntos se dibujen solo dentro del área del lienzo
                          _points.add(localPosition);
                        });
                      },
                      onPanEnd: (DragEndDetails details) {
                        _points.add(null); // Separador de trazos
                      },
                      child: CustomPaint(
                        painter: SignaturePainter(points: _points),
                        size: Size.infinite,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isSaving ? null : _limpiarFirma,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text("LIMPIAR"),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _guardarFirma,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: _isSaving 
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text("GUARDAR"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Clase para dibujar los trazos en el lienzo (Equivalente al dibujo en Canvas del Java)
class SignaturePainter extends CustomPainter {
  final List<Offset?> points;

  SignaturePainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(SignaturePainter oldDelegate) => oldDelegate.points != points;
}