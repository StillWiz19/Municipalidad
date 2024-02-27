import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:muniinventario/inventarios/listainventario.dart';

class Inventario {
  final String numeroSerie;
  final String numeroInventario;
  final String modelo;
  final String nombreProducto;
  final String tipoProducto;
  final String usuario;
  final String departamento;

  Inventario({
    required this.numeroSerie,
    required this.numeroInventario,
    required this.modelo,
    required this.nombreProducto,
    required this.tipoProducto,
    required this.usuario,
    required this.departamento,
  });
}

class IngresarInventario extends StatefulWidget {
  const IngresarInventario({Key? key}) : super(key: key);

  @override
  _IngresarInventarioState createState() => _IngresarInventarioState();
}

class _IngresarInventarioState extends State<IngresarInventario>{
  TextEditingController _numeroSerieController = TextEditingController();
  TextEditingController _numeroInventarioController = TextEditingController();
  TextEditingController _modeloController = TextEditingController();
  TextEditingController _nombreProductoController = TextEditingController();
  TextEditingController _tipoProductoController = TextEditingController();
  TextEditingController _usuarioController = TextEditingController();
  TextEditingController _departamentoController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registrar Inventario', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Roboto')),
      backgroundColor: Color.fromARGB(255, 43, 74, 165),
      centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextFormField(
                controller: _numeroSerieController,
                labelText: "N° de serie",
              ),
              _buildTextFormField(
                controller: _numeroInventarioController,
                labelText: "N° de Inventario",
              ),
              _buildTextFormField(
                controller: _modeloController,
                labelText: "Modelo",
              ),
              _buildTextFormField(
                controller: _nombreProductoController,
                labelText: "Dispositivo",
              ),
              _buildTextFormField(
                controller: _tipoProductoController,
                labelText: "Marca",
              ),
              _buildTextFormField(
                controller: _usuarioController,
                labelText: "Usuario"
              ),
              _buildTextFormField(
                controller: _departamentoController,
                labelText: "Departamento",
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _guardarDatos(context);
                  }
                },
                child: Text("Guardar"),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: labelText,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor ingresa este campo';
          }
          return null;
        },
      ),
    );
  }

  void _guardarDatos(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      String numeroSerie = _numeroSerieController.text;
      String numeroInventario = _numeroInventarioController.text;
      String modelo = _modeloController.text;
      String nombreProducto = _nombreProductoController.text;
      String tipoProducto = _tipoProductoController.text;
      String usuario = _usuarioController.text;
      String departamento = _departamentoController.text;

      Inventario inventario = Inventario(
        numeroSerie: numeroSerie,
        numeroInventario: numeroInventario,
        modelo: modelo,
        nombreProducto: nombreProducto,
        tipoProducto: tipoProducto,
        usuario: usuario,
        departamento: departamento,
      );

      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> inventariosData = prefs.getStringList('inventarios') ?? [];
      inventariosData.add('${inventario.numeroSerie}|${inventario.numeroInventario}|${inventario.modelo}|${inventario.nombreProducto}|${inventario.tipoProducto}|${inventario.usuario}|${inventario.departamento}');
      await prefs.setStringList('inventarios', inventariosData);

      final arguments = ModalRoute.of(context)!.settings.arguments;
      if (arguments != null && arguments is ListaInventario) {
        ListaInventario listaInventario = arguments;
        listaInventario.inventarios.add(inventario);
      }

      _limpiarCampos();

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
  }

  void _limpiarCampos() {
    _numeroSerieController.clear();
    _numeroInventarioController.clear();
    _modeloController.clear();
    _nombreProductoController.clear();
    _tipoProductoController.clear();
    _usuarioController.clear();
    _departamentoController.clear();
  }
}





  
  