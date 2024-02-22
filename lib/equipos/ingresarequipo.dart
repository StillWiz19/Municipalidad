import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:muniinventario/equipos/listadoequipos.dart';

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
  TextEditingController _direccionController = TextEditingController();
  TextEditingController _sistemaOperativoController = TextEditingController();
  TextEditingController _versionOfficeController = TextEditingController();
  TextEditingController _descripcionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _numeroSerieController.dispose();
    _numeroInventarioController.dispose();
    _marcaController.dispose();
    _ramController.dispose();
    _almacenController.dispose();
    _procesadorController.dispose();
    _departamentoController.dispose();
    _direccionController.dispose();
    _sistemaOperativoController.dispose();
    _versionOfficeController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ingresar Equipo', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Roboto')),
        backgroundColor: Color.fromARGB(255, 43, 74, 165),
        centerTitle: true,
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
              ),
              _buildTextFormField(
                controller: _numeroInventarioController,
                labelText: "N° de Inventario",
              ),
              _buildTextFormField(
                controller: _marcaController,
                labelText: "Marca",
              ),
              _buildTextFormField(
                controller: _ramController,
                labelText: "Tipo Ram",
              ),
              _buildTextFormField(
                controller: _almacenController,
                labelText: "Tipo Disco Duro",
              ),
              _buildTextFormField(
                controller: _procesadorController,
                labelText: "Procesador",
              ),
              _buildTextFormField(
                controller: _departamentoController,
                labelText: "Departamento",
              ),
              _buildTextFormField(
                controller: _direccionController,
                labelText: "Dirección",
              ),
              _buildTextFormField(
                controller: _sistemaOperativoController,
                labelText: "Sistema Operativo",
              ),
              _buildTextFormField(
                controller: _versionOfficeController,
                labelText: "Versión Office",
              ),
              _buildTextFormField(
                controller: _descripcionController,
                labelText: "Descripción",
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

  void _guardarDatos(BuildContext context) async {
    String numeroSerie = _numeroSerieController.text;
    String numeroInventario = _numeroInventarioController.text;
    String marca = _marcaController.text;
    String ram = _ramController.text;
    String almacenamiento = _almacenController.text;
    String procesador = _procesadorController.text;
    String departamento = _departamentoController.text;
    String direccion = _direccionController.text;
    String sistemaOperativo = _sistemaOperativoController.text;
    String versionOffice = _versionOfficeController.text;
    String descripcion = _descripcionController.text;

    Equipo equipo = Equipo(
      modelo: _selectedModelo ?? '',
      numeroSerie: numeroSerie,
      numeroInventario: numeroInventario,
      marca: marca,
      ram: ram,
      almacenamiento: almacenamiento,
      procesador: procesador,
      departamento: departamento,
      direccion: direccion,
      sistemaOperativo: sistemaOperativo,
      versionOffice: versionOffice,
      descripcion: descripcion,
    );

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> equiposData = prefs.getStringList('equipos') ?? [];
    equiposData.add(
        '${equipo.modelo}|${equipo.numeroSerie}|${equipo.numeroInventario}|${equipo.marca}|${equipo.ram}|${equipo.almacenamiento}|${equipo.procesador}|${equipo.departamento}|${equipo.direccion}|${equipo.sistemaOperativo}|${equipo.versionOffice}|${equipo.descripcion}');
    await prefs.setStringList('equipos', equiposData);

    final arguments = ModalRoute.of(context)!.settings.arguments;
    if (arguments != null && arguments is ListadoEquipo) {
      ListadoEquipo listadoEquipo = arguments;
      listadoEquipo.equipos.add(equipo);
    }

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

  }

  Future<void> _rellenarDatos(String modelo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? equiposData = prefs.getStringList('equipos') ?? [];
    for (String data in equiposData) {
      List<String> equipoData = data.split('|');
      if (equipoData[0] == modelo) {
        _marcaController.text = equipoData[3];
        _ramController.text = equipoData[4];
        _almacenController.text = equipoData[5];
        break;
      }
    }
  }

  void _agregarModelo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController newModelController = TextEditingController();
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
                String newModel = newModelController.text.trim();
                if (newModel.isNotEmpty) {
                  setState(() {
                    modelos.add(newModel);
                    _selectedModelo = newModel;
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text("Agregar"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancelar"),
            ),
          ],
        );
      },
    );
  }
}


