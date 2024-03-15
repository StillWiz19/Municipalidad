import 'package:flutter/material.dart';
import 'package:muniinventario/views/prestamos/registrarprestamoss.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrestamosProyector extends StatefulWidget {
  final List<Prestamo> prestamos;

  PrestamosProyector({required this.prestamos});

  @override
  _PrestamoProyectorState createState() => _PrestamoProyectorState();
}

class _PrestamoProyectorState extends State<PrestamosProyector> {
  List<Prestamo> prestamos = [];
  List<Prestamo> prestamosFiltrados = [];

  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> prestamosData = prefs.getStringList('prestamos') ?? [];
    setState(() {
      prestamos = prestamosData.map((data) {
        List<String> prestamosData = data.split('|');
        return Prestamo(
          numeroSerie: prestamosData[0],
          usuario: prestamosData[1],
          departamento: prestamosData[2],
          dispositivo: prestamosData[3],
          motivo: prestamosData[4],
          fecha: prestamosData.length > 5 ? prestamosData[5] : "",
        );
      }).toList();
      prestamosFiltrados = List.from(prestamos);
    });
  }

  Future<void> _eliminarPrestamo(int index) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Eliminar Préstamo"),
          content: Text("¿Estás seguro de que deseas eliminar este préstamo?"),
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
                await _confirmarEliminarPrestamo(index);
              },
              child: Text("Eliminar"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmarEliminarPrestamo(int index) async {
    setState(() {
      prestamos.removeAt(index);
      prestamosFiltrados.removeAt(index);
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('prestamos',
        prestamos.map((prestamo) => '${prestamo.numeroSerie}|${prestamo.usuario}|${prestamo.departamento}|${prestamo.dispositivo}|${prestamo.motivo}|${prestamo.fecha}').toList());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('El préstamo se eliminó correctamente.'),
      ),
    );
  }

  void _filtrarPrestamos(String query) {
    setState(() {
      prestamosFiltrados = prestamos.where((prestamo) =>
          prestamo.numeroSerie.toLowerCase().contains(query.toLowerCase()) ||
          prestamo.usuario.toLowerCase().contains(query.toLowerCase()) ||
          prestamo.departamento.toLowerCase().contains(query.toLowerCase()) ||
          prestamo.fecha.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Préstamos', textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
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
                  onChanged: _filtrarPrestamos,
                  decoration: InputDecoration(
                    labelText: 'Buscar por Usuario o N° serie',
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: prestamosFiltrados.length,
                  itemBuilder: (context, index) {
                    final prestamo = prestamosFiltrados[index];
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
                              Text('Dispositivo: ${prestamo.dispositivo}'),
                              Text('Motivos: ${prestamo.motivo}'),
                              Text('Fecha de Préstamo: ${prestamo.fecha}'),
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
            ],
          ),
        ],
      ),
    );
  }
}
