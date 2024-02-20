import 'package:flutter/material.dart';
import 'package:muniinventario/views/claveswifi.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListarWifi extends StatefulWidget {
  final List<Wifi> claveswifi;

  ListarWifi({required this.claveswifi});

  @override
  _ListarWifiState createState() => _ListarWifiState();
}


class _ListarWifiState extends State<ListarWifi>{
  List<Wifi> claveswifi = [];

  @override
void initState(){
  super.initState();
  _cargarDatos();
}

  Future<void> _cargarDatos() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:80/inventario/api_redes.php'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        claveswifi = data.map((json) => Wifi(
          nombreRed: json['nombrered'],
          departamento: json['departamento'],
          contrasenia: json['password']
          )).toList();
      });
    } else {
      print ('Error: ${response.statusCode}');
    }
  }

  Future<void> _eliminarClaveWifi(int index) async {
    setState(() {
      claveswifi.removeAt(index);
    });
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de claves WIFI', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Roboto')),
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
                colors: [Colors.blue[200]!, Colors.green[200]!]
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView.builder(
                itemCount: claveswifi.length,
                itemBuilder: (context, index) {
                  final wifi = claveswifi[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(wifi.nombreRed),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8),
                            Text('Nombre de Red: ${wifi.nombreRed}'),
                            Text('Departamento: ${wifi.departamento}'),
                            Text('Contraseña: ${wifi.contrasenia}'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _eliminarClaveWifi(index),
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

