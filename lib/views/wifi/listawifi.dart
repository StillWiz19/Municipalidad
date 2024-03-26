import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:muniinventario/views/wifi/claveswifi.dart';
import 'package:muniinventario/views/wifi/editarwifi.dart';

class ListarWifi extends StatefulWidget {
  final List<Wifi> claveswifi;

  ListarWifi({required this.claveswifi});

  @override
  _ListarWifiState createState() => _ListarWifiState();
}

class _ListarWifiState extends State<ListarWifi> {
  List<Wifi> claveswifi = [];
  List<Wifi> claveswifiFiltradas = [];

  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    final response =await http.get(Uri.parse('http://10.0.2.2:80/inventario/api_redes.php'));
    if (response.statusCode == 200){
      final List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        claveswifi = jsonData.map((data) {
          return Wifi(
            nombreRed: data['nombrered'],
            departamento: data['departamento'],
            contrasenia: data['password'],
          );
        }).toList();
        claveswifiFiltradas = List.from(claveswifi);
      });
    }
  }

  Future<void> _eliminarClaveWifi(int index) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Eliminar Clave WiFi"),
          content: Text("¿Estás seguro de que deseas eliminar esta clave WiFi?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _confirmarEliminarClaveWifi(index);
              },
              child: Text("Eliminar"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmarEliminarClaveWifi(int index) async {
    final idRed = claveswifi[index].nombreRed;
    final response = await http.post(
      Uri.parse('http://10.0.2.2:80/inventario/api_redes.php'),
      body: {'id': idRed.toString()}
    );
    if (response.statusCode == 200){
      print('Red Eliminada');
      setState(() {
        claveswifi.removeAt(index);
        claveswifiFiltradas.removeAt(index);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('La clave WiFi se eliminó correctamente.'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al eliminar la red')
        )
      );
    }
  }

  void _filtrarClavesWifi(String query) {
    setState(() {
      claveswifiFiltradas = claveswifi.where((wifi) =>
          wifi.nombreRed.toLowerCase().contains(query.toLowerCase()) ||
          wifi.departamento.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  void _editarClaveWifi(int index) {
    final wifi = claveswifiFiltradas[index];
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => EditarWifi(
        wifi: wifi,
        onSave: (editedWifi) {
          setState(() {
            claveswifi[index] = editedWifi;
            claveswifiFiltradas[index] = editedWifi;
          });
        },
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de las claves WIFI', textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
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
                  onChanged: _filtrarClavesWifi,
                  decoration: InputDecoration(
                    labelText: 'Buscar por Departamento',
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Expanded(
                child: claveswifiFiltradas.isEmpty ?
                Center(
                  child: Text('No hay claves registradas', style: TextStyle(color: Colors.white, fontSize: 16)),
                ) :
                ListView.builder(
                  itemCount: claveswifiFiltradas.length,
                  itemBuilder: (context, index) {
                    final wifi = claveswifiFiltradas[index];
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
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () => _editarClaveWifi(index),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => _eliminarClaveWifi(index),
                              ),
                            ],
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
