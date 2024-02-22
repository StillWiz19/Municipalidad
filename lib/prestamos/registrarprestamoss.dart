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

class RegistrarPrestamos extends StatefulWidget {
  const RegistrarPrestamos({Key? key}) : super(key: key);

  @override
  _PrestamoProyectorState createState() => _PrestamoProyectorState();
}

class _PrestamoProyectorState extends State<RegistrarPrestamos> {
  TextEditingController _numeroSerieController = TextEditingController();
  TextEditingController _usuarioController = TextEditingController();
  TextEditingController _departamentoController = TextEditingController();
  TextEditingController _motivoController = TextEditingController();
  TextEditingController _fechaController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void _guardarDatos(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
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
  }

  Future<void> _seleccionarFecha(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
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
    if (picked != null) {
      setState(() {
        _fechaController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextFormField(
                controller: _numeroSerieController,
                labelText: "N° de Serie",
              ),
              _buildTextFormField(
                controller: _usuarioController,
                labelText: "Usuario",
              ),
              _buildTextFormField(
                controller: _departamentoController,
                labelText: "Departamento",
              ),
              _buildTextFormField(
                controller: _motivoController,
                labelText: "Motivos",
              ),
              _buildDateField(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _guardarDatos(context);
                },
                child: Text("Guardar"),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: labelText,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor ingresa este campo';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDateField() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: TextFormField(
        controller: _fechaController,
        readOnly: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Fecha de Prestamo",
          suffixIcon: IconButton(
            onPressed: () => _seleccionarFecha(context),
            icon: Icon(Icons.calendar_today),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor selecciona una fecha';
          }
          return null;
        },
      ),
    );
  }
}
