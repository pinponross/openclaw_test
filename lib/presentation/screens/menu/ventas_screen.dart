import 'package:flutter/material.dart';
import 'package:openclaw_test/presentation/screens/ventas/consulta_por_articulo.dart';   
import '../ventas/diario_de_ventas_screen.dart';

class VentasScreen extends StatefulWidget {
  const VentasScreen({super.key});

  

  @override
  State<VentasScreen> createState() => _VentasScreenState();
}

class _VentasScreenState extends State<VentasScreen> {
  // Lista de items para la pestaña de Ventas
  final List<Map<String, dynamic>> _ventasItems = [
    {'title': 'Emitir Comprobantes', 'icon': Icons.payments}, // Billetes
    {'title': 'Diario de Ventas', 'icon': Icons.content_copy}, // Copy
    {'title': 'Consulta por Articulo', 'icon': Icons.content_paste}, // Paste
    {'title': 'Firma de Entrega', 'icon': Icons.draw}, // Mano firmando
    {'title': 'Firma por Devolución', 'icon': Icons.undo}, // Deshacer
    {'title': 'Realizar Encuesta', 'icon': Icons.list_alt}, // Hoja con lineas
  ];


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _ventasItems.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(_ventasItems[index]['icon'], color: Theme.of(context).colorScheme.primary),
          title: Text(_ventasItems[index]['title']),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            if (_ventasItems[index]['title'] == 'Diario de Ventas') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DiarioDeVentasScreen(),
                ),
              );
            }

            if (_ventasItems[index]['title'] == 'Consulta por Articulo') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ConsultaPorArticuloScreen(),
                ),
              );
            }



          },
        );
      },
    );
  }
} 