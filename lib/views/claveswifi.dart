import 'package:flutter/material.dart';
import 'package:muniinventario/db_helper/db_helper.dart';
import 'package:muniinventario/views/listawifi.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Wifi {
  final String nombreRed;
  final String departamento;
  final String contrasenia;

  Wifi({
    required this.nombreRed,
    required this.departamento,
    required this.contrasenia,
  });
}

    TextEditingController _nombreRedController = TextEditingController();
    TextEditingController _departamentoController = TextEditingController();
    TextEditingController _contraseniaController = TextEditingController();

class ClavesWifi extends StatefulWidget{
  const ClavesWifi({Key? key}) : super(key: key);

  @override
  _ClavesWifiState createState() => _ClavesWifiState();
}

class _ClavesWifiState extends State<ClavesWifi>{
  void _guardarDatos(BuildContext context) async {
    Db_helper db = Db_helper();

    db.registrarClave(
      _nombreRedController.text,
      _departamentoController.text,
      _contraseniaController.text
    );

    void _limpiarCajas() {
      _nombreRedController.clear();
      _departamentoController.clear();
      _contraseniaController.clear(); 
    }

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
    _limpiarCajas();
  }

   @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text('Agregar Claves WIFI')),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: TextField(
            controller: _nombreRedController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Nombre de Red",
              prefixIcon: Icon(Icons.wifi)
            ),
          ),   
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
              controller: _departamentoController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Departamento",
                prefixIcon: Icon(Icons.work)
              ),
            ),
        ), 
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
                controller: _contraseniaController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Contraseña",
                  prefixIcon: Icon(Icons.password)
                ),
              ),
        ),
        ElevatedButton(
            onPressed: (){
              _guardarDatos(context);
            }, 
            child: Text("Agregar Clave"),
          )
        ],
      ),
    );
  }
}




 
