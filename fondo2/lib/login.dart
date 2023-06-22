import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'entradaLogueado.dart';
import 'package:hive/hive.dart';

class Usuario {
  final String nombre;
  final String contrasena;

  Usuario({
    required this.nombre,
    required this.contrasena,
  });
}

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _contrasenaController = TextEditingController();

  Future<void> _verificarUsuario(BuildContext context) async {
    final nombre = _nombreController.text;
    final contrasena = _contrasenaController.text;

    // Open the Hive box for users
    final box = await Hive.openBox('usuarios');

    // Get the user object from Hive box
    final usuario = box.values.firstWhere(
          (user) => user.nombre == nombre && user.contrasena == contrasena,
      orElse: () => null,
    );

    if (usuario != null) {
      // Usuario autenticado correctamente
      Navigator.of(context).pushNamed(
        EntradaLogueadoScreen.routeName,
        arguments: {'nombre': usuario.nombre},
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Error de inicio de sesión'),
          content: Text('El usuario o la contraseña son incorrectos.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('Aceptar'),
            ),
          ],
        ),
      );
    }

    // Close the Hive box
    await box.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio de sesión'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/imglog.png'),
            fit: BoxFit.cover,
            colorFilter:
            ColorFilter.mode(Colors.green.withOpacity(0.4), BlendMode.dstATop),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Colors.lightGreen.withOpacity(0.5),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 200.0),
                          child: TextFormField(
                            controller: _nombreController,
                            decoration: InputDecoration(labelText: 'Nombre'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Ingrese su nombre';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 200.0),
                          child: TextFormField(
                            controller: _contrasenaController,
                            decoration: InputDecoration(labelText: 'Contraseña'),
                            obscureText: true,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Ingrese su contraseña';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _verificarUsuario(context);
                    }
                  },
                  child: Text('Ingresar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}