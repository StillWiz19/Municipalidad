import 'package:flutter/material.dart';
import 'package:muniinventario/views/ingresarequipo.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListadoEquipo extends StatefulWidget {
  final List<Equipo> equipos;
  ListadoEquipo({required this.equipos});

  @override
  _ListaEquipoState createState() => _ListaEquipoState();
}

class _ListaEquipoState extends State<ListadoEquipo> {
  List<Equipo> equipos = [];
  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:80/inventario/api_equipos.php'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        equipos = data.map((json) => Equipo(
              modelo: json['modelo'],
              numeroSerie: json['numserie'],
              numeroInventario: json['numinventario'],
              marca: json['marca'],
              ram: json['ram'],
              almacenamiento: json['almacenamiento'],
              departamento: json['departamento'],
              direccion: json['direccion'],
              sistemaOperativo: json['sistemaoperativo'],
              versionOffice: json['versionoffice'],
            )).toList();
      });
    } else {
      print ('Error: ${response.statusCode}');
    }
  }

  Future<void> _eliminarEquipo(int index) async {
    setState(() {
      equipos.removeAt(index);
    });
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
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: equipos.length,
                itemBuilder: (context, index) {
                  final equipo = equipos[index];
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
                            Text('Departamento: ${equipo.departamento}'),
                            Text('Direccion: ${equipo.direccion}'),
                            Text('Sistema Operativo: ${equipo.sistemaOperativo}'),
                            Text('Version de Office: ${equipo.versionOffice}'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _eliminarEquipo(index),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
