import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'entradaLogueado.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class Usuario {
  @HiveField(0)
  final String nombre;
  @HiveField(1)
  final String correo;
  @HiveField(2)
  final String contrasena;
  @HiveField(3)
  final String ruc;
  @HiveField(4)
  final String dni;
  @HiveField(5)
  final String telefono;

  Usuario({
    required this.nombre,
    required this.correo,
    required this.contrasena,
    required this.ruc,
    required this.dni,
    required this.telefono,
  });
}

@HiveType(typeId: 1)
class UsuarioAdapter extends TypeAdapter<Usuario> {
  @override
  final int typeId = 0;

  @override
  Usuario read(BinaryReader reader) {
    return Usuario(
      nombre: reader.readString(),
      correo: reader.readString(),
      contrasena: reader.readString(),
      ruc: reader.readString(),
      dni: reader.readString(),
      telefono: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, Usuario obj) {
    writer.writeString(obj.nombre);
    writer.writeString(obj.correo);
    writer.writeString(obj.contrasena);
    writer.writeString(obj.ruc);
    writer.writeString(obj.dni);
    writer.writeString(obj.telefono);
  }
}

class RegistroScreen extends StatefulWidget {
  static const routeName = '/registro';

  @override
  _RegistroScreenState createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _correoController = TextEditingController();
  final _contrasenaController = TextEditingController();
  final _rucController = TextEditingController();
  final _dniController = TextEditingController();
  final _telefonoController = TextEditingController();

  Future<void> _guardarUsuario(BuildContext context) async {
    final nombre = _nombreController.text;
    final correo = _correoController.text;
    final contrasena = _contrasenaController.text;
    final ruc = _rucController.text;
    final dni = _dniController.text;
    final telefono = _telefonoController.text;

    Hive.registerAdapter<Usuario>(UsuarioAdapter());

    try {
      final box = await Hive.openBox<Usuario>('usuarios');
      final usuario = Usuario(
        nombre: nombre,
        correo: correo,
        contrasena: contrasena,
        ruc: ruc,
        dni: dni,
        telefono: telefono,
      );
      await box.add(usuario);
      await box.close();
    } catch (e) {
      print('Error al abrir o cerrar la caja de Hive: $e');
      // Puedes mostrar una notificación o un diálogo de error aquí si lo deseas
      return;
    }

    Navigator.pushNamed(
      context,
      EntradaLogueadoScreen.routeName,
      arguments: {
        'nombre': nombre,
        'dni': dni,
        'correo': correo,
        'telefono': telefono,
        'ruc': ruc,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro'),
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
                              controller: _correoController,
                              decoration: InputDecoration(labelText: 'Correo'),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Ingrese su correo';
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
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 200.0),
                            child: TextFormField(
                              controller: _rucController,
                              decoration: InputDecoration(labelText: 'RUC'),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Ingrese su RUC';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 200.0),
                            child: TextFormField(
                              controller: _dniController,
                              decoration: InputDecoration(labelText: 'DNI'),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Ingrese su DNI';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 200.0),
                            child: TextFormField(
                              controller: _telefonoController,
                              decoration: InputDecoration(labelText: 'Teléfono'),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Ingrese su teléfono';
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
                      _guardarUsuario(context);
                    }
                  },
                  child: Text('Registrarte'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}