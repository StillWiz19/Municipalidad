import 'package:flutter/material.dart';
import 'package:muniinventario/equipos/ingresarequipo.dart';

class EditarEquipo extends StatefulWidget {
  final Equipo equipo;

  const EditarEquipo({Key? key, required this.equipo}) : super(key: key);

  @override
  _EditarEquipoState createState() => _EditarEquipoState();
}

class _EditarEquipoState extends State<EditarEquipo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Equipo'),
      ),
      body: IngresarEquipo(), 
    );
  }
}