// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, library_private_types_in_public_api, use_key_in_widget_constructors, prefer_const_constructors_in_immutables
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:muniinventario/views/tickets/creartickets.dart';

class ListaTickets extends StatefulWidget {
  final List<Ticket> tickets;

  ListaTickets({required this.tickets});

  @override
  _ListaTicketState createState() => _ListaTicketState();
}

class _ListaTicketState extends State<ListaTickets>{
  List<Ticket> tickets = [];
  List<Ticket> filteredTickets = [];

  TextEditingController _searchController = TextEditingController();

  @override
  void initState(){
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async{
    final response = await http.get(Uri.parse('http://10.0.2.2:80/inventario/api_ticket.php'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        tickets = jsonData.map((data){
          return Ticket(
            numeroTicket: data['numticket'],
            usuario: data['numticket'],
            departamento: data['numticket'],
            solicitud: data['numticket'],
            aceptado: jsonData.length > 4 && jsonData[4] == 'aceptado' ? true : false,
          );
        }).toList();
        filteredTickets.addAll(tickets); 
      });
    }
  }

  Future<void> _eliminarTicket(int index) async{
    showDialog(
      context: context, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Eliminar Ticket"),
          content: Text("¿Estás seguro de que deseas eliminar este ticket?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () async{
                Navigator.of(context).pop();
                await _confirmarEliminarTicket(index);
              },
              child: Text("Eliminar"),
            )
          ],
        );
      },
    );
  }

  Future<void> _confirmarEliminarTicket(int index) async{
    final idTicket = tickets[index].numeroTicket;
    final response = await http.post(
      Uri.parse('http://10.0.2.2:80/inventario/api_ticket.php'),
      body: {'id': idTicket.toString()}
    );
    if (response.statusCode == 200) {
      print("Ticket Eliminado");
      setState(() {
        tickets.removeAt(index);
        filteredTickets.removeAt(index);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('El ticket se eliminó correctamente'),
          )
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al eliminar el ticket.'),
        ),
      );
    }
  }

  void _aceptarTicket(int index) {
    setState(() {
      tickets[index].aceptado = true;
    });
  }

  void _rechazarTicket(int index) {
    setState(() {
      tickets[index].aceptado = false;
    });
  }

  void _filtrarTickets(String query) {
    setState(() {
      filteredTickets = tickets.where((ticket) =>
          ticket.numeroTicket.toLowerCase().contains(query.toLowerCase()) ||
          ticket.usuario.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tickets', textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
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
                  controller: _searchController,
                  onChanged: _filtrarTickets,
                  decoration: InputDecoration(
                    labelText: 'Buscar ticket o usuario',
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredTickets.length,
                  itemBuilder: (context, index) {
                    final ticket = filteredTickets[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          title: Text(ticket.numeroTicket),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 8),
                              Text('N° de Ticket: ${ticket.numeroTicket}'),
                              Text('Usuario: ${ticket.usuario}'),
                              Text('Departamento: ${ticket.departamento}'),
                              Text('Que Solicita: ${ticket.solicitud}'),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.check, color: ticket.aceptado ? Colors.green : null),
                                onPressed: () => _aceptarTicket(index),
                              ),

                              IconButton(
                                icon: Icon(Icons.close, color: ticket.aceptado ? null : Colors.red),
                                onPressed: () => _rechazarTicket(index),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => _eliminarTicket(index),
                              )
                            ],
                          ),
                        ),
                      )
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
