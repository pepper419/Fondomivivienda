

import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'entrada.dart';

void main() => runApp(EntradaApp());
//void main() => runApp(FondoMiviviendaApp());



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



  String? selectedMonto;
  String _selectedTasa = 'Tasa Efectiva';
  int tasa = 1;
  int top = 1;
  String moneda = "S/.";
  bool esDolares = false;


  List<Map<String, dynamic>> montoOptions = [
    {"label": "Casa Personal", "value": 160000, "image": "assets/casa1.png"},
    {"label": "Casa para 2 personas", "value": 210000, "image": "assets/casa2.png"},
    {"label": "Casa para 3 personas", "value": 326000, "image": "assets/casa3.png"},
    {"label": "Casa Familiar", "value": 512560, "image": "assets/casa4.png"}
  ];
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
  final TextEditingController tasacionController = TextEditingController();
  final TextEditingController notarialController = TextEditingController();
  final TextEditingController registralController = TextEditingController();
  final TextEditingController estudioController = TextEditingController();
  final TextEditingController activacionController = TextEditingController();

  double descuento = 0.0;
  double montoPrestamo=0.0;
  List<DataRow> pagosRows = [];
   int estatic = 1;
  double Prestamo=0.0;
  String resultado = '';
  double PorcentajeCOK=0;
   double VAN=0;
  List<double> tir=[];
  void calcularCronograma() {
    double CostNotarial= double.parse(notarialController.text);
    double CostRegistrales=double.parse(registralController.text);
    double Tasacion=double.parse(tasacionController.text);
    double ComisionEstudio=double.parse(estudioController.text);
    double ComisionActivacion=double.parse(activacionController.text);
    VAN=0;
    tir=[];
    //Es el periodo actual en el que se estan calculando las cuotas y va aumentando para recorrer todo el plazo de pagos
    estatic = 1;
    // Cálculos del cronograma de pagos utilizando el método francés
    //MONTO
    montoPrestamo = double.parse(montoController.text);
    if(montoPrestamo <0)
      montoPrestamo*=-1;
    //TEA
    double tasaInteresAnual = double.parse(tasaController.text);
    if(tasaInteresAnual <0)
      tasaInteresAnual*=-1;
    //DESCUENTO
    double porcentajeMonto=double.parse(porcentajeController.text);
    if(porcentajeMonto <0)
      porcentajeMonto*=-1;
    descuento = montoPrestamo * porcentajeMonto / 100;
    //PRESTAMO
     Prestamo = montoPrestamo - descuento + CostNotarial + CostRegistrales + Tasacion + ComisionActivacion + ComisionEstudio;
    //PRIMER valor del TIR
    tir.add(-Prestamo);
    //Cantidad de años
    int plazoPrestamo = int.parse(plazoController.text)*12;
    if(plazoPrestamo <0)
      plazoPrestamo*=-1;
    //Conversion dependiendo de la tasa que se escoja Nominal o Efectiva
    double tasaInteresMensual = (tasa==1) ? (math.pow(1 + (tasaInteresAnual/100), 1/12) - 1) : (math.pow(1 + (tasaInteresAnual/100)/360, 30) - 1);
    //double tasaInteresMensual = tasaInteresAnual / 12 / 100;
    double saldo = 0.0;
    //saldo inicial
    double Saldo_inicial=montoPrestamo - descuento ;
    //Saldo Final
    saldo = Prestamo;
    //SEGURO DE DESGRAVAMEN
    double Seg_Des = double.parse(desgravamenController.text)/100;
    if(Seg_Des <0)
      Seg_Des*=-1;
    //Seguro de riesgo
    double datoSegRiesgo=double.parse(seguro_riesgoController.text);

    if(datoSegRiesgo <0)
      datoSegRiesgo*=-1;

    double seg_riesgo= (datoSegRiesgo/100)* montoPrestamo/12 ;
    //Comision
    double comision= double.parse(comisionController.text);
    if(comision <0)
      comision*=-1;
    //Portes
    double portes= double.parse(portesController.text);
    if(portes <0)
      portes*=-1;
    //Gatos administrativos
    double gastos_admi= double.parse(gastosadmiController.text);
    if(gastos_admi <0)
      gastos_admi*=-1;
    //FLUJO
    double flujo= 0;
    //COK
    double porcentajecok=double.parse(cokController.text);
    if(porcentajecok <0)
      porcentajecok*=-1;
    num cok= math.pow(1+ porcentajecok/100, 30/360) -1;
     PorcentajeCOK=cok.toDouble();
    //VAN

    //double cuotaMensual = (montoPrestamo * tasaInteresMensual) / (1 - math.pow(1 + tasaInteresMensual, -plazoPrestamo));

    //CUOTA MENSUAL
    double cuotaMensual=0;
    //Cantidada de plazos de gracia
    int plazo = int.parse(plazo2Controller.text);
    if(plazo <0)
      plazo*=-1;
    pagosRows.clear();


    for (int i = 0; i < plazoPrestamo; i++) {

      //SALDO INICIAL
      Saldo_inicial= saldo;
      //INTERESES
      double intereses = Saldo_inicial * tasaInteresMensual;
      //CUOTA MENSUAL
      if(top==1)
      {
         cuotaMensual = plazo > i ? 0.0 : Prestamo * (((tasaInteresMensual+Seg_Des)*math.pow(1+tasaInteresMensual+Seg_Des,plazoPrestamo- estatic +1)) /
            (math.pow(1+tasaInteresMensual+Seg_Des,plazoPrestamo - estatic +1 )-1));
      }
      else
        cuotaMensual = plazo > i ? intereses : Prestamo * (((tasaInteresMensual+Seg_Des)*math.pow(1+tasaInteresMensual+Seg_Des,plazoPrestamo- estatic +1)) /
            (math.pow(1+tasaInteresMensual+Seg_Des,plazoPrestamo - estatic +1 )-1));

      //AMORTIZACION
      double amortizacion =  cuotaMensual - intereses ;
      if (i < plazo) {
        Prestamo -= amortizacion ;
        estatic++;
      }
      //GASTOS
      double PerSeg_Des=Seg_Des*Saldo_inicial;
      double amortizacionValue = plazo > i ? 0.0 : amortizacion - PerSeg_Des;
      if(top==1)
      saldo = plazo > i ? Saldo_inicial + intereses : Saldo_inicial - amortizacionValue  ;
      else
        saldo = plazo > i ? Saldo_inicial: Saldo_inicial - amortizacionValue  ;

       double periodo = i+1;
      DateTime fechaPago = DateTime.now().add(Duration(days: i * 30)); // Ejemplo: fecha de pago cada 30 días

      //FLUJO
      flujo= plazo > i ? PerSeg_Des+seg_riesgo+comision+portes+gastos_admi+cuotaMensual:seg_riesgo+comision+portes+gastos_admi+cuotaMensual;
      //Añadir el flujo a la lista de TIR
      tir.add(flujo);
      //VAN
      VAN+=flujo/(math.pow(1+PorcentajeCOK, i+1));
      DataRow row = DataRow(
        cells: [
          DataCell(Text(periodo.toString())),
          DataCell(Text(fechaPago.toString())),
          DataCell(Text(moneda+Saldo_inicial.toStringAsFixed(2))),
          DataCell(Text(moneda+intereses.toStringAsFixed(2))),
          DataCell(Text(moneda+cuotaMensual.toStringAsFixed(2))),
          DataCell(Text(moneda+amortizacionValue.toStringAsFixed(2))),
          DataCell(Text(moneda+PerSeg_Des.toStringAsFixed(2))),
          DataCell(Text(moneda+seg_riesgo.toStringAsFixed(2))),
          DataCell(Text(moneda+comision.toStringAsFixed(2))),
          DataCell(Text(moneda+portes.toStringAsFixed(2))),
          DataCell(Text(moneda+gastos_admi.toStringAsFixed(2))),
          DataCell(Text(moneda+saldo.toStringAsFixed(2))),
          DataCell(Text(moneda+flujo.toStringAsFixed(2))),
        ],
      );
      pagosRows.add(row);
    }
    setState(() {
      resultado = 'Cronograma de pagos';
    });
  }

  double calcularTIR(List<double> flujosEfectivo) {
    double precision = 0.00001;
    double tirInicial = 0.1;

    double tirActual = tirInicial;
    double tirAnterior = 0.0;
    double error = 1.0;

    while (error > precision) {
      double tirFuncion = 0.0;
      double tirD = 0.0;

      for (int i = 0; i < tir.length; i++) {
        tirFuncion += tir[i] / math.pow(1 + tirActual, i + 1);
        tirD -= (i + 1) * tir[i] / math.pow(1 + tirActual, i + 2);
      }

      tirAnterior = tirActual;
      tirActual = tirActual - tirFuncion / tirD;
      error = (tirActual - tirAnterior).abs();
    }

    return tirActual*100;
  }

  double CalcularTCEA()
  {
    double answer;
    answer= math.pow(1+ calcularTIR(tir)/100, 360/30) - 1;
    return answer * 100;
  }

  void showResumen(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Resumen'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Monto préstamo: ${moneda} ${montoController.text}'),
              Text('Tasa de Interés:  ${tasaController.text}%'),
              Text('Plazo (en años):  ${plazoController.text}'),
              Text('COK: ${(PorcentajeCOK*100).toStringAsFixed(5)}%'),
              Text('VAN: ${moneda} ${(( Prestamo) - VAN).toStringAsFixed(2)}'),
              Text('TIR: ${(calcularTIR(tir)).toStringAsFixed(5)}%'),
              Text('TCEA: ${(CalcularTCEA()).toStringAsFixed(5)}%'),

            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
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
              Switch(
                value: esDolares,
                onChanged: (value) {
                  setState(() {
                    esDolares = value;
                    moneda = esDolares ? "\$" : "S/.";
                  });
                },
              ),
              Image.asset(
                esDolares ? 'assets/billetedolares.png' : 'assets/billetesoles.png',
                width: 100,
                height: 100,
              ),
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
                              decoration: InputDecoration(labelText: 'Porcentaje de cuota inicial',
                                suffixText: '%'),

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
                                    suffixText: '%',
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
                              decoration: InputDecoration(labelText: 'Porcentaje de Seguro desgravamen',
                                suffixText: '%'),
                            ),
                            TextField(
                              controller: seguro_riesgoController,
                              decoration: InputDecoration(labelText: 'Porcentaje de Seguro de riesgo',
                                suffixText: '%'),
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
                        controller: notarialController,
                        decoration: InputDecoration(labelText: 'Coste Notarial'),
                      ),
                      TextField(
                        controller: registralController,
                        decoration: InputDecoration(labelText: 'Coste Registrales'),
                      ),
                      TextField(
                        controller: tasacionController ,
                        decoration: InputDecoration(labelText: 'tasacion'),
                      ),
                      TextField(
                        controller: estudioController,
                        decoration: InputDecoration(labelText: 'Comisiones de Estudio'),
                      ),
                      TextField(
                        controller: activacionController,
                        decoration: InputDecoration(labelText: 'Comisiones de Activacion'),
                      ),
                      TextField(
                        controller: cokController,
                        decoration: InputDecoration(labelText: '%COK',
                          suffixText: '%'),
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
                  ElevatedButton(
                    onPressed: () {
                      showResumen(context);
                    },
                    child: Text('Resumen'),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Text(resultado),
              DataTable(
                columns: [
                  DataColumn(label: Text('Periodo'),),
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
