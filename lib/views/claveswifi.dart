import 'package:flutter/material.dart';
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

    TextEditingController nombreRedController = TextEditingController();
    TextEditingController departamentoController = TextEditingController();
    TextEditingController contraseniaController = TextEditingController();

class ClavesWifi extends StatefulWidget{
  const ClavesWifi({Key? key}) : super(key: key);

  @override
  _ClavesWifiState createState() => _ClavesWifiState();
}

class _ClavesWifiState extends State<ClavesWifi>{
  void _guardarDatos(BuildContext context) async {
    String nombreRed = nombreRedController.text;
    String departamento = departamentoController.text;
    String contrasenia = contraseniaController.text;

    Wifi wifi = Wifi(
      nombreRed: nombreRed,
      departamento: departamento,
      contrasenia: contrasenia,
    );

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> wifiData = prefs.getStringList('wifi') ?? [];
    wifiData.add('${wifi.nombreRed}|${wifi.departamento}|${wifi.contrasenia}');
    await prefs.setStringList('wifi', wifiData);

    final arguments = ModalRoute.of(context)!.settings.arguments;
    if (arguments != null && arguments is ListarWifi) {
      ListarWifi listarWifi = arguments;
      listarWifi.claveswifi.add(wifi);
    }

    nombreRedController.clear();
    departamentoController.clear();
    contraseniaController.clear();

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
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text('Agregar Claves WIFI')),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: TextField(
            controller: nombreRedController,
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
              controller: departamentoController,
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
                controller: contraseniaController,
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




 
