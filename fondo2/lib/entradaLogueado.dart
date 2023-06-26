import 'package:flutter/material.dart';
import 'main.dart';

class EntradaLogueadoScreen extends StatelessWidget {
  final String nombre;
  final String dni;
  final String correo;
  final String telefono;
  final String ruc;

  const EntradaLogueadoScreen({
    required this.nombre,
    required this.dni,
    required this.correo,
    required this.telefono,
    required this.ruc,
  });
  static const routeName = '/entradaLogueado';

  @override
  Widget build(BuildContext context) {
    final Map<String, String>? arguments =
    ModalRoute.of(context)?.settings.arguments as Map<String, String>?;

    final String nombre = arguments?['nombre'] ?? '';
    final String dni = arguments?['dni'] ?? '';
    final String correo = arguments?['correo'] ?? '';
    final String telefono = arguments?['telefono'] ?? '';
    final String ruc = arguments?['ruc'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido $nombre'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img4.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.6), BlendMode.darken),
          ),
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(0, 0, 0, 0.5),
              Color.fromRGBO(0, 0, 0, 0.8)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Hero(
              tag: 'logo',
              child: Image.asset('assets/logo.png', height: 100),
            ),
            SizedBox(height: 20),
            Text(
              'Bienvenido $nombre',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, HomePage.routeName);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                  ),
                  child: Text(
                    'Cronograma de pago',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) {
                        return AlertDialog(
                          title: Text(
                            'Modelos de casas',
                            style: TextStyle(color: Colors.green),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              buildHouseItem(
                                  'Casa Personal', '1 cuarto, 1 cocina , 1 baño y 1 comedor', 'assets/casa1.png'),
                              SizedBox(height: 7),
                              buildHouseItem('Casa para 2 personas',
                                  '2 cuarto, 1 cocina , 1 baño y 1 comedor', 'assets/casa2.png'),
                              SizedBox(height: 7),
                              buildHouseItem('Casa para 3 personas',
                                  '3 cuarto, 1 cocina , 2 baño, 1 sala familiar y 1 comedor', 'assets/casa3.png'),
                              SizedBox(height: 7),
                              buildHouseItem(
                                  'Casa Familiar', '4 cuarto, 1 cocina , 3 baño, 1 sala familiar y 1 comedor', 'assets/casa4.png'),
                            ],
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(ctx).pop();
                              },
                              child: Text(
                                'Cerrar',
                                style: TextStyle(color: Colors.green),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Column(
                    children: [
                      Image.asset('assets/casaicon.png', height: 60),
                      SizedBox(height: 5),
                      Text(
                        '',
                        style: TextStyle(
                          color: Colors.black,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) {
                    double? dolarAmount;
                    double? solAmount;

                    return AlertDialog(
                      title: Text(
                        'Verificar el cambio de moneda',
                        style: TextStyle(color: Colors.blue),
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Image.asset('assets/billetedolares.png', height: 30),
                              SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  onChanged: (value) {
                                    dolarAmount = double.tryParse(value);
                                  },
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Monto en dólares',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Image.asset('assets/billetesoles.png', height: 30),
                              SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  onChanged: (value) {
                                    solAmount = double.tryParse(value);
                                  },
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Monto en soles',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                          child: Text(
                            'Cerrar',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            if (dolarAmount != null) {
                              final convertedAmount = dolarAmount! * 3.6;
                              showDialog(
                                context: context,
                                builder: (ctx) {
                                  return AlertDialog(
                                    title: Text(
                                      'Resultado',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                    content: Text(
                                      '$dolarAmount dólares equivale a $convertedAmount soles.',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(ctx).pop();
                                        },
                                        child: Text(
                                          'Cerrar',
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else if (solAmount != null) {
                              final convertedAmount = solAmount! / 3.8;
                              showDialog(
                                context: context,
                                builder: (ctx) {
                                  return AlertDialog(
                                    title: Text(
                                      'Resultado',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                    content: Text(
                                      '$solAmount soles equivale a $convertedAmount dólares.',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(ctx).pop();
                                        },
                                        child: Text(
                                          'Cerrar',
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          child: Text(
                            'Convertir',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.yellow,
              ),
              child: Text(
                'Verificar el cambio de moneda',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            SizedBox(height: 20),
            Image.asset('assets/img2.png', height: 200),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Image.asset('assets/img1.png', height: 250),
                ),
                Expanded(
                  child: Image.asset('assets/img3.png', height: 250),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Card(
                      color: Colors.black.withOpacity(0.8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Resumen del usuario:',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Nombre: $nombre',
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'DNI: $dni',
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Correo: $correo',
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Teléfono: $telefono',
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'RUC: $ruc',
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

Widget buildHouseItem(String name, String value, String imagePath) {
  return Row(
    children: [
      Image.asset(imagePath, height: 170),
      SizedBox(width: 10),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ],
      ),
    ],
  );
}






