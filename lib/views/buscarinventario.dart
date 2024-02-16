import 'package:flutter/material.dart';
import 'package:muniinventario/views/ingresoinventario.dart';

class BuscarInventarios extends StatefulWidget {
  final List<Inventario> inventarios;

  const BuscarInventarios ({Key? key, required this.inventarios}) : super(key: key);

  @override
  _BuscarInventariosState createState() => _BuscarInventariosState();

}

class _BuscarInventariosState extends State<BuscarInventarios> {
  List<Inventario> _inventariosFiltrados = [];
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _inventariosFiltrados.addAll(widget.inventarios);
    _searchController = TextEditingController();
    _searchController.addListener(_filtrarInventarios);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filtrarInventarios() {
    String query = _searchController.text.toLowerCase();
    List<Inventario> resultados = [];
    if (query.isNotEmpty) {
      resultados = widget.inventarios.where((inventario){
        return inventario.numeroSerie.toLowerCase().contains(query) ||
        inventario.numeroInventario.toLowerCase().contains(query) ||
        inventario.nombreProducto.toLowerCase().contains(query) ||
        inventario.tipoProducto.toLowerCase().contains(query);
      }).toList();
    } else{
      resultados.addAll(widget.inventarios);
    }
    setState(() {
      _inventariosFiltrados.clear();
      _inventariosFiltrados.addAll(resultados);
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Buscar Inventario'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Buscar',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _inventariosFiltrados.length,
              itemBuilder: (context, index) {
                final inventario = _inventariosFiltrados[index];
                return ListTile(
                  title: Text(inventario.nombreProducto),
                  subtitle: Text(inventario.tipoProducto),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}



