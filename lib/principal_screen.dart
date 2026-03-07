import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:openclaw_test/presentation/screens/menu/compras_screen.dart';
import 'package:openclaw_test/presentation/screens/menu/configuracion_screen.dart';
import 'package:openclaw_test/presentation/screens/menu/crm_screen.dart';
import 'package:openclaw_test/presentation/screens/menu/cxc_screen.dart';
import 'package:openclaw_test/presentation/screens/menu/home_screen.dart';
import 'package:openclaw_test/presentation/screens/menu/inventarios_screen.dart';
import 'package:openclaw_test/presentation/screens/menu/produccion_screen.dart';
import 'package:openclaw_test/presentation/screens/menu/ventas_screen.dart';

class PrincipalScreen extends StatefulWidget {
  const PrincipalScreen({super.key});

  @override
  State<PrincipalScreen> createState() => _PrincipalScreenState();
}

class _PrincipalScreenState extends State<PrincipalScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      HomePrincipalScreen(),
      VentasScreen(), // Reemplazado por el ListView de Ventas
      InventariosScreen(), // Reemplazado por el ListView de Inventarios
    ];
  }


  void _onItemTapped(int index) {
    if (index == 3) {
      // Si es el índice del botón "+", mostramos el menú de abajo hacia arriba
      _showMoreMenu(context);
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

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
              ListTile(
                leading: const Icon(Icons.account_balance_wallet),
                title: const Text('Cuentas por Cobrar'),
                onTap: () {
                  Navigator.pop(context); // Cierra el menú inferior
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CxcScreen()),
                  ); // Navega a la nueva pantalla
                },
              ),
              ListTile(
                leading: const Icon(Icons.shopping_cart),
                title: const Text('Compras'),
                onTap: () {
                  Navigator.pop(context); // Cierra el menú inferior
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ComprasScreen()),
                  ); // Navega a la nueva pantalla
                },
              ),
              ListTile(
                leading: const Icon(Icons.precision_manufacturing),
                title: const Text('Producción'),
                onTap: () {
                  Navigator.pop(context); // Cierra el menú inferior
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProduccionScreen()),
                  ); // Navega a la nueva pantalla
                },
              ),
              ListTile(
                leading: const Icon(Icons.people),
                title: const Text('CRM'),
                onTap: () {
                  Navigator.pop(context); // Cierra el menú inferior
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CrmScreen()),
                  ); // Navega a la nueva pantalla
                },
              ),
               ListTile(
                leading: const Icon(Icons.toggle_off),
                title: const Text('Configuración'),
                onTap: () {
                  Navigator.pop(context); // Cierra el menú inferior
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ConfiguracionScreen()),
                  ); // Navega a la nueva pantalla
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/logo.png',
              height: 32, // Tamaño ajustable
            ),
            const SizedBox(width: 10),
            const Text('SuperADMINISTRADOR'),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Confirmar'),
                    content: const Text(
                      '¿Estas seguro de salir de SuperADMINISTRADOR?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('No'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Aquí puedes cerrar la sesión o salir de la app
                          SystemNavigator.pop(); // Sale de la aplicación
                        },
                        child: const Text('Sí'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.sell), label: 'Ventas'),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Inventarios',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Más',
          ),
        ],
        type: BottomNavigationBarType
            .fixed, // Asegura que los 4 elementos se vean bien
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
