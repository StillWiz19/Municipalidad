import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:muniinventario/inventarios/ingresoinventario.dart';

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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> inventariosData = prefs.getStringList('inventarios') ?? [];
    setState(() {
      inventarios = inventariosData.map((data) {
        List<String> inventarioData = data.split('|');
        return Inventario(
          numeroSerie: inventarioData.length > 0 ? inventarioData[0] : "",
          numeroInventario: inventarioData.length > 1 ? inventarioData[1] : "",
          modelo: inventarioData.length > 2 ? inventarioData[2] : "",
          nombreProducto: inventarioData.length > 3 ? inventarioData[3] : "",
          tipoProducto: inventarioData.length > 4 ? inventarioData[4] : "",
          usuario: inventarioData.length > 5 ? inventarioData[5] : "",
          departamento: inventarioData.length > 6 ? inventarioData[6] : "",
        );
      }).toList();
      inventariosFiltrados = List.from(inventarios);
    });
  }

  Future<void> _eliminarInventario(int index) async {
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
                setState(() {
                  inventarios.removeAt(index);
                  inventariosFiltrados.removeAt(index);
                });

                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setStringList(
                    'inventarios',
                    inventarios
                        .map((inventario) =>
                            '${inventario.numeroSerie}|${inventario.numeroInventario}|${inventario.modelo}|${inventario.nombreProducto}|${inventario.tipoProducto}|${inventario.usuario}|${inventario.departamento}')
                        .toList());

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('El dispositivo se eliminó correctamente.'),
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
