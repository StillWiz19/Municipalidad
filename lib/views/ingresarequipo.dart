import 'package:flutter/material.dart';
import 'package:muniinventario/views/listadoequipos.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Equipo {
  final String numeroSerie;
  final String numeroInventario;
  final String marca;
  final String modelo;
  final String ram;
  final String almacenamiento;
  final String usuario;
  final String departamento;
  final String direccion;
  final String sistemaOperativo;
  final String versionOffice;

  Equipo({
    required this.numeroSerie,
    required this.numeroInventario,
    required this.marca,
    required this.modelo,
    required this.ram,
    required this.almacenamiento,
    required this.usuario,
    required this.departamento,
    required this.direccion,
    required this.sistemaOperativo,
    required this.versionOffice,
  });
}

TextEditingController _numeroSerieController = TextEditingController();
TextEditingController _numeroInventarioController = TextEditingController();
TextEditingController _marcaController = TextEditingController();
TextEditingController _modeloController = TextEditingController();
TextEditingController _ramController = TextEditingController();
TextEditingController _almacenController = TextEditingController();
TextEditingController _usuarioController = TextEditingController();
TextEditingController _departamentoController = TextEditingController();
TextEditingController _direccionController = TextEditingController();
TextEditingController _sistemaOperativoController = TextEditingController();
TextEditingController _versionOfficeController = TextEditingController();

class IngresarEquipo extends StatefulWidget {
  const IngresarEquipo({Key? key}) : super(key: key);

  @override
  _IngresaEquipoState createState() => _IngresaEquipoState();
}

class _IngresaEquipoState extends State<IngresarEquipo> {
  void _guardarDatos(BuildContext context) async {
    String numeroSerie = _numeroSerieController.text;
    String numeroInventario = _numeroInventarioController.text;
    String marca = _marcaController.text;
    String modelo = _modeloController.text;
    String ram = _ramController.text;
    String almacenamiento = _almacenController.text;
    String usuario = _usuarioController.text;
    String departamento = _departamentoController.text;
    String direccion = _direccionController.text;
    String sistemaOperativo = _sistemaOperativoController.text;
    String versionOffice = _versionOfficeController.text;

    Equipo equipo = Equipo(
      numeroSerie: numeroSerie,
      numeroInventario: numeroInventario,
      marca: marca,
      modelo: modelo,
      ram: ram,
      almacenamiento: almacenamiento,
      usuario: usuario,
      departamento: departamento,
      direccion: direccion,
      sistemaOperativo: sistemaOperativo,
      versionOffice: versionOffice,
    );

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> equiposData = prefs.getStringList('equipos') ?? [];
    equiposData.add(
        '${equipo.numeroSerie}|${equipo.numeroInventario}|${equipo.marca}|${equipo.modelo}|${equipo.ram}|${equipo.almacenamiento}|${equipo.usuario}|${equipo.departamento}|${equipo.direccion}|${equipo.sistemaOperativo}|${equipo.versionOffice}');
    await prefs.setStringList('equipos', equiposData);

    final arguments = ModalRoute.of(context)!.settings.arguments;
    if (arguments != null && arguments is ListadoEquipo) {
      ListadoEquipo listadoEquipo = arguments;
      listadoEquipo.equipos.add(equipo);
    }

    _numeroSerieController.clear();
    _numeroInventarioController.clear();
    _marcaController.clear();
    _modeloController.clear();
    _ramController.clear();
    _almacenController.clear();
    _usuarioController.clear();
    _departamentoController.clear();
    _direccionController.clear();
    _sistemaOperativoController.clear();
    _versionOfficeController.clear();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ingresar Equipo")),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                controller: _modeloController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Modelo",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: TextField(
                controller: _ramController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Ram",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: TextField(
                controller: _almacenController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Almacenamiento",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: TextField(
                controller: _usuarioController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Usuario",
                  prefixIcon: Icon(Icons.person),
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









    

   

