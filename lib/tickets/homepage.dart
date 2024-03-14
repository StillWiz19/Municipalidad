import 'package:flutter/material.dart';
import 'package:muniinventario/wifi/menuotros.dart';
import 'package:muniinventario/equipos/menurequipos.dart';
import 'package:muniinventario/prestamos/menuprestamos.dart';
import 'package:muniinventario/tickets/menutickets.dart';

class HomePage extends StatelessWidget {
  Widget _buildMenuItem(
      BuildContext context, IconData icon, String label, Widget? page) {
    if (page == null) {
      return Container();
    }
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => page));
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: Colors.blue[900]), 
              SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(fontSize: 14, color: Colors.blue[900]), 
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool exitConfirmed = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('¿Salir?'),
            content: Text('¿Estás seguro de que quieres salir de la aplicación?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false), 
                child: Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true), 
                child: Text('Sí'),
              ),
            ],
          ),
        );
        return exitConfirmed ?? false; 
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Menu Principal', textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.black,
          centerTitle: true,
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [const Color.fromARGB(255, 45, 49, 52), Color.fromARGB(255, 181, 222, 115)],
            ),
          ),
          child: GridView.count(
            crossAxisCount: 2,
            padding: EdgeInsets.all(16),
            childAspectRatio: 1.3,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: [
              _buildMenuItem(
                  context, Icons.work, 'Ticket Soporte', MenuTickets()),
              _buildMenuItem(
                  context, Icons.school, 'Prestamos', MenuPrestamos()),
              _buildMenuItem(context, Icons.inventory_outlined,
                  'Registrar Equipos', RegistrarEquipos()),
              _buildMenuItem(context, Icons.computer_outlined, 'Otros',
                  MenuOtros()),
            ],
          ),
        ),
      ),
    );
  }
}

