import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() => runApp(FondoMiviviendaApp());

class FondoMiviviendaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fondo Mivivienda',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class CronogramaPago {
  final DateTime fecha;
  final double cuota;
  final double intereses;
  final double amortizacion;
  final double saldoPendiente;

  CronogramaPago({
    required this.fecha,
    required this.cuota,
    required this.intereses,
    required this.amortizacion,
    required this.saldoPendiente,
  });
}

class _HomePageState extends State<HomePage> {

  final TextEditingController montoController = TextEditingController();
  final TextEditingController tasaController = TextEditingController();
  final TextEditingController plazoController = TextEditingController();
  final TextEditingController porcentajeController = TextEditingController();
  final TextEditingController plazo2Controller = TextEditingController();
  final TextEditingController desgravamenController = TextEditingController();

  double descuento = 0.0;

  List<DataRow> pagosRows = [];
   int estatic = 1;

  String resultado = '';

  void calcularCronograma() {
    estatic = 1;
    // Cálculos del cronograma de pagos utilizando el método francés
    double v = 0.0;
    double montoPrestamo = double.parse(montoController.text);
    double tasaInteresAnual = double.parse(tasaController.text);
    descuento = double.parse(montoController.text) * double.parse(porcentajeController.text) / 100;
    double saldoesta = montoPrestamo - descuento ;
    int plazoPrestamo = int.parse(plazoController.text);
    double tasaInteresMensual = (math.pow(1 + (tasaInteresAnual/100), 1/12) - 1);
    //double tasaInteresMensual = tasaInteresAnual / 12 / 100;
    double saldo = 0.0;
    saldo = saldoesta;

    double Seg_Des = double.parse(desgravamenController.text)/100;
    //double cuotaMensual = (montoPrestamo * tasaInteresMensual) / (1 - math.pow(1 + tasaInteresMensual, -plazoPrestamo));



    int plazo = int.parse(plazo2Controller.text);



    pagosRows.clear();


    for (int i = 0; i < plazoPrestamo; i++) {
      double intereses = saldo * tasaInteresMensual;
      double cuotaMensual = plazo > i ? 0.0 : saldoesta * ((tasaInteresMensual*math.pow(1+tasaInteresMensual,plazoPrestamo- estatic +1))/(math.pow(1+tasaInteresMensual,plazoPrestamo - estatic +1 )-1));
      double amortizacion =  cuotaMensual - intereses;
      if (i < plazo) {
        saldoesta -= amortizacion ;
        estatic++;
      }
      saldo = plazo > i ? saldo + intereses : saldo - amortizacion  ;
      double amortizacionValue = plazo > i ? 0.0 : amortizacion;
       double periodo = i+1;
      DateTime fechaPago = DateTime.now().add(Duration(days: i * 30)); // Ejemplo: fecha de pago cada 30 días

      DataRow row = DataRow(
        cells: [
          DataCell(Text(periodo.toString())),
          DataCell(Text(fechaPago.toString())),
          DataCell(Text(cuotaMensual.toStringAsFixed(2))),
          DataCell(Text(intereses.toStringAsFixed(2))),
          DataCell(Text(amortizacionValue.toStringAsFixed(2))),
          DataCell(Text(saldo.toStringAsFixed(2))),
          DataCell(Text(Seg_Des.toStringAsFixed(2))),
        ],
      );
      pagosRows.add(row);
    }
    setState(() {
      resultado = 'Cronograma de pagos';
    });
  }

  void limpiarCampos() {
    montoController.clear();
    tasaController.clear();
    plazoController.clear();

    setState(() {
      resultado = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fondo Mivivienda'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ingrese los datos para generar el cronograma de pagos:',
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: montoController,
                decoration: InputDecoration(labelText: 'Monto del préstamo')
              ),
              TextField(
                  controller: porcentajeController,
                  decoration: InputDecoration(labelText: 'Porcentaje de cuota incial'),
              ),
              Row(
                children: [
                  Text('Porcentaje de cuota inicial: '),
                  Text((montoController.text.isNotEmpty && porcentajeController.text.isNotEmpty)
                      ? (double.parse(montoController.text) * double.parse(porcentajeController.text) / 100).toStringAsFixed(2)
                      : '0.00'),
                ],
              ),
              SizedBox(height: 10.0),
              TextField(
                controller: tasaController,
                decoration: InputDecoration(labelText: 'Tasa de interés anual'),
              ),
              SizedBox(height: 10.0),
              TextField(
                controller: plazoController,
                decoration: InputDecoration(labelText: 'Plazo del préstamo (meses)'),
              ),
              TextField(
                controller: plazo2Controller,
                decoration: InputDecoration(labelText: 'Periodo de Amortizacion (meses)'),
              ),
              TextField(
                controller: desgravamenController,
                decoration: InputDecoration(labelText: 'Porcentaje de Seguro desgravamen (anual)'),
              ),
              SizedBox(height: 20.0),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: limpiarCampos,
                    child: Text('Limpiar'),
                  ),
                  SizedBox(width: 10.0),
                  ElevatedButton(
                    onPressed: calcularCronograma,
                    child: Text('Generar Cronograma'),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Text(resultado),
              DataTable(
                columns: [
                  DataColumn(label: Text('Periodo')),
                  DataColumn(label: Text('Fecha')),
                  DataColumn(label: Text('Cuota')),
                  DataColumn(label: Text('Intereses')),
                  DataColumn(label: Text('Amortización')),
                  DataColumn(label: Text('Saldo Final')),
                  DataColumn(label: Text('Seg. Desgrav.')),
                ],
                rows: pagosRows,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
