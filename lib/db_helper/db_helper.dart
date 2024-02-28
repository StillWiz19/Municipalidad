// ignore_for_file: no_leading_underscores_for_local_identifiers, avoid_print, camel_case_types

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class Db_helper{
  // ignore: body_might_complete_normally_nullable
  Future<String?> uploadImages(List<File> _imagenes) async {
    print('uploadImages called with _imagenes: $_imagenes');
    var imagenesCopy = List<File>.from(_imagenes); // Make a copy of the _imagenes list
    for (var imageFile in imagenesCopy) {
      var request = http.MultipartRequest('POST', Uri.parse('http://10.0.2.2:80/inventario/api_equipos.php'));
      request.files.add(await http.MultipartFile.fromPath('fotoReclamo', imageFile.path));
      var response = await request.send();

      if (response.statusCode == 200) {
        // Image uploaded successfully.
        var responseBody = await response.stream.bytesToString();
        print('Response: $responseBody');
        return responseBody;
      } else {
        // Error uploading image.
        print('Error uploading image from');
        return null;
      }
    }
  }
  Future<void> ingresarEquipo(
    String modelo,
    String numserie,
    String numinventario,
    String marca,
    String ram,
    String almacenamiento,
    String procesador,
    String departamento,
    String direccion,
    String sistemaoperativo,
    String versionoffice,
    String descripcion,
    List<File> imagen
  ) async {
    String? varimagen;
    if (imagen.isNotEmpty){
      varimagen = await uploadImages(imagen);
    }
    var url = Uri.parse('http://10.0.2.2:80/inventario/api_equipos.php');
    Map data = {
      'numserie': numserie,
      'numinventario': numinventario,
      'marca': marca,
      'modelo': modelo,
      'ram': ram,
      'almacenamiento': almacenamiento,
      'procesador':procesador,
      'departamento': departamento,
      'direccion': direccion,
      'sistemaoperativo': sistemaoperativo,
      'versionoffice': versionoffice,
      'descripcion': descripcion,
      'imagen':varimagen
    };
    var body = jsonEncode(data);
    final response = await http.post(url,
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: body
    );
    if (response.statusCode == 200) {
      print("Equipo registrado");
    } else {
      throw Exception('error');
    }
  }

  Future<void> ingresarInventario(
    String numserie,
    String numinventario,
    String nombreprod,
    String tipoprod
  ) async {
    var url = Uri.parse('http://10.0.2.2:80/inventario/api_inventario.php');
    Map data = {
      'numserie': numserie,
      'numinventario': numinventario,
      'nombreprod': nombreprod,
      'tipoprod': tipoprod
    };
    var body = jsonEncode(data);
    final response = await http.post(url,
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: body
    );
    if (response.statusCode == 200) {
      print("Inventario registrado");
    } else {
      throw Exception('error');
    }
  }

  Future<void> crearTicket(
    String numticket,
    String usuario,
    String departamento,
    String solicitud
  ) async {
    var url = Uri.parse('http://10.0.2.2:80/inventario/api_ticket.php');
    Map data = {
      'numticket': numticket,
      'usuario': usuario,
      'departamento': departamento,
      'solicitud': solicitud
    };
    var body = jsonEncode(data);
    final response = await http.post(url,
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: body
    );
    if (response.statusCode == 200) {
      print("Ticket creado");
    } else {
      throw Exception('error');
    }
  }

  Future<void> registrarClave(
    String nombrered,
    String departamento,
    String password,
  ) async {
    var url = Uri.parse('http://10.0.2.2:80/inventario/api_redes.php');
    Map data = {
      'nombrered': nombrered,
      'departamento': departamento,
      'password': password
    };
    var body = jsonEncode(data);
    final response = await http.post(url,
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: body
    );
    if (response.statusCode == 200) {
      print("Red registrada");
    } else {
      throw Exception('error');
    }
  }
}