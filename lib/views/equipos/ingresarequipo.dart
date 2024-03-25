// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, avoid_print, prefer_final_fields, library_private_types_in_public_api

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:muniinventario/db_helper/db_helper.dart';

class Equipo {
  final String modelo;
  final String numeroSerie;
  final String numeroInventario;
  final String marca;
  final String ram;
  final String almacenamiento;
  final String procesador;
  final String departamento;
  final String direccion;
  final String sistemaOperativo;
  final String versionOffice;
  final String descripcion;
  final String? imagenPath;

  Equipo({
    required this.modelo,
    required this.numeroSerie,
    required this.numeroInventario,
    required this.marca,
    required this.ram,
    required this.almacenamiento,
    required this.procesador,
    required this.departamento,
    required this.direccion,
    required this.sistemaOperativo,
    required this.versionOffice,
    required this.descripcion,
    this.imagenPath,
  });
}

class IngresarEquipo extends StatefulWidget {
  const IngresarEquipo({Key? key}) : super(key: key);

  @override
  _IngresarEquipoState createState() => _IngresarEquipoState();
}

class _IngresarEquipoState extends State<IngresarEquipo> {
  List<String> modelos = [
    'Ideapad',
    'Victus',
    'TufGaming',
    'ThinkCentre',
  ];

  String? _selectedModelo;

  TextEditingController _numeroSerieController = TextEditingController();
  TextEditingController _numeroInventarioController = TextEditingController();
  TextEditingController _marcaController = TextEditingController();
  TextEditingController _ramController = TextEditingController();
  TextEditingController _almacenController = TextEditingController();
  TextEditingController _procesadorController = TextEditingController();
  TextEditingController _departamentoController = TextEditingController();
  TextEditingController _sistemaOperativoController = TextEditingController();
  TextEditingController _direccionController = TextEditingController();
  TextEditingController _versionOfficeController = TextEditingController();
  TextEditingController _descripcionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  File? _image;

  final picker = ImagePicker();

  @override
  void dispose() {
    _numeroSerieController.dispose();
    _numeroInventarioController.dispose();
    _marcaController.dispose();
    _ramController.dispose();
    _almacenController.dispose();
    _procesadorController.dispose();
    _departamentoController.dispose();
    _sistemaOperativoController.dispose();
    _direccionController.dispose();
    _versionOfficeController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ingresar Equipo',
          textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedModelo,
                      items: [
                        ...modelos.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ],
                      onChanged: (String? value) {
                        setState(() {
                          _selectedModelo = value;
                          _rellenarDatos(value!);
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Modelo',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor selecciona un modelo';
                        }
                        return null;
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: _agregarModelo,
                    icon: Icon(Icons.add),
                  ),
                ],
              ),
              SizedBox(height: 10),
              _buildTextFormField(
                controller: _numeroSerieController,
                labelText: "N° de Serie",
                editable: true,
              ),
              _buildTextFormField(
                controller: _numeroInventarioController,
                labelText: "N° de Inventario",
                editable: true,
              ),
              _buildTextFormField(
                controller: _marcaController,
                labelText: "Marca",
                editable: _modeloGuardado(_selectedModelo),
              ),
              _buildTextFormField(
                controller: _ramController,
                labelText: "Tipo Ram",
                editable: _modeloGuardado(_selectedModelo),
              ),
              _buildTextFormField(
                controller: _almacenController,
                labelText: "Tipo Disco Duro",
                editable: _modeloGuardado(_selectedModelo),
              ),
              _buildTextFormField(
                controller: _procesadorController,
                labelText: "Procesador",
                editable: true,
              ),
              _buildDepartamentoDropdown(),
              _buildTextFormField(
                controller: _direccionController,
                labelText: "Dirección",
                editable: true,
              ),
              _buildSistemaOperativoDropdown(),
              _buildTextFormField(
                controller: _versionOfficeController,
                labelText: "Versión Office",
                editable: true,
              ),
              _buildTextFormField(
                controller: _descripcionController,
                labelText: "Descripción",
                editable: true,
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _getImageFromCamera,
                    child: Text("Cámara"),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _getImageFromGallery,
                    child: Text("Galería"),
                  ),
                ],
              ),
              SizedBox(height: 10),
              _image != null ? Image.file(_image!) : SizedBox(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _guardarDatos(context);
                  }
                },
                child: Text("Guardar"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required bool editable,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        enabled: editable,
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

  Widget _buildSistemaOperativoDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: _sistemaOperativoController.text.isNotEmpty ? _sistemaOperativoController.text : null,
        items: [
          'Windows 7',
          'Windows 8',
          'Windows 10',
          'Windows 11',
        ].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? value) {
          setState(() {
            _sistemaOperativoController.text = value ?? '';
          });
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Sistema Operativo',
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor selecciona un Sistema Operativo';
          }
          return null;
        },
      ),
    );
  }

  void _guardarDatos(BuildContext context) async {
    Db_helper db = Db_helper();
    String? imagenPath;

    db.ingresarEquipo(
      _numeroSerieController.text,
      _numeroInventarioController.text,
      _marcaController.text,
      _selectedModelo ?? '',
      _ramController.text,
      _almacenController.text,
      _procesadorController.text,
      _departamentoController.text,
      _direccionController.text,
      _sistemaOperativoController.text,
      _versionOfficeController.text,
      _descripcionController.text,
      imagenPath ?? ''
    );

    if (_image != null) {
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = '${directory.path}/equipo_${DateTime.now().millisecondsSinceEpoch}.jpg';
      await _image!.copy(imagePath);
      imagenPath = imagePath;
    }

    setState(() {
      _image = null;
    });

    _limpiarCampos();

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

  void _limpiarCampos() {
    _numeroSerieController.clear();
    _numeroInventarioController.clear();
    _marcaController.clear();
    _ramController.clear();
    _almacenController.clear();
    _procesadorController.clear();
    _departamentoController.clear();
    _direccionController.clear();
    _sistemaOperativoController.clear();
    _versionOfficeController.clear();
    _descripcionController.clear();

    setState(() {
      _selectedModelo = null;
    });
  }

  Future<void> _rellenarDatos(String modelo) async {
    
  }

  void _agregarModelo() async {
    TextEditingController newModelController = TextEditingController();
    String? newModel = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Agregar Nuevo Modelo"),
          content: TextFormField(
            controller: newModelController,
            decoration: InputDecoration(
              hintText: "Ingrese el nuevo modelo",
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(newModelController.text.trim());
              },
              child: Text("Agregar"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(null);
              },
              child: Text("Cancelar"),
            ),
          ],
        );
      },
    );

    if (newModel != null && newModel.isNotEmpty) {
      setState(() {
        modelos.add(newModel);
        _selectedModelo = newModel;
      });
    }
  }

  Future<void> _getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('Ninguna imágen seleccionada.');
      }
    });
  }

  Future<void> _getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('Ninguna imágen seleccionada.');
      }
    });
  }

  bool _modeloGuardado(String? modelo) {
    return modelos.contains(modelo);
  }
}
