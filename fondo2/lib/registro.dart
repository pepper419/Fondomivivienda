import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/widgets.dart';
import 'entradaLogueado.dart';

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

    // Crea la base de datos o abre la existente
    final database = await openDatabase(
      join(await getDatabasesPath(), 'usuarios.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE usuarios(id INTEGER PRIMARY KEY AUTOINCREMENT, nombre TEXT, correo TEXT, contrasena TEXT)',
        );
      },
      version: 1,
    );

    // Inserta el usuario en la base de datos
    await database.insert(
      'usuarios',
      {'nombre': nombre, 'correo': correo, 'contrasena': contrasena},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    Navigator.of(context).pushNamed(EntradaLogueadoScreen.routeName);

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
            colorFilter: ColorFilter.mode(Colors.green.withOpacity(0.4), BlendMode.dstATop),
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
                elevation: 4, // Añade una sombra al card
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Borde redondeado
                ),
                color: Colors.lightGreen.withOpacity(0.5), // Color verde claro transparente
                child: InkWell(
                  onTap: () {
                    // Acción al hacer clic en el card
                  },
                  borderRadius: BorderRadius.circular(10), // Borde redondeado para el efecto hover
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
                      Builder(
                        builder: (context) {
                          _guardarUsuario(context);
                          return SizedBox.shrink(); // Opcionalmente, puedes retornar un widget invisible aquí
                        },
                      );
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