import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:muniinventario/tickets/creartickets.dart';

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
          aceptado: ticketsData.length > 4 && ticketsData[4] == 'aceptado' ? true : false,
        );
      }).toList();
      filteredTickets.addAll(tickets); 
    });
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
    setState(() {
      tickets.removeAt(index);
      filteredTickets.removeAt(index);
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('tickets', 
    tickets.map((ticket) => '${ticket.numeroTicket}|${ticket.usuario}|${ticket.departamento}|${ticket.solicitud}|${ticket.aceptado ? "aceptado" : "rechazado"}').toList());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('El ticket se eliminó correctamente'),
        )
    );
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
                  ),
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
