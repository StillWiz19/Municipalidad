// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, prefer_final_fields, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, library_private_types_in_public_api, avoid_print, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:muniinventario/views/inventarios/ingresoinventario.dart';

class ListaInventario extends StatefulWidget {
  final List<Inventario> inventarios;

  ListaInventario({required this.inventarios});

  @override
  _ListaInventarioState createState() => _ListaInventarioState();
}

class _ListaInventarioState extends State<ListaInventario> {
  List<Inventario> inventarios = [];
  List<Inventario> inventariosFiltrados = [];

  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:80/inventario/api_inventario.php'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        inventarios = jsonData.map((data) {
          return Inventario(
            idInventario: data['id'],
            numeroSerie: data['numserie'],
            numeroInventario: data['numinventario'],
            modelo: data['modelo'],
            nombreProducto: data['nombreprod'],
            tipoProducto: data['marca'],
            usuario: data['usuario'],
            departamento: data['departamento']
          );
        }).toList();
        inventariosFiltrados = List.from(inventarios);
      });
    }
  }

  Future<void> _eliminarInventario(int index) async {
    final idInv = inventarios[index].idInventario;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Eliminar Dispositivo"),
          content: Text("¿Estás seguro de que deseas eliminar este dispositivo?"),
          actions: [
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
                  Uri.parse('http://10.0.2.2:80/inventario/api_inventario.php'),
                  body: {'id': idInv.toString()},
                );
                if (response.statusCode == 200){
                  print("Inventario Eliminado");
                  setState(() {
                    inventarios.removeAt(index);
                    inventariosFiltrados.removeAt(index);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('El dispositivo se eliminó correctamente.'),
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

  void _filtrarInventarios(String query) {
    setState(() {
      inventariosFiltrados = inventarios.where((inventario) =>
          inventario.numeroInventario.toLowerCase().contains(query.toLowerCase()) ||
          inventario.nombreProducto.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista Inventario', textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
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
                  onChanged: _filtrarInventarios,
                  decoration: InputDecoration(
                    labelText: 'Buscar por N° Inventario o Nombre Producto',
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: inventariosFiltrados.length,
                  itemBuilder: (context, index) {
                    final inventario = inventariosFiltrados[index];
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
                              Text('Modelo: ${inventario.modelo}'),
                              Text('Dispositivo: ${inventario.nombreProducto}'),
                              Text('Marca: ${inventario.tipoProducto}'),
                              Text('Usuario: ${inventario.usuario}'),
                              Text('Departamento: ${inventario.departamento}'),
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
            ],
          ),
        ],
      ),
    );
  }
}
