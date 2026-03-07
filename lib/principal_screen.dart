import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PrincipalScreen extends StatefulWidget {
  const PrincipalScreen({super.key});

  @override
  State<PrincipalScreen> createState() => _PrincipalScreenState();
}

class _PrincipalScreenState extends State<PrincipalScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Center(child: Text('Pantalla de Configuración', style: TextStyle(fontSize: 24))),
    Center(child: Text('Pantalla de Ventas', style: TextStyle(fontSize: 24))),
    Center(child: Text('Pantalla de Inventarios', style: TextStyle(fontSize: 24))),
  ];

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
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.shopping_cart),
                title: const Text('Compras'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.precision_manufacturing),
                title: const Text('Producción'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.people),
                title: const Text('CRM'),
                onTap: () => Navigator.pop(context),
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
        title: const Text('SuperADMINISTRADOR'),
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
                    content: const Text('¿Estas seguro de salir de SuperADMINISTRADOR?'),
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
            icon: Icon(Icons.settings),
            label: 'Configuración',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sell),
            label: 'Ventas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Inventarios',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Más',
          ),
        ],
        type: BottomNavigationBarType.fixed, // Asegura que los 4 elementos se vean bien
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
