import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:muniinventario/views/ingresarequipo.dart';

class ListadoEquipo extends StatefulWidget {
  final List<Equipo> equipos;

  ListadoEquipo({required this.equipos});

  @override
  _ListaEquipoState createState() => _ListaEquipoState();
}

class _ListaEquipoState extends State<ListadoEquipo> {
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
        widget.equipos.addAll(equiposData.map((data) {
          List<String> equipoData = data.split('|');
          if (equipoData.length >= 10) {
            return Equipo(
              numeroSerie: equipoData[0],
              numeroInventario: equipoData[1],
              marca: equipoData[2],
              modelo: equipoData[3],
              ram: equipoData[4],
              almacenamiento: equiposData[5],
              usuario: equipoData[6],
              departamento: equipoData[7],
              direccion: equipoData[8],
              sistemaOperativo: equipoData[9],
              versionOffice: equipoData[10],
            );
          } else {
            return Equipo(
              numeroSerie: 'N/A',
              numeroInventario: 'N/A',
              marca: 'N/A',
              modelo: 'N/A',
              ram: 'N/A',
              almacenamiento: 'N/A',
              usuario: 'N/A',
              departamento: 'N/A',
              direccion: 'N/A',
              sistemaOperativo: 'N/A',
              versionOffice: 'N/A',
            );
          }
        }));
      });
    }
  }

  Future<void> _eliminarEquipo(int index) async {
    setState(() {
      widget.equipos.removeAt(index);
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('equipos',
        widget.equipos.map((equipo) => '${equipo.numeroSerie}|${equipo.numeroInventario}|${equipo.marca}|${equipo.modelo}|${equipo.ram}|${equipo.almacenamiento}|${equipo.usuario}|${equipo.departamento}|${equipo.direccion}|${equipo.sistemaOperativo}|${equipo.versionOffice}').toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Equipos', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Roboto')),
        backgroundColor: Colors.blue[900],
        centerTitle: true,

      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.blue[200]!, Colors.green[200]!], // Gradient colors
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: widget.equipos.length,
                itemBuilder: (context, index) {
                  final equipo = widget.equipos[index];
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
                            Text('N° de Serie: ${equipo.numeroSerie}'),
                            Text('N° de Inventario: ${equipo.numeroInventario}'),
                            Text('Marca: ${equipo.marca}'),
                            Text('Modelo: ${equipo.modelo}'),
                            Text('Ram: ${equipo.ram}'),
                            Text('Almacenamiento: ${equipo.almacenamiento}'),
                            Text('Usuario: ${equipo.usuario}'),
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









