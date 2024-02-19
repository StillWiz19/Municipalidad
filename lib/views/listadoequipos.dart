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
              modelo: equipoData[0],
              numeroSerie: equipoData[1],
              numeroInventario: equipoData[2],
              marca: equipoData[3],
              ram: equipoData[4],
              almacenamiento: equipoData[5],
              departamento: equipoData[6],
              direccion: equipoData[7],
              sistemaOperativo: equipoData[8],
              versionOffice: equipoData[9],
            );
          } else {
            return Equipo(
              modelo: 'Ideapad',
              numeroSerie: '111',
              numeroInventario: '1',
              marca: 'Lenovo',
              ram: '4GB',
              almacenamiento: '1TB',
              departamento: 'Administración',
              direccion: 'No se',
              sistemaOperativo: 'Windows 10',
              versionOffice: '365',
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
        widget.equipos.map((equipo) => '${equipo.modelo}|${equipo.numeroSerie}|${equipo.numeroInventario}|${equipo.marca}|${equipo.ram}|${equipo.almacenamiento}|${equipo.departamento}|${equipo.direccion}|${equipo.sistemaOperativo}|${equipo.versionOffice}').toList());
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
