import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class Prestamo {
  final String numeroSerie;
  final String usuario;
  final String departamento;
  final String motivo;
  final String fecha;

  Prestamo({
    required this.numeroSerie,
    required this.usuario,
    required this.departamento,
    required this.motivo,
    required this.fecha,
  });
}

TextEditingController _numeroSerieController = TextEditingController();
TextEditingController _usuarioController = TextEditingController();
TextEditingController _departamentoController = TextEditingController();
TextEditingController _motivoController = TextEditingController();
TextEditingController _fechaController = TextEditingController();

class RegistrarPrestamos extends StatefulWidget {
  const RegistrarPrestamos({Key? key}) : super(key: key);

  @override
  _PrestamoProyectorState createState() => _PrestamoProyectorState();
}

class _PrestamoProyectorState extends State<RegistrarPrestamos> {
  void _guardarDatos(BuildContext context) async {
    String numeroSerie = _numeroSerieController.text;
    String usuario = _usuarioController.text;
    String departamento = _departamentoController.text;
    String motivo = _motivoController.text;
    String fecha = _fechaController.text;

    Prestamo prestamo = Prestamo(
      numeroSerie: numeroSerie,
      usuario: usuario,
      departamento: departamento,
      motivo: motivo,
      fecha: fecha,
    );

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> prestamosData = prefs.getStringList('prestamos') ?? [];
    prestamosData.add(
        '${prestamo.numeroSerie}|${prestamo.usuario}|${prestamo.departamento}|${prestamo.motivo}|${prestamo.fecha}');
    await prefs.setStringList('prestamos', prestamosData);

    _numeroSerieController.clear();
    _usuarioController.clear();
    _departamentoController.clear();
    _motivoController.clear();
    _fechaController.clear();

    setState(() {});

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Datos Guardados"),
          content: Text("Los datos han sido guardados correctamente."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cerrar"),
            ),
          ],
        );
      },
    );
  }

  DateTime selectedDate = DateTime.now();

  Future<void> _seleccionarFecha(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue, 
              onPrimary: Colors.white, 
              surface: Colors.white, 
            ),
           
            textTheme: TextTheme(
              bodyText1: TextStyle(color: Colors.black),
              subtitle1: TextStyle(color: Colors.black),
              button: TextStyle(color: Colors.blue), 
            ),
            
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _fechaController.text = DateFormat('dd/MM/yyyy').format(selectedDate);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prestamos',
            textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Roboto')),
        backgroundColor: Color.fromARGB(255, 43, 74, 165),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextFormField(
              controller: _numeroSerieController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: "N° de Serie"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextFormField(
              controller: _usuarioController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: "Usuario"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextFormField(
              controller: _departamentoController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: "Departamento"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextFormField(
              controller: _motivoController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: "Motivos"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: InputDecorator(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Fecha de Prestamo",
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _fechaController.text,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  IconButton(
                    onPressed: () => _seleccionarFecha(context),
                    icon: Icon(Icons.calendar_today),
                  ),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _guardarDatos(context);
            },
            child: Text("Guardar"),
          )
        ],
      ),
    );
  }
}


