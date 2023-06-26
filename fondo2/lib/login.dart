import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'entradaLogueado.dart';
import 'package:hive/hive.dart';
import 'entradaLogueado.dart';

import 'registro.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _contrasenaController = TextEditingController();

  Future<void> _iniciarSesion(BuildContext context) async {
    final nombre = _nombreController.text;
    final contrasena = _contrasenaController.text;

    try {
      final box = await Hive.openBox<Usuario>('usuarios');
      final List<Usuario> usuarios = box.values.toList();

      final Usuario usuarioEncontrado = usuarios.firstWhere(
            (usuario) => usuario.nombre == nombre && usuario.contrasena == contrasena,
        orElse: () => throw Exception('Credenciales incorrectas'),
      );

      await box.close();

      if (usuarioEncontrado != null) {
        Navigator.of(context).pushNamed(
          EntradaLogueadoScreen.routeName,
          arguments: {
            'nombre': usuarioEncontrado.nombre,
            'dni': usuarioEncontrado.dni,
            'correo': usuarioEncontrado.correo,
            'telefono': usuarioEncontrado.telefono,
            'ruc': usuarioEncontrado.ruc,
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Inicio de sesión fallido'),
            content: Text('Usuario o contraseña incorrectos.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text('Aceptar'),
              ),
            ],
          ),
        );
      }
    }
    catch (e) {
      print('Error al abrir o cerrar la caja de Hive: $e');
      // Puedes mostrar una notificación o un diálogo de error aquí si lo deseas
      return;
    }
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
            colorFilter: ColorFilter.mode(
              Colors.green.withOpacity(0.4),
              BlendMode.dstATop,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
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
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Colors.lightGreen.withOpacity(0.5),
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(10),
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
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _iniciarSesion(context);
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