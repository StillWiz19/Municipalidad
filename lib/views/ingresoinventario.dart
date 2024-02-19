import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:muniinventario/views/listainventario.dart';

class Inventario {
  final String numeroSerie;
  final String numeroInventario;
  final String nombreProducto;
  final String tipoProducto;

  Inventario({
    required this.numeroSerie,
    required this.numeroInventario,
    required this.nombreProducto,
    required this.tipoProducto,
  });
}

TextEditingController _numeroSerieController = TextEditingController();
TextEditingController _numeroInventarioController = TextEditingController();
TextEditingController _nombreProductoController = TextEditingController();
TextEditingController _tipoProductoController = TextEditingController();

class IngresarInventario extends StatefulWidget {
  const IngresarInventario({Key? key}) : super(key: key);

  @override
  _IngresarInventarioState createState() => _IngresarInventarioState();
}

class _IngresarInventarioState extends State<IngresarInventario>{
  void _guardarDatos(BuildContext context) async {
    String numeroSerie = _numeroSerieController.text;
    String numeroInventario = _numeroInventarioController.text;
    String nombreProducto = _nombreProductoController.text;
    String tipoProducto = _tipoProductoController.text;

    Inventario inventario = Inventario(
      numeroSerie: numeroSerie,
      numeroInventario: numeroInventario,
      nombreProducto: nombreProducto,
      tipoProducto: tipoProducto,
    );

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> inventariosData = prefs.getStringList('inventarios') ?? [];
    inventariosData.add('${inventario.numeroSerie}|${inventario.numeroInventario}|${inventario.nombreProducto}|${inventario.tipoProducto}');
    await prefs.setStringList('inventarios', inventariosData);

    final arguments = ModalRoute.of(context)!.settings.arguments;
    if (arguments != null && arguments is ListaInventario) {
      ListaInventario listaInventario = arguments;
      listaInventario.inventarios.add(inventario);
    }
    

    _numeroSerieController.clear();
    _numeroInventarioController.clear();
    _nombreProductoController.clear();
    _tipoProductoController.clear();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog( 
          title: Text("Datos Guardados"),
          content: Text("Los datos han sido guardados correctamente."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cerrar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registrar Inventario')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextField(
              controller: _numeroSerieController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "N° de serie"
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextField(
              controller: _numeroInventarioController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "N° de Inventario"
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextField(
              controller: _nombreProductoController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Dispositivo"
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextField(
              controller: _tipoProductoController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Tipo Producto"
              ),
            ),
          ),
          ElevatedButton(
            onPressed: (){
              _guardarDatos(context);
            }, 
            child: Text("Guardar"),
          )
        ],
      ),
    );
  }
}




  
  