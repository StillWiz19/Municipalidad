import 'package:flutter/material.dart';
import 'package:muniinventario/db_helper/db_helper.dart';
import 'package:muniinventario/views/listatickets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Ticket {
  final String numeroTicket;
  final String usuario;
  final String departamento;
  final String solicitud;

  Ticket({
    required this.numeroTicket,
    required this.usuario,
    required this.departamento,
    required this.solicitud,
  });
}

TextEditingController _numeroTicketController = TextEditingController();
TextEditingController _usuarioController = TextEditingController();
TextEditingController _departamentoController = TextEditingController();
TextEditingController _solicitudController = TextEditingController();

class CrearTicket extends StatefulWidget {
  const CrearTicket({Key? key}) : super(key: key);

  @override
  _CrearTicketState createState() => _CrearTicketState();
}

class _CrearTicketState extends State<CrearTicket>{
  void _guardarDatos(BuildContext context) async {
    Db_helper db = Db_helper();

    db.crearTicket(
      _numeroTicketController.text,
      _usuarioController.text,
      _departamentoController.text,
      _solicitudController.text
    ); 

    void _limpiarCajas() {
      _numeroTicketController.clear();
      _usuarioController.clear();
      _departamentoController.clear();
      _solicitudController.clear();
    }

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
    _limpiarCajas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Crear Ticket')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextField(
              controller: _numeroTicketController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "N° de Ticket"
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextField(
              controller: _usuarioController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Usuario"
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextField(
              controller: _departamentoController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Departamento"
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextField(
              controller: _solicitudController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Solicitud"
              ),
            ),
          ),
          ElevatedButton(
            onPressed: (){
              _guardarDatos(context);
            },
            child: Text("Guardar"),
          )
        ],
      ),
    );
  }
}