import 'package:flutter/material.dart';

import 'main.dart';

class EntradaLogueadoScreen extends StatelessWidget {
  static const routeName = '/entradaLogueado';
  final String nombre;

  const EntradaLogueadoScreen({required this.nombre});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Bienvenido $nombre'),
          ),
          body: Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/img4.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: 'logo',
                  child: Image.asset(
                    'assets/logo.png',
                    height: 150,
                  ),
                ),
                SizedBox(height: 20),
                Text('Bienvenido $nombre'),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Acción del botón "Modificar perfil"
                  },
                  child: Text('Modificar perfil'),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, HomePage.routeName);
                  },
                  child: Text('Cronograma de pago'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}







