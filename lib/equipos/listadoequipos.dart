import 'dart:io';
import 'package:flutter/material.dart';
import 'package:muniinventario/equipos/editarequipo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:muniinventario/equipos/ingresarequipo.dart';

class ListadoEquipo extends StatefulWidget {
  final List<Equipo> equipos;

  ListadoEquipo({required this.equipos});

  @override
  _ListaEquipoState createState() => _ListaEquipoState();
}

class _ListaEquipoState extends State<ListadoEquipo> {
  List<Equipo> equipos = [];
  List<Equipo> _filteredEquipos = [];

  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> equiposData = prefs.getStringList('equipos') ?? [];
      setState(() {
        equipos = equiposData.map((data) {
          List<String> equipoData = data.split('|');
          return Equipo(
            modelo: equipoData.length > 0 ? equipoData[0] : "",
            numeroSerie: equipoData.length > 1 ? equipoData[1] : "",
            numeroInventario: equipoData.length > 2 ? equipoData[2] : "",
            marca: equipoData.length > 3 ? equipoData[3] : "",
            ram: equipoData.length > 4 ? equipoData[4] : "",
            almacenamiento: equipoData.length > 5 ? equipoData[5] : "",
            procesador: equipoData.length > 6 ? equipoData[6] : "",
            departamento: equipoData.length > 7 ? equipoData[7] : "",
            direccion: equipoData.length > 8 ? equipoData[8] : "",
            sistemaOperativo: equipoData.length > 9 ? equipoData[9] : "",
            versionOffice: equipoData.length > 10 ? equipoData[10] : "",
            descripcion: equipoData.length > 11 ? equipoData[11] : "",
            imagenPath: equipoData.length > 12 ? equipoData[12] : null,
          );
        }).toList();
        _filteredEquipos = List.from(equipos);
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
                setState(() {
                  equipos.removeAt(index);
                  _filteredEquipos.removeAt(index);     
                });
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setStringList(
                  'equipos', 
                  equipos
                  .map((equipo) => 
                  '${equipo.modelo}|${equipo.numeroSerie}|${equipo.numeroInventario}|${equipo.marca}|${equipo.ram}|${equipo.almacenamiento}|${equipo.procesador}|${equipo.departamento}|${equipo.direccion}|${equipo.sistemaOperativo}|${equipo.versionOffice}|${equipo.descripcion}').toList());
                  
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('El equipo se eliminó correctamente.'),
                  ),
                 );
              },
              child: Text("Eliminar"),
            ),
          ],
        );
      },
    );
  }

  void _filterEquipos(String query) {
    setState(() {
      _filteredEquipos = equipos.where((equipo) =>
          equipo.numeroSerie.toLowerCase().contains(query.toLowerCase()) ||
          equipo.modelo.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  void _editarEquipo(int index) {
    final equipo = _filteredEquipos[index];
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => EditarEquipo(
        equipo: equipo,
        onSave: (editedEquipo) {
          setState(() {
            equipos[index] = editedEquipo;
            _filteredEquipos[index] = editedEquipo;
          });
          _actualizarDatosSharedPreferences();
        },
      ),
    ));
  }

  Future<void> _actualizarDatosSharedPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setStringList('equipos', equipos.map((equipo) =>
    '${equipo.modelo}|${equipo.numeroSerie}|${equipo.numeroInventario}|${equipo.marca}|${equipo.ram}|${equipo.almacenamiento}|${equipo.procesador}|${equipo.departamento}|${equipo.direccion}|${equipo.sistemaOperativo}|${equipo.versionOffice}|${equipo.descripcion}').toList());
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
                  controller: _controller,
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
                                icon: Icon(Icons.edit),
                                onPressed: () => _editarEquipo(index),
                              ),
                              IconButton(
                                icon: Icon(Icons.photo),
                                onPressed: () => _verFotoEquipo(equipo.imagenPath),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => _eliminarEquipo(index),
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
