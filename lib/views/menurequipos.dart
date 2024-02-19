import 'package:flutter/material.dart';
import 'package:muniinventario/views/ingresarequipo.dart';
import 'package:muniinventario/views/listadoequipos.dart';
import 'package:muniinventario/views/ingresoinventario.dart';
import 'package:muniinventario/views/listainventario.dart';

class RegistrarEquipos extends StatelessWidget {

  @override
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
              Icon(icon, size: 48, color: Colors.blue[900]),
              SizedBox(height: 8),
              Text(label,
                  style: TextStyle(
                      fontSize: 16,
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
            textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Roboto')),
        backgroundColor: Colors.blue[900],
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[200]!, Colors.green[200]!],
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
