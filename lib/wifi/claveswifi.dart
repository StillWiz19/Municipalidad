import 'package:flutter/material.dart';
import 'package:muniinventario/wifi/listawifi.dart';
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

class ClavesWifi extends StatefulWidget {
  const ClavesWifi({Key? key}) : super(key: key);

  @override
  _ClavesWifiState createState() => _ClavesWifiState();
}

class _ClavesWifiState extends State<ClavesWifi> {
  TextEditingController nombreRedController = TextEditingController();
  TextEditingController departamentoController = TextEditingController();
  TextEditingController contraseniaController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Agregar Claves WIFI')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextFormField(
                controller: nombreRedController,
                labelText: "Nombre de Red",
                prefixIcon: Icons.wifi,
              ),
              _buildTextFormField(
                controller: departamentoController,
                labelText: "Departamento",
                prefixIcon: Icons.work,
              ),
              _buildTextFormField(
                controller: contraseniaController,
                labelText: "Contraseña",
                prefixIcon: Icons.password,
                isPassword: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _guardarDatos(context);
                  }
                },
                child: Text("Agregar Clave"),
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
    required IconData prefixIcon,
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: labelText,
          prefixIcon: Icon(prefixIcon),
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
  }
}
