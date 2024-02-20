import 'package:flutter/material.dart';
import 'package:muniinventario/views/creartickets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListaTickets extends StatefulWidget {
  final List<Ticket> tickets;

  ListaTickets({required this.tickets});

  @override
  _ListaTicketState createState() => _ListaTicketState();
}

class _ListaTicketState extends State<ListaTickets>{
  List<Ticket> tickets = [];

  @override
  void initState(){
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async{
    final response = await http.get(Uri.parse('http://10.0.2.2:80/inventario/api_ticket.php'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        tickets = data.map((json) => Ticket(
              numeroTicket: json['numticket'],
              usuario: json['usuario'],
              departamento: json['departamento'],
              solicitud: json['solicitud']
            )).toList();
      });
    } else {
      print ('Error: ${response.statusCode}');
    }
  }

  Future<void> _eliminarTicket(int index) async{
    setState(() {
      tickets.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tickets', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Roboto')),
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
                colors: [Colors.blue[200]!, Colors.green[200]!],
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView.builder(
                itemCount: tickets.length,
                itemBuilder: (context, index) {
                  final ticket = tickets[index];
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
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _eliminarTicket(index),
                        ),
                      ),
                    )
                  );
                },
              ),
            ),
          )
        ],
      ),
    );

  }




}