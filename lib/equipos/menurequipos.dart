import 'package:flutter/material.dart';
import 'package:muniinventario/equipos/ingresarequipo.dart';
import 'package:muniinventario/equipos/listadoequipos.dart';
import 'package:muniinventario/inventarios/ingresoinventario.dart';
import 'package:muniinventario/inventarios/listainventario.dart';

class RegistrarEquipos extends StatelessWidget {

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
    List<Equipo> equipos = []; 
    List<Inventario> inventarios = [];
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Inventario',
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
                context, Icons.computer_outlined, 'Ingresar Equipos', IngresarEquipo()),
            _buildMenuItem(
                context, Icons.checklist_rtl, 'Listado de Equipos', ListadoEquipo(equipos: equipos)),
            _buildMenuItem(
                context, Icons.inventory_outlined, 'Ingreso Inventario', IngresarInventario()),
            _buildMenuItem(
                context, Icons.checklist_rtl, 'Lista Inventario', ListaInventario(inventarios: inventarios)),
          ],
        ),
      ),
    );
  }
}
