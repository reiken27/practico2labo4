import 'dart:developer' as dev;
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class DrawerMenu extends StatelessWidget {
  final List<Map<String, String>> _menuItems = <Map<String, String>>[
    {
      'route': 'home',
      'title': 'Pantalla Principal',
      'subtitle': 'Muestra pantalla principal',
      'icon': 'assets/images/pokeball_icon.png',
    },
    {
      'route': 'custom_list',
      'title': 'Nova',
      'subtitle': '',
      'icon': 'assets/images/pokeball_icon.png',
    },
    {
      'route': 'profile',
      'title': 'Configuración',
      'subtitle': 'Configuraciones',
      'icon': 'assets/images/pokeball_icon.png',
    },
    {
      'route': 'lista_movimientos',
      'title': 'Lista Movimientos',
      'subtitle': 'Ver movimientos + detalles',
      'icon': 'assets/images/pokeball_icon.png',
    },
    {
      'route': 'lista_pokemon',
      'title': 'Lista Pokémon',
      'subtitle': 'Ver Pokémon + detalles',
      'icon': 'assets/images/pokeball_icon.png',
    },
    {
      'route': 'lista_pokemonid',
      'title': 'Pokémon por ID',
      'subtitle': 'Ver Pokémon + detalles',
      'icon': 'assets/images/pokeball_icon.png',
    },
    {
      'route': 'lista_items',
      'title': 'Lista Items',
      'subtitle': 'Ver Items + detalles',
      'icon': 'assets/images/pokeball_icon.png',
    },
  ];

  DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: [
          ListView(
            padding: EdgeInsets.zero,
            children: [
              const _DrawerHeaderAlternative(),
              ...ListTile.divideTiles(
                context: context,
                tiles: _menuItems.map((item) {
                  return ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                    dense: true,
                    minLeadingWidth: 30,
                    title: Text(
                      item['title']!,
                      style: TextStyle(
                        fontFamily: 'PokemonSolid', // Tipografía estilo Pokémon
                        fontSize: 20, // Aumentar tamaño de letra
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? const Color.fromARGB(
                                255, 234, 227, 94) // Color para el tema oscuro
                            : const Color.fromARGB(
                                255, 16, 163, 242), // Color para el tema claro
                      ),
                    ),
                    subtitle: Text(
                      item['subtitle'] ?? '',
                      style: TextStyle(
                        fontFamily: 'RobotoMono',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? const Color.fromARGB(
                                255, 16, 163, 242) // Color para el tema oscuro
                            : const Color.fromARGB(255, 208, 51, 20),
                      ),
                    ),
                    leading: Image.asset(
                      item['icon']!,
                      width: 28,
                      height: 28,
                    ),
                    onTap: () async {
                      final player = AudioPlayer();
                      try {
                        await player.play(AssetSource(
                            'sounds/pokeclick.mp3')); // Reproducir sonido
                      } catch (e) {
                        dev.log("Error al reproducir el sonido: $e");
                      }
                      Navigator.pop(context);
                      Navigator.pushNamed(context, item['route']!);
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DrawerHeaderAlternative extends StatefulWidget {
  const _DrawerHeaderAlternative();

  @override
  _DrawerHeaderAlternativeState createState() =>
      _DrawerHeaderAlternativeState();
}

class _DrawerHeaderAlternativeState extends State<_DrawerHeaderAlternative> {
  final Random _random = Random();

  // Efectos de animación para las Pokébolas
  double _circleSize1 = 130.0;
  double _circleSize2 = 100.0;
  double _circleSize3 = 50.0;
  double _circleSize4 = 30.0;

  void _animateCircles() {
    setState(() {
      _circleSize1 = _random.nextDouble() * 150 + 80;
      _circleSize2 = _random.nextDouble() * 120 + 50;
      _circleSize3 = _random.nextDouble() * 60 + 30;
      _circleSize4 = _random.nextDouble() * 50 + 20;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      padding: EdgeInsets.zero,
      decoration: const BoxDecoration(color: Colors.red),
      child: Stack(
        children: [
          Positioned(
            top: -80,
            left: 50,
            child: GestureDetector(
              onTap: _animateCircles,
              child: AnimatedContainer(
                width: _circleSize1,
                height: _circleSize1,
                child: Image.asset('assets/images/pokeball.png'),
                duration: const Duration(seconds: 1),
                curve: Curves.easeInOut,
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            right: 40,
            child: GestureDetector(
              onTap: _animateCircles,
              child: AnimatedContainer(
                width: _circleSize2,
                height: _circleSize2,
                child: Image.asset('assets/images/pokeball.png'),
                duration: const Duration(seconds: 1),
                curve: Curves.easeInOut,
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 120,
            child: GestureDetector(
              onTap: _animateCircles,
              child: AnimatedContainer(
                width: _circleSize3,
                height: _circleSize3,
                child: Image.asset('assets/images/pokeball.png'),
                duration: const Duration(seconds: 1),
                curve: Curves.easeInOut,
              ),
            ),
          ),
          Positioned(
            top: 100,
            left: 170,
            child: GestureDetector(
              onTap: _animateCircles,
              child: AnimatedContainer(
                width: _circleSize4,
                height: _circleSize4,
                child: Image.asset('assets/images/pokeball.png'),
                duration: const Duration(seconds: 1),
                curve: Curves.easeInOut,
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomRight,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: const Text(
              'Pokédex Menu',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontFamily: 'RobotoMono',
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
