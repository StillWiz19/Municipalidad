import 'package:flutter/material.dart';
import 'package:muniinventario/views/prestamos/prestamosproyector.dart';
import 'package:muniinventario/views/prestamos/registrarprestamoss.dart';

class MenuPrestamos extends StatelessWidget {
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
              Icon(icon, size: 32, color: Colors.blue[900]), // Ajuste del tamaño del ícono
              SizedBox(height: 8),
              Text(label,
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue[900],
                      fontFamily: 'Roboto')),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Prestamo> prestamos = [];
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Prestamos',
            textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors:  [const Color.fromARGB(255, 45, 49, 52), Color.fromARGB(255, 181, 222, 115)],
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
                context, Icons.app_registration, 'Registrar Prestamos', RegistrarPrestamos()),
            _buildMenuItem(
                context, Icons.school, 'Lista Prestamos', PrestamosProyector(prestamos: prestamos)),
          ],
        ),
      ),
    );
  }
}
