import 'package:flutter/material.dart';
import 'config_app_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    // Aquí es donde se conectarán los endpoints más adelante.
    final username = _usernameController.text;
    final password = _passwordController.text;
    
    debugPrint('Intento de inicio de sesión - Usuario: $username');
    
    // Por ahora, solo mostramos un aviso visual simple
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Iniciando sesión... (Endpoints pendientes)')),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Tomamos el color primario del tema (#205599 configurado en main)
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Icono o Logo de la aplicación
                Image.asset(
                  'assets/logo.png',
                  height: 120,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 32),
                
                // Título
                const Text(
                  'Bienvenido',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Ingresa tus credenciales para continuar',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                
                // Campo de Usuario
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Usuario',
                    hintText: 'ej. juanperez',
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 20),
                
                // Campo de Contraseña
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _handleLogin(),
                ),
                const SizedBox(height: 40),
                
                // Botón de Inicio de Sesión
                ElevatedButton(
                  onPressed: _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'INICIAR SESIÓN',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // Botón flotante para acceder a la configuración
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const ConfigAppScreen(),
            ),
          );
        },
        backgroundColor: Theme.of(context).colorScheme.secondary, // Variante clara del color primario
        foregroundColor: Colors.white,
        tooltip: 'Configuración',
        elevation: 4,
        child: const Icon(Icons.settings),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
