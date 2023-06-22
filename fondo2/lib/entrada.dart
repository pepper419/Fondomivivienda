import 'package:flutter/material.dart';
import 'entradaLogueado.dart';
import 'main.dart';
import 'registro.dart';
import 'login.dart';

class EntradaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fondo MiVivienda',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Montserrat',
      ),
      home: EntradaScreen(),
      routes: {
        '/home': (ctx) => HomePage(),
        '/entradaLogueado': (ctx) => EntradaLogueadoScreen(nombre: '',),
        RegistroScreen.routeName: (ctx) => RegistroScreen(),
        LoginScreen.routeName: (ctx) => LoginScreen(),
      },
    );
  }
}

class EntradaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Fondo MiVivienda',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/img4.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          Positioned.fill(
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
                Text(
                  '¡Bienvenido a Fondo MiVivienda!',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 40),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(RegistroScreen.routeName);
                        },
                        child: Text(
                          'Registrarse',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(LoginScreen.routeName);
                        },
                        child: Text(
                          'Iniciar sesión',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: Image.asset(
              'assets/img1.png',
              height: 100,
            ),
          ),
          Positioned(
            bottom: 50,
            left: 20,
            child: Image.asset(
              'assets/img2.png',
              height: 80,
            ),
          ),
          Positioned(
            top: 30,
            right: 20,
            child: Image.asset(
              'assets/img3.png',
              height: 80,
            ),
          ),
        ],
      ),
    );
  }
}







