// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:muniinventario/views/equipos/ingresarequipo.dart';

class EditarEquipo extends StatefulWidget {
  final Equipo equipo;
  final Function(Equipo) onSave;

  EditarEquipo({required this.equipo, required this.onSave});

  @override
  _EditarEquipoState createState() => _EditarEquipoState();
}

class _EditarEquipoState extends State<EditarEquipo> {
  late TextEditingController _modeloController;
  late TextEditingController _numeroSerieController;
  late TextEditingController _numeroInventarioController;
  late TextEditingController _marcaController;
  late TextEditingController _ramController;
  late TextEditingController _almacenController;
  late TextEditingController _procesadorController;
  late TextEditingController _departamentoController;
  late TextEditingController _direccionController;
  late TextEditingController _sistemaOperativoController;
  late TextEditingController _versionOfficeController;
  late TextEditingController _descripcionController;

  @override
  void initState() {
    super.initState();
    _modeloController = TextEditingController(text: widget.equipo.modelo);
    _numeroSerieController = TextEditingController(text: widget.equipo.numeroSerie);
    _numeroInventarioController = TextEditingController(text: widget.equipo.numeroInventario);
    _marcaController = TextEditingController(text: widget.equipo.marca);
    _ramController = TextEditingController(text: widget.equipo.ram);
    _almacenController = TextEditingController(text: widget.equipo.almacenamiento);
    _procesadorController = TextEditingController(text: widget.equipo.procesador);
    _departamentoController = TextEditingController(text: widget.equipo.departamento);
    _direccionController = TextEditingController(text: widget.equipo.direccion);
    _sistemaOperativoController = TextEditingController(text: widget.equipo.sistemaOperativo);
    _versionOfficeController = TextEditingController(text: widget.equipo.versionOffice);
    _descripcionController = TextEditingController(text: widget.equipo.descripcion);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Equipo', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Roboto')),
        backgroundColor: Colors.blue[900],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [const Color.fromARGB(255, 45, 49, 52), Color.fromARGB(255, 181, 222, 115)],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _modeloController,
                    enabled: false,
                    decoration: InputDecoration(labelText: 'Modelo'),
                  ),
                  TextField(
                    controller: _numeroSerieController,
                    decoration: InputDecoration(labelText: 'Numero de Serie'),
                  ),
                  TextField(
                    controller: _numeroInventarioController,
                    decoration: InputDecoration(labelText: 'Numero de Inventario'),
                  ),
                  TextField(
                    controller: _marcaController,
                    enabled: false,
                    decoration: InputDecoration(labelText: 'Marca'),
                  ),
                  TextField(
                    controller: _ramController,
                    decoration: InputDecoration(labelText: 'Tipo de Ram'),
                  ),
                  TextField(
                    controller: _almacenController,
                    decoration: InputDecoration(labelText: 'Tipo de Disco Duro'),
                  ),
                  TextField(
                    controller: _procesadorController,
                    decoration: InputDecoration(labelText: 'Procesador'),
                  ),
                  TextField(
                    controller: _departamentoController,
                    decoration: InputDecoration(labelText: 'Departamento'),
                  ),
                  TextField(
                    controller: _direccionController,
                    decoration: InputDecoration(labelText: 'Dirección'),
                  ),
                  TextField(
                    controller: _sistemaOperativoController,
                    decoration: InputDecoration(labelText: 'Sistema Operativo'),
                  ),
                  TextField(
                    controller: _versionOfficeController,
                    decoration: InputDecoration(labelText: 'Versión Office'),
                  ),
                  TextField(
                    controller: _descripcionController,
                    decoration: InputDecoration(labelText: 'Descripción'),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      final editedEquipo = Equipo(
                        modelo: _modeloController.text,
                        numeroSerie: _numeroSerieController.text,
                        numeroInventario: _numeroInventarioController.text,
                        marca: _marcaController.text,
                        ram: _ramController.text,
                        almacenamiento: _almacenController.text,
                        procesador: _procesadorController.text,
                        departamento: _departamentoController.text,
                        direccion: _direccionController.text,
                        sistemaOperativo: _sistemaOperativoController.text,
                        versionOffice: _versionOfficeController.text,
                        descripcion: _descripcionController.text,
                      );
                      widget.onSave(editedEquipo);
                      Navigator.of(context).pop();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Datos Actualizados"),
                            content: Text("Los datos han sido actualizados correctamente."),
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
                    },
                    child: Text('Guardar Cambios'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}