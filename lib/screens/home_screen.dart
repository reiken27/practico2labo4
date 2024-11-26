import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Importa este paquete para SystemNavigator.pop()
import 'package:practico2labo4/widgets/drawer_menu.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pokémons',
          style: TextStyle(
            fontFamily: 'PokemonFont', // Fuente personalizada
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leadingWidth: 40,
        toolbarHeight: 80,
        backgroundColor: Colors.blueAccent, // Color de fondo del AppBar
        actions: [
          // Botón para salir de la APP
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            color: Colors.white,
            onPressed: () {
              SystemNavigator.pop();
            },
          ),
        ],
      ),
      drawer: DrawerMenu(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/pokemon-wall.png', // Ruta de la imagen
              width: 400, // Ancho de la imagen
              height: 400, // Alto de la imagen
              fit: BoxFit.cover, 
            ),
            const SizedBox(height: 20),
            // Texto debajo de la imagen
            const Text(
              '¡Bienvenidos al mundo Pokémon!',
              style: TextStyle(
                fontFamily: 'PokemonFont',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
            ),
          ],
        ),
      ),

    );
  }
}


