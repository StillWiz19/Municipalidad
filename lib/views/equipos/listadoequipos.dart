// ignore_for_file: use_build_context_synchronously, avoid_print, prefer_const_constructors, prefer_const_literals_to_create_immutables, library_private_types_in_public_api, prefer_final_fields, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:muniinventario/views/equipos/editarequipo.dart';
import 'package:muniinventario/views/equipos/ingresarequipo.dart';

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
    final response = await http.get(Uri.parse('http://10.0.2.2:80/inventario/api_equipos.php'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        equipos = jsonData.map((data) {
          return Equipo(
            modelo: data['modelo'],
            numeroSerie: data['numserie'],
            numeroInventario: data['numinventario'],
            marca: data['marca'],
            ram: data['ram'],
            almacenamiento: data['almacenamiento'],
            procesador: data['procesador'],
            departamento: data['departamento'],
            direccion: data['direccion'],
            sistemaOperativo: data['sistemaoperativo'],
            versionOffice: data['versionoffice'],
            descripcion: data['descripcion'],
            imagenPath: data['imagen']
          );
        }).toList();
        _filteredEquipos = List.from(equipos);
      });
    }
  }

  Future<void> _eliminarEquipo(int index) async {
    final idEquipo = equipos[index].numeroSerie;
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
                final response = await http.post(
                  Uri.parse('http://10.0.2.2:80/inventario/api_equipos.php'),
                  body: {'id': idEquipo.toString()},
                );
                if (response.statusCode == 200){
                  print("Equipo Eliminado");
                  setState(() {
                    equipos.removeAt(index);
                    _filteredEquipos.removeAt(index);     
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('El equipo se eliminó correctamente.'),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error al eliminar el equipo.'),
                    ),
                  );
                }
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

  void _editarEquipo(int index) async {
    final equipo = _filteredEquipos[index];
    final idEquipo = equipos[index].numeroSerie;
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => EditarEquipo(
        equipo: equipo,
        onSave: (editedEquipo) async {
          try {
            Map data = {
              'id': idEquipo.toString(),
              'numserie': editedEquipo.numeroSerie,
              'numinventario': editedEquipo.numeroInventario,
              'marca': editedEquipo.marca,
              'modelo': editedEquipo.modelo,
              'ram': editedEquipo.ram,
              'almacenamiento': editedEquipo.almacenamiento,
              'procesador': editedEquipo.procesador,
              'departamento': editedEquipo.departamento,
              'dirección': editedEquipo.direccion,
              'sistemaoperativo': editedEquipo.sistemaOperativo,
              'versionoffice': editedEquipo.versionOffice,
              'descripcion': editedEquipo.descripcion
            };
            var body = jsonEncode(data);
            final response = await http.put(
            Uri.parse('http://10.0.2.2:80/inventario/api_equipos.php'),
            body: body
            );
            if (response.statusCode == 200){
              print("Actualizado");
              setState(() {
                equipos[index] = editedEquipo;
                _filteredEquipos[index] = editedEquipo;
              });
            } else {
              print("ERROR CRITICO UPDATE: ${response.statusCode}");
              print("Body: ${response.body}");
            }
          } catch (e) {
            print('Error: $e');
          }
        },
      ),
    ));
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
      title: Text('Lista de Equipos', textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
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
                colors: [const Color.fromARGB(255, 45, 49, 52), Color.fromARGB(255, 181, 222, 115)],
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
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  style: TextStyle(color: Colors.white),
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