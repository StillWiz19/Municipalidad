import 'package:flutter/material.dart';
import 'package:muniinventario/views/ingresoinventario.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListaInventario extends StatefulWidget {
  final List<Inventario> inventarios;
  ListaInventario({required this.inventarios});

  @override
  _ListaInventarioState createState() => _ListaInventarioState();
}

class _ListaInventarioState extends State<ListaInventario> {
  List<Inventario> inventarios = [];

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:80/inventario/api_inventario.php'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        inventarios = data.map((json) => Inventario(
              numeroSerie: json['numserie'],
              numeroInventario: json['numinventario'],
              nombreProducto: json['nombreprod'],
              tipoProducto: json['tipoprod']
            )).toList();
      });
    } else {
      print ('Error: ${response.statusCode}');
    }
  }

  Future<void> _eliminarInventario(int index) async {
    setState(() {
      inventarios.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista Inventario', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Roboto')),
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
                itemCount: inventarios.length,
                itemBuilder: (context, index) {
                  final inventario = inventarios[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(inventario.nombreProducto),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8),
                            Text('N° de Serie: ${inventario.numeroSerie}'),
                            Text('N° de Inventario: ${inventario.numeroInventario}'),
                            Text('Tipo Producto: ${inventario.tipoProducto}'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _eliminarInventario(index),
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
