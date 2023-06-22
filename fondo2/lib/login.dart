import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/login';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio de sesión'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/imglog.png'), // Reemplaza con la ruta de tu imagen de fondo
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Text('Pantalla de inicio de sesión'),
        ),
      ),
    );
  }
}