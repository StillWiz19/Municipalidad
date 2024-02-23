import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:muniinventario/equipos/ingresarequipo.dart';

class ListadoEquipo extends StatefulWidget {
  final List<Equipo> equipos;

  ListadoEquipo({required this.equipos});

  @override
  _ListaEquipoState createState() => _ListaEquipoState();
}

class _ListaEquipoState extends State<ListadoEquipo> {
  TextEditingController _searchController = TextEditingController();
  List<Equipo> _filteredEquipos = [];

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? equiposData = prefs.getStringList('equipos');
    if (equiposData != null) {
      setState(() {
        widget.equipos.clear();
        _filteredEquipos.clear();
        widget.equipos.addAll(equiposData.map((data) {
          List<String> equipoData = data.split('|');
          return Equipo(
            modelo: equipoData[0],
            numeroSerie: equipoData[1],
            numeroInventario: equipoData[2],
            marca: equipoData[3],
            ram: equipoData[4],
            almacenamiento: equipoData[5],
            procesador: equipoData[6],
            departamento: equipoData[7],
            direccion: equipoData[8],
            sistemaOperativo: equipoData[9],
            versionOffice: equipoData[10],
            descripcion: equipoData[11],
            imagenPath: equipoData.length > 12 ? equipoData[12] : null,
          );
        }));
        _filteredEquipos.addAll(widget.equipos);
      });
    }
  }

  void _filterEquipos(String searchTerm) {
    setState(() {
      _filteredEquipos = widget.equipos
          .where((equipo) =>
              equipo.modelo.toLowerCase().contains(searchTerm.toLowerCase()) ||
              equipo.numeroSerie.toLowerCase().contains(searchTerm.toLowerCase()))
          .toList();
    });
  }

  Future<void> _eliminarEquipo(int index) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Eliminar Equipo"),
          content: Text("¿Estás seguro de que deseas eliminar este equipo?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _confirmarEliminarEquipo(index);
              },
              child: Text("Eliminar"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmarEliminarEquipo(int index) async {
    setState(() {
      widget.equipos.removeAt(index);
      _filteredEquipos.removeAt(index);
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('equipos', widget.equipos.map((equipo) =>
        '${equipo.modelo}|${equipo.numeroSerie}|${equipo.numeroInventario}|${equipo.marca}|${equipo.ram}|${equipo.almacenamiento}|${equipo.procesador}|${equipo.departamento}|${equipo.direccion}|${equipo.sistemaOperativo}|${equipo.versionOffice}|${equipo.descripcion}').toList());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('El equipo se eliminó correctamente.'),
      ),
    );
  }

Future<void> _verFotoEquipo(String? imagePath) async {
  if (imagePath != null) {
    print("Ruta de la imagen: $imagePath");
    File imageFile = File(imagePath);
    if (await imageFile.exists()) {
      showDialog(
        context: context, 
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(child: Text("Foto del Equipo")),
            content: Image.file(imageFile),
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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('El archivo de imagen no existe.'),
        ),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Este equipo no tiene una foto.'),
      ),
    );
  }
}


  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(
      title: Text('Lista de Equipos', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Roboto')),
      backgroundColor: Colors.blue[900],
      centerTitle: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.blue[200]!, Colors.green[200]!],
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  onChanged: _filterEquipos,
                  decoration: InputDecoration(
                    labelText: 'Buscar equipo por N° Serie o Modelo',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredEquipos.length,
                  itemBuilder: (context, index) {
                    final equipo = _filteredEquipos[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          title: Text(equipo.marca),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 8),
                              Text('Modelo: ${equipo.modelo}'),
                              Text('N° de Serie: ${equipo.numeroSerie}'),
                              Text('N° de Inventario: ${equipo.numeroInventario}'),
                              Text('Marca: ${equipo.marca}'),
                              Text('Ram: ${equipo.ram}'),
                              Text('Almacenamiento: ${equipo.almacenamiento}'),
                              Text('Procesador: ${equipo.procesador}'),
                              Text('Departamento: ${equipo.departamento}'),
                              Text('Direccion: ${equipo.direccion}'),
                              Text('Sistema Operativo: ${equipo.sistemaOperativo}'),
                              Text('Version de Office: ${equipo.versionOffice}'),
                              Text('Descripción: ${equipo.descripcion}'),
                            ],
                          ),
                        
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => _eliminarEquipo(index),
                              ),
                              IconButton(
                                icon: Icon(Icons.photo),
                                onPressed: () => _verFotoEquipo(equipo.imagenPath),
                              ),
                            ],
                          )
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
