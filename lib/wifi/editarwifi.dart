import 'package:flutter/material.dart';
import 'package:muniinventario/wifi/claveswifi.dart';

class EditarWifi extends StatefulWidget {
  final Wifi wifi;
  final Function(Wifi) onSave;

  EditarWifi({required this.wifi, required this.onSave});

  @override
  _EditarWifiState createState() => _EditarWifiState();
}

class _EditarWifiState extends State<EditarWifi> {
  late TextEditingController _nombreRedController;
  late TextEditingController _departamentoController;
  late TextEditingController _contraseniaController;

  @override
  void initState() {
    super.initState();
    _nombreRedController = TextEditingController(text: widget.wifi.nombreRed);
    _departamentoController = TextEditingController(text: widget.wifi.departamento);
    _contraseniaController = TextEditingController(text: widget.wifi.contrasenia);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Clave WiFi', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Roboto')),
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
                colors: [const Color.fromARGB(255, 45, 49, 52), Color.fromARGB(255, 181, 222, 115)],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _nombreRedController,
                  decoration: InputDecoration(labelText: 'Nombre de Red'),
                ),
                TextField(
                  controller: _departamentoController,
                  decoration: InputDecoration(labelText: 'Departamento'),
                ),
                TextField(
                  controller: _contraseniaController,
                  decoration: InputDecoration(labelText: 'Contraseña'),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    final editedWifi = Wifi(
                      nombreRed: _nombreRedController.text,
                      departamento: _departamentoController.text,
                      contrasenia: _contraseniaController.text,
                    );
                    widget.onSave(editedWifi);
                    Navigator.of(context).pop();
                  },
                  child: Text('Guardar Cambios'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
