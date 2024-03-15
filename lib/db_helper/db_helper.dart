// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;

class Db_helper{
  Future<void> ingresarEquipo(
    String numserie,
    String numinventario,
    String marca,
    String modelo,
    String ram,
    String almacenamiento,
    String procesador,
    String departamento,
    String direccion,
    String sistemaoperativo,
    String versionoffice,
    String descripcion,
    String foto
  ) async {
    var url = Uri.parse('http://10.0.2.2:80/inventario/api_equipos.php');
    Map data = {
      'numserie': numserie,
      'numinventario': numinventario,
      'marca': marca,
      'modelo': modelo,
      'ram': ram,
      'almacenamiento': almacenamiento,
      'procesador': procesador,
      'departamento': departamento,
      'direccion': direccion,
      'sistemaoperativo': sistemaoperativo,
      'versionoffice': versionoffice,
      'descripcion': descripcion,
      'foto': foto
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
    String modelo,
    String nombreprod,
    String marca,
    String usuario,
    String departamento
  ) async {
    var url = Uri.parse('http://10.0.2.2:80/inventario/api_inventario.php');
    Map data = {
      'numserie': numserie,
      'numinventario': numinventario,
      'modelo': modelo,
      'nombreprod': nombreprod,
      'marca': marca,
      'usuario': usuario,
      'departamento': departamento
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

  Future<void> registrarPrestamo(
  String numserie,
  String usuario,
  String departamento,
  String dispositivo,
  String motivos,
  String fecha
  ) async {
    var url = Uri.parse('http://10.0.2.2:80/inventario/api_prestamos.php');
    Map data = {
      'numserie': numserie,
      'usuario': usuario,
      'departamento': departamento,
      'dispositivo': dispositivo,
      'motivos': motivos,
      'fechaprestamo': fecha
    };
    var body = jsonEncode(data);
    final response = await http.post(url,
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: body
    );
    if (response.statusCode == 200) {
      print("Prestamo registrado");
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