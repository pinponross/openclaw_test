import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'compras_screen.dart';
import 'configuracion_screen.dart';
import 'crm_screen.dart';
import 'cxc_screen.dart';
import 'home_screen.dart';
import 'inventarios_screen.dart';
import 'produccion_screen.dart';
import 'ventas_screen.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  void _showMoreMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildMenuItem(context, Icons.account_balance_wallet, 'Cuentas por Cobrar', const CxcScreen()),
              _buildMenuItem(context, Icons.shopping_cart, 'Compras', const ComprasScreen()),
              _buildMenuItem(context, Icons.precision_manufacturing, 'Producción', const ProduccionScreen()),
              _buildMenuItem(context, Icons.people, 'CRM', const CrmScreen()),
              _buildMenuItem(context, Icons.toggle_off, 'Configuración', const ConfiguracionScreen()),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title, Widget screen) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pop(context); // Cierra bottom sheet
        // Si no estamos ya en esa pantalla, navegamos
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
        BottomNavigationBarItem(icon: Icon(Icons.sell), label: 'Ventas'),
        BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Inventarios'),
        BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: 'Más'),
      ],
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        if (index == 3) {
          _showMoreMenu(context);
        } else {
          onTap(index);
        }
      },
    );
  }
}
