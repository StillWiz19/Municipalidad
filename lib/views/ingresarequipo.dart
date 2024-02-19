import 'package:flutter/material.dart';
import 'package:muniinventario/views/listadoequipos.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Equipo {
  final String modelo;
  final String numeroSerie;
  final String numeroInventario;
  final String marca;
  final String ram;
  final String almacenamiento;
  final String precesador;
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
    required this.precesador,
    required this.departamento,
    required this.direccion,
    required this.sistemaOperativo,
    required this.versionOffice,
    required this.descripcion,
  });
}

TextEditingController _modeloController = TextEditingController();
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

class IngresarEquipo extends StatefulWidget {
  const IngresarEquipo({Key? key}) : super(key: key);

  @override
  _IngresaEquipoState createState() => _IngresaEquipoState();
}

class _IngresaEquipoState extends State<IngresarEquipo> {
  List<String> modelos = [
    'Ideapad',
    'Victus',
    'TufGaming',
    'Ideapad2',
  ];

  String? _selectedModelo;

  @override
  void initState() {
    _modeloController = TextEditingController();
    _numeroSerieController = TextEditingController();
    _numeroInventarioController = TextEditingController();
    _marcaController = TextEditingController();
    _ramController = TextEditingController();
    _almacenController = TextEditingController();
    _procesadorController = TextEditingController();
    _departamentoController = TextEditingController();
    _direccionController = TextEditingController();
    _sistemaOperativoController = TextEditingController();
    _versionOfficeController = TextEditingController();
    _descripcionController = TextEditingController();
    super.initState();
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
      precesador: procesador,
      departamento: departamento,
      direccion: direccion,
      sistemaOperativo: sistemaOperativo,
      versionOffice: versionOffice,
      descripcion: descripcion,
    );

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> equiposData = prefs.getStringList('equipos') ?? [];
    equiposData.add(
        '${equipo.modelo}|${equipo.numeroSerie}|${equipo.numeroInventario}|${equipo.marca}|${equipo.ram}|${equipo.almacenamiento}|${equipo.precesador}|${equipo.departamento}|${equipo.direccion}|${equipo.sistemaOperativo}|${equipo.versionOffice}|${equipo.descripcion}');
    await prefs.setStringList('equipos', equiposData);

    final arguments = ModalRoute.of(context)!.settings.arguments;
    if (arguments != null && arguments is ListadoEquipo) {
      ListadoEquipo listadoEquipo = arguments;
      listadoEquipo.equipos.add(equipo);
    }
    _modeloController.clear();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ingresar Equipo")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: DropdownButtonFormField<String>(
                value: _selectedModelo,
                items: modelos.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
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
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: TextField(
                controller: _numeroSerieController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "N° de Serie",
                  prefixIcon: Icon(Icons.numbers),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: TextField(
                controller: _numeroInventarioController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "N° de Inventario",
                  prefixIcon: Icon(Icons.numbers),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: TextField(
                controller: _marcaController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Marca",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: TextField(
                controller: _ramController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Tipo Ram",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: TextField(
                controller: _almacenController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Tipo Disco Duro",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: TextField(
                controller: _procesadorController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Procesador",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: TextField(
                controller: _departamentoController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Departamento",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: TextField(
                controller: _direccionController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Direccion",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: TextField(
                controller: _sistemaOperativoController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Sistema Operativo",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: TextField(
                controller: _versionOfficeController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Version Office",
                ),
              ),
            ),
             Padding(
              padding: const EdgeInsets.all(5.0),
              child: TextField(
                controller: _descripcionController,
                maxLines: null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Descripción",
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
      ),
    );
  }
}

