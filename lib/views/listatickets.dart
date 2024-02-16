import 'package:flutter/material.dart';
import 'package:muniinventario/views/creartickets.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> ticketsData = prefs.getStringList('tickets') ?? [];
    setState(() {
      tickets = ticketsData.map((data){
        List<String> ticketsData = data.split('|');
        return Ticket(
          numeroTicket: ticketsData[0],
          usuario: ticketsData[1],
          departamento: ticketsData[2],
          solicitud: ticketsData[3],
        );
      }).toList();
    });
  }

  Future<void> _eliminarTicket(int index) async{
    setState(() {
      tickets.removeAt(index);
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('tickets', 
    tickets.map((ticket) => '${ticket.numeroTicket}|${ticket.usuario}|${ticket.departamento}|${ticket.solicitud}').toList());
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