import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:muniinventario/views/ingresarequipo.dart';
import 'package:http/http.dart' as http;

class Db_helper{
  Future<void> ingresarEquipo(
    String modelo,
    String numserie,
    String numinventario,
    String marca,
    String ram,
    String almacenamiento,
    String departamento,
    String direccion,
    String sistemaoperativo,
    String versionoffice,
  ) async {
    var url = Uri.parse('http://10.0.2.2:80/inventario/api_equipos.php');
    Map data = {
      'numserie': numserie,
      'numinventario': numinventario,
      'marca': marca,
      'modelo': modelo,
      'ram': ram,
      'almacenamiento': almacenamiento,
      'departamento': departamento,
      'direccion': direccion,
      'sistemaoperativo': sistemaoperativo,
      'versionoffice': versionoffice
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