import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

  Usuario({
    required this.nombre,
    required this.correo,
    required this.contrasena,
  });
}



@HiveType(typeId: 1) // Agrega esta anotación para el adaptador

class UsuarioAdapter extends TypeAdapter<Usuario> {
  @override
  final int typeId = 0;

  @override
  Usuario read(BinaryReader reader) {
    return Usuario(
      nombre: reader.readString(),
      correo: reader.readString(),
      contrasena: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, Usuario obj) {
    writer.writeString(obj.nombre);
    writer.writeString(obj.correo);
    writer.writeString(obj.contrasena);
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

  Future<void> _guardarUsuario(BuildContext context) async {
    final nombre = _nombreController.text;
    final correo = _correoController.text;
    final contrasena = _contrasenaController.text;

    Hive.registerAdapter<Usuario>(UsuarioAdapter());
    final box = await Hive.openBox<Usuario>('usuarios');
    final usuario = Usuario(
      nombre: nombre,
      correo: correo,
      contrasena: contrasena,
    );
    await box.add(usuario);

    await box.close();

    Navigator.of(context).pushNamed(EntradaLogueadoScreen.routeName,arguments: nombre);
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