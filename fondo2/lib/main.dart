import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'entrada.dart';

void main() => runApp(FondoMiviviendaApp());

class FondoMiviviendaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fondo Mivivienda',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
      routes: {
        '/entrada': (context) => EntradaScreen(),
      },
      onUnknownRoute: (settings) {
        // Aquí puedes manejar rutas desconocidas o mostrar una pantalla de error
      },
    );
  }
}

class HomePage extends StatefulWidget {
  static const routeName = '/home';
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
  List<Map<String, dynamic>> montoOptions = [
    {"label": "Casa 1", "value": 200000, "image": "assets/casa1.png"},
    {"label": "Casa 2", "value": 320000, "image": "assets/casa2.png"},
    {"label": "Casa 3", "value": 512000, "image": "assets/casa3.png"},
    {"label": "Casa 4", "value": 240560, "image": "assets/casa4.png"}
  ];

  String? selectedMonto;
  String _selectedTasa = 'Tasa Efectiva';
  int tasa = 1;
  int top = 1;
  final TextEditingController montoController = TextEditingController();
  final TextEditingController tasaController = TextEditingController();
  final TextEditingController plazoController = TextEditingController();
  final TextEditingController porcentajeController = TextEditingController();
  final TextEditingController plazo2Controller = TextEditingController();
  final TextEditingController desgravamenController = TextEditingController();
  final TextEditingController seguro_riesgoController = TextEditingController();
  final TextEditingController comisionController = TextEditingController();
  final TextEditingController portesController = TextEditingController();
  final TextEditingController gastosadmiController = TextEditingController();
  final TextEditingController cokController = TextEditingController();

  double descuento = 0.0;

  List<DataRow> pagosRows = [];

   int estatic = 1;


  String resultado = '';

  void calcularCronograma() {



    //Es el periodo en el que se estan calculando las cuotas y va aumentando para recorrer todo el plazo de pagos
    estatic = 1;
    // Cálculos del cronograma de pagos utilizando el método francés
    double v = 0.0;
    double montoPrestamo = double.parse(montoController.text);
    double tasaInteresAnual = double.parse(tasaController.text);
    descuento = double.parse(montoController.text) * double.parse(porcentajeController.text) / 100;
    double saldoesta = montoPrestamo - descuento ;
    int plazoPrestamo = int.parse(plazoController.text)*12;
    double tasaInteresMensual = (tasa==1) ? (math.pow(1 + (tasaInteresAnual/100), 1/12) - 1) : (math.pow(1 + (tasaInteresAnual/100)/360, 30) - 1);
    //double tasaInteresMensual = tasaInteresAnual / 12 / 100;
    double saldo = 0.0;
    //saldo inicial
    double Saldo_inicial=saldoesta;
    saldo = saldoesta;
    //SEGURO DE DESGRAVAMEN
    double Seg_Des = double.parse(desgravamenController.text)/100;
    //Seguro de riesgo
    double seg_riesgo= (double.parse(seguro_riesgoController.text)/100)* double.parse(montoController.text)/12 ;
    //Comision
    double comision= double.parse(comisionController.text);
    //Portes
    double portes= double.parse(portesController.text);
    //Gatos administrativos
    double gastos_admi= double.parse(gastosadmiController.text);
    //FLUJO
    double flujo= 0;
    //COK
    num cok= math.pow(1+ double.parse(cokController.text)/100, 30/360) -1;
    double PorcentajeCOK=cok.toDouble();
    //VAN
    double VAN=Saldo_inicial;
    //double cuotaMensual = (montoPrestamo * tasaInteresMensual) / (1 - math.pow(1 + tasaInteresMensual, -plazoPrestamo));

    //SUMAMOS LA TASA CONVERTIDA A EFECTIVA CON LA TASA DE DESGRAVAMEN


    int plazo = int.parse(plazo2Controller.text);



    pagosRows.clear();


    for (int i = 0; i < plazoPrestamo; i++) {

      if( plazo>i)
        {
          if(i>0 && Saldo_inicial<saldo)
            Saldo_inicial= saldo;
        }
      else
        Saldo_inicial=saldo;

      double intereses = Saldo_inicial * tasaInteresMensual;
      double cuotaMensual = plazo > i ? 0.0 : saldoesta * (((tasaInteresMensual+Seg_Des)*math.pow(1+tasaInteresMensual+Seg_Des,plazoPrestamo- estatic +1)) /
          (math.pow(1+tasaInteresMensual+Seg_Des,plazoPrestamo - estatic +1 )-1));
      double amortizacion =  cuotaMensual - intereses ;
      if (i < plazo) {
        saldoesta -= amortizacion ;
        estatic++;
      }
      //GASTOS
      double PerSeg_Des=Seg_Des*Saldo_inicial;
      double amortizacionValue = plazo > i ? 0.0 : amortizacion - PerSeg_Des;
      saldo = plazo > i ? saldo + intereses : Saldo_inicial - amortizacionValue  ;

       double periodo = i+1;
      DateTime fechaPago = DateTime.now().add(Duration(days: i * 30)); // Ejemplo: fecha de pago cada 30 días

      //FLUJO
      flujo= PerSeg_Des+seg_riesgo+comision+portes+gastos_admi+cuotaMensual;
      //VAN
      VAN+=flujo/(math.pow(1+PorcentajeCOK, estatic));
      DataRow row = DataRow(
        cells: [
          DataCell(Text(periodo.toString())),
          DataCell(Text(fechaPago.toString())),
          DataCell(Text(Saldo_inicial.toStringAsFixed(2))),
          DataCell(Text(intereses.toStringAsFixed(2))),
          DataCell(Text(cuotaMensual.toStringAsFixed(2))),
          DataCell(Text(amortizacionValue.toStringAsFixed(2))),
          DataCell(Text(PerSeg_Des.toStringAsFixed(2))),
          DataCell(Text(seg_riesgo.toStringAsFixed(2))),
          DataCell(Text(comision.toStringAsFixed(2))),
          DataCell(Text(portes.toStringAsFixed(2))),
          DataCell(Text(gastos_admi.toStringAsFixed(2))),
          DataCell(Text(saldo.toStringAsFixed(2))),
          DataCell(Text(flujo.toStringAsFixed(2))),
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
    porcentajeController.clear();
    tasaController.clear();
    plazoController.clear();
    plazo2Controller.clear();
    desgravamenController.clear();
    seguro_riesgoController.clear();
    comisionController.clear();
    portesController.clear();
    gastosadmiController.clear();
    cokController.clear();

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
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Card(
                      color: Colors.green.withOpacity(0.2),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 86.0,
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 20.0),
                            DropdownButtonFormField<String>(
                              value: selectedMonto,
                              decoration: InputDecoration(labelText: 'Elegir monto'),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedMonto = newValue;
                                  if (newValue == 'Otro monto') {
                                    montoController.clear();
                                  } else {
                                    montoController.text = newValue ?? '';
                                  }
                                });
                              },
                              items: [
                                ...montoOptions.map((option) {
                                  final String label = option['label'];
                                  final String? value = option['value']?.toString();
                                  final String? image = option['image'];

                                  return DropdownMenuItem<String>(
                                    value: value ?? '',
                                    child: Row(
                                      children: [
                                        if (image != null) ...[
                                          Image.asset(
                                            image,
                                            width: 40.0,
                                            height: 40.0,
                                          ),
                                          SizedBox(width: 10.0),
                                        ],
                                        Text(label),
                                        SizedBox(width: 10.0),
                                        Text(value ?? ''),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                DropdownMenuItem<String>(
                                  value: 'Otro monto',
                                  child: Text('Otro monto'),
                                ),
                              ],
                            ),
                            if (selectedMonto == 'Otro monto') ...[
                              SizedBox(height: 10.0),
                              TextField(
                                controller: montoController,
                                decoration: InputDecoration(labelText: 'Monto del préstamo'),
                              ),
                            ],
                            TextField(
                              controller: porcentajeController,
                              decoration: InputDecoration(labelText: 'Porcentaje de cuota inicial'),
                            ),
                            Row(
                              children: [
                                Text('Porcentaje de cuota inicial: '),
                                Text((montoController.text.isNotEmpty && porcentajeController.text.isNotEmpty)
                                    ? (double.parse(montoController.text) * double.parse(porcentajeController.text) / 100).toStringAsFixed(2)
                                    : '0.00'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Expanded(
                    flex: 1,
                    child: Card(
                      color: Colors.green.withOpacity(0.2),
                      child: Container(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Text('Seleccionar tasa:'),
                                    SizedBox(width: 10),
                                    DropdownButton<String>(
                                      value: _selectedTasa,
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          _selectedTasa = newValue!;
                                          tasa = (_selectedTasa == 'Tasa Efectiva') ? 1 : 2;
                                        });
                                      },
                                      items: <String>['Tasa Efectiva', 'Tasa Nominal']
                                          .map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                                TextField(
                                  controller: tasaController,
                                  decoration: InputDecoration(
                                    labelText: 'Tasa de interés $_selectedTasa',
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.0),
                            TextField(
                              controller: plazoController,
                              decoration: InputDecoration(labelText: 'Plazo del préstamo (años)'),
                            ),
                            DropdownButtonFormField<String>(
                              value: top == 1 ? 'Total' : 'Parcial',
                              decoration: InputDecoration(labelText: 'Tipo de plazo de gracia'),
                              onChanged: (String? newValue) {
                                setState(() {
                                  top = newValue == 'Total' ? 1 : 2;
                                });
                              },
                              items: [
                                DropdownMenuItem<String>(
                                  value: 'Total',
                                  child: Text('Total'),
                                ),
                                DropdownMenuItem<String>(
                                  value: 'Parcial',
                                  child: Text('Parcial'),
                                ),
                              ],
                            ),
                            TextField(
                              controller: plazo2Controller,
                              decoration: InputDecoration(
                                labelText: 'Plazo de gracia $top',
                              ),
                            ),
                            TextField(
                              controller: desgravamenController,
                              decoration: InputDecoration(labelText: 'Porcentaje de Seguro desgravamen'),
                            ),
                            TextField(
                              controller: seguro_riesgoController,
                              decoration: InputDecoration(labelText: 'Porcentaje de Seguro de riesgo'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Card(
                color: Colors.green.withOpacity(0.2),
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: comisionController,
                        decoration: InputDecoration(labelText: 'Comisión'),
                      ),
                      TextField(
                        controller: portesController,
                        decoration: InputDecoration(labelText: 'Portes'),
                      ),
                      TextField(
                        controller: gastosadmiController,
                        decoration: InputDecoration(labelText: 'Gastos administrativos'),
                      ),
                      TextField(
                        controller: cokController,
                        decoration: InputDecoration(labelText: '%COK'),
                      ),
                    ],
                  ),
                ),
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
                  DataColumn(label: Text('Saldo Inicial')),
                  DataColumn(label: Text('Intereses')),
                  DataColumn(label: Text('Cuota')),
                  DataColumn(label: Text('Amortización')),
                  DataColumn(label: Text('Seg. Desgrav.')),
                  DataColumn(label: Text('Seg. de Riesgo.')),
                  DataColumn(label: Text('Comision.')),
                  DataColumn(label: Text('Portes')),
                  DataColumn(label: Text('Gastos admi.')),
                  DataColumn(label: Text('Saldo Final')),
                  DataColumn(label: Text('Flujo')),
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
