import 'package:flutter/material.dart';
import 'package:muniinventario/views/registrarprestamoss.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrestamosProyector extends StatefulWidget {
  final List<Prestamo> prestamos;

  PrestamosProyector({required this.prestamos});

  @override
  _PrestamoProyectorState createState() => _PrestamoProyectorState();
}

class _PrestamoProyectorState extends State<PrestamosProyector> {
  List<Prestamo> prestamos = [];

  @override
  void initState(){
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> prestamosData = prefs.getStringList('prestamos') ?? [];
    setState(() {
      prestamos = prestamosData.map((data) {
        List<String> prestamosData = data.split('|');
        return Prestamo(
          numeroSerie: prestamosData[0],
          usuario: prestamosData[1],
          departamento: prestamosData[2],
          motivo: prestamosData[3],
          fecha: prestamosData[4],
        );
      }).toList();
    });
  }

  Future<void> _eliminarPrestamo(int index) async{
    setState(() {
      prestamos.removeAt(index);
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('prestamos', 
      prestamos.map((prestamo) => '${prestamo.numeroSerie}|${prestamo.usuario}|${prestamo.departamento}|${prestamo.motivo}|${prestamo.fecha}').toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Prestamos', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Roboto')),
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
                colors: [Colors.blue[200]!, Colors.green[200]!],
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView.builder(
                itemCount: prestamos.length,
                itemBuilder: (context, index) {
                  final prestamo = prestamos[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),                       
                      ),
                      child: ListTile(
                        title: Text(prestamo.numeroSerie),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8),
                            Text('N° de Serie: ${prestamo.numeroSerie}'),
                            Text('Usuario: ${prestamo.usuario}'),
                            Text('Departamento: ${prestamo.departamento}'),
                            Text('¿Para que será el uso del proyector?: ${prestamo.motivo}'),
                            Text('Fecha de Prestamo: ${prestamo.fecha}'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _eliminarPrestamo(index),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
