import 'package:flutter/material.dart';
import 'package:muniinventario/views/ingresarequipo.dart';

class BuscarEquipos extends StatefulWidget{
  final List<Equipo> equipos;

  const BuscarEquipos({Key? key, required this.equipos}) : super(key: key);

  @override
  _BuscarEquiposState createState() => _BuscarEquiposState();
}

class _BuscarEquiposState extends State<BuscarEquipos> {
  List<Equipo> _equiposFiltrados = [];
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _equiposFiltrados.addAll(widget.equipos);
    _searchController = TextEditingController();
    _searchController.addListener(_filtrarEquipos);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filtrarEquipos() {
    String query = _searchController.text.toLowerCase();
    List<Equipo> resultados = [];
    if (query.isNotEmpty) {
      resultados = widget.equipos.where((equipo) {
        return equipo.numeroSerie.toLowerCase().contains(query) ||
            equipo.numeroInventario.toLowerCase().contains(query) ||
            equipo.marca.toLowerCase().contains(query) ||
            equipo.modelo.toLowerCase().contains(query) ||
            equipo.usuario.toLowerCase().contains(query) ||
            equipo.departamento.toLowerCase().contains(query) ||
            equipo.sistemaOperativo.toLowerCase().contains(query) ||
            equipo.versionOffice.toLowerCase().contains(query);
      }).toList();
    } else {
      resultados.addAll(widget.equipos);
    }
    setState(() {
      _equiposFiltrados.clear();
      _equiposFiltrados.addAll(resultados);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buscar Equipos'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
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
              itemCount: _equiposFiltrados.length,
              itemBuilder: (context, index) {
                final equipo = _equiposFiltrados[index];
                return ListTile(
                  title: Text(equipo.modelo),
                  subtitle: Text(equipo.marca),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}



  
