// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:muniinventario/db_helper/db_helper.dart';

class Ticket {
  final String numeroTicket;
  final String usuario;
  final String departamento;
  final String solicitud;
  bool aceptado;

  Ticket({
    required this.numeroTicket,
    required this.usuario,
    required this.departamento,
    required this.solicitud,
    this.aceptado = false,
  });
}

class CrearTicket extends StatefulWidget {
  const CrearTicket({Key? key}) : super(key: key);

  @override
  _CrearTicketState createState() => _CrearTicketState();
}

class _CrearTicketState extends State<CrearTicket> {
  TextEditingController _numeroTicketController = TextEditingController();
  TextEditingController _usuarioController = TextEditingController();
  TextEditingController _departamentoController = TextEditingController();
  TextEditingController _solicitudController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Ticket',
           textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextFormField(
                controller: _numeroTicketController,
                labelText: "N° de Ticket",
              ),
              _buildTextFormField(
                controller: _usuarioController,
                labelText: "Usuario",
              ),
              _buildDepartamentoDropdown(),
              _buildTextFormField(
                controller: _solicitudController,
                labelText: "Asuntos",
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _guardarDatos(context);
                  }
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

  Widget _buildDepartamentoDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: _departamentoController.text.isNotEmpty ? _departamentoController.text : null,
        items: [
          'Alcaldía',
          'Secretaria Municipal',
          'Secretaria Administración',
          'Asesoría Jurídica',
          'Control Interno',
          'Transparencia',
          'Finanzas',
          'Inspectores',
          'Concejo Municipal',
          'Oficina de Partes',
          'Secretaria de Planificaciones',
          'Dirección de Obras',
          'Inventario Municipal',
          'Remuneraciones',
          'Adquisiciones',
          'Contabilidad',
          'Rentas y Patentes',
          'Tesorería',
          'Prevencionistas',
          'Informatica',
          'Comunicaciones',
          'Dirección de Recursos Humanos',
          'Fotocopiadora',
        ].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? value) {
          setState(() {
            _departamentoController.text = value ?? '';
          });
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Departamento'
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor selecciona un Departamento';
          }
          return null;
        },
      ),
    );
  }

  void _guardarDatos(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      Db_helper db = Db_helper();

      db.crearTicket(
        _numeroTicketController.text,
        _usuarioController.text,
        _departamentoController.text,
        _solicitudController.text
      );

      void limpiarCajas(){
       _numeroTicketController.clear();
        _usuarioController.clear();
        _solicitudController.clear(); 
      }

      setState(() {
           _departamentoController.clear();
      });

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
      limpiarCajas();
    }
  }
}
