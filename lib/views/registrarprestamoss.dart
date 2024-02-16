import 'package:flutter/material.dart';
import 'package:muniinventario/views/prestamosproyector.dart';
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
  void _guardarDatos(BuildContext context) async{
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
    prestamosData.add('${prestamo.numeroSerie}|${prestamo.usuario}|${prestamo.departamento}|${prestamo.motivo}|${prestamo.fecha}');
    await prefs.setStringList('prestamos', prestamosData);

    final arguments = ModalRoute.of(context)!.settings.arguments;
    if (arguments != null && arguments is PrestamosProyector) {
      PrestamosProyector prestamosProyector = arguments;
      prestamosProyector.prestamos.add(prestamo);
    }

    _numeroSerieController.clear();
    _usuarioController.clear();
    _departamentoController.clear();
    _motivoController.clear();
    _fechaController.clear();

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

  Future<void> _seleccionarFecha(BuildContext context) async{
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, 
      firstDate: DateTime(1900), 
      lastDate: DateTime(2101),
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
      appBar: AppBar(title: Text('Prestamos de Proyectores')),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: TextField(
            controller: _numeroSerieController,
            decoration:InputDecoration(
              border: OutlineInputBorder(),
              labelText: "N° de Serie Proyector"
            ) ,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: TextField(
            controller: _usuarioController ,
              decoration:InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Usuario"
              ) ,
            ),
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: TextField(
            controller: _departamentoController,
              decoration:InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Departamento"
              ) ,
            ),
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: TextField(
            controller: _motivoController,
              decoration:InputDecoration(
                border: OutlineInputBorder(),
                labelText: "¿Para que será el uso del proyector?"
              ) ,
            ),
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "Fecha de Prestamo:",
                  style: TextStyle(fontSize: 16),
                ),
                ),
                TextButton(
                  onPressed: () => _seleccionarFecha(context),
                  child: Text(
                    _fechaController.text,
                    style: TextStyle(fontSize: 16),
                  ),
                  ),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: (){
            _guardarDatos(context);
          }, 
          child: Text("Guardar"),
          )
      ],)
    );
  }
}
