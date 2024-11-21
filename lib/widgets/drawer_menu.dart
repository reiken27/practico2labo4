import 'dart:math';

import 'package:flutter/material.dart';

class DrawerMenu extends StatelessWidget {
  final List<Map<String, String>> _menuItems = <Map<String, String>>[
    {'route': 'home', 'title': 'Home', 'subtitle': 'Home + counter app'},
    {'route': 'custom_list', 'title': 'Custom list', 'subtitle': ''},
    {'route': 'profile', 'title': 'Perfil usuario', 'subtitle': ''},
    {
      'route': 'lista_movimientos',
      'title': 'Lista Movimientos',
      'subtitle': 'Ver movimientos'
    },
  ];

  DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
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
                iconColor: Colors.yellow[700],
                title: Text(
                  item['title']!,
                  style: const TextStyle(
                    fontFamily: 'FuzzyBubbles',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                subtitle: Text(
                  item['subtitle'] ?? '',
                  style: const TextStyle(
                    fontFamily: 'RobotoMono',
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                leading: const Icon(Icons.arrow_right, size: 28),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, item['route']!);
                },
              );
            }).toList(),
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

  // Efectos de animación para los círculos
  double _circleSize1 = 130.0;
  double _circleSize2 = 100.0;
  double _circleSize3 = 50.0;
  double _circleSize4 = 30.0;

  Color _circleColor1 = Colors.blueAccent.withOpacity(0.4);
  Color _circleColor2 = Colors.yellow.withOpacity(0.5);
  Color _circleColor3 = Colors.redAccent.withOpacity(0.4);
  Color _circleColor4 = Colors.green.withOpacity(0.4);

  void _animateCircles() {
    setState(() {
      // Cambiar el tamaño y color aleatoriamente para crear un efecto visual.
      _circleSize1 = _random.nextDouble() * 150 + 80;
      _circleSize2 = _random.nextDouble() * 120 + 50;
      _circleSize3 = _random.nextDouble() * 60 + 30;
      _circleSize4 = _random.nextDouble() * 50 + 20;

      _circleColor1 = Color.fromARGB(_random.nextInt(256), _random.nextInt(256),
              _random.nextInt(256), 150)
          .withOpacity(0.5);
      _circleColor2 = Color.fromARGB(_random.nextInt(256), _random.nextInt(256),
              _random.nextInt(256), 150)
          .withOpacity(0.5);
      _circleColor3 = Color.fromARGB(_random.nextInt(256), _random.nextInt(256),
              _random.nextInt(256), 150)
          .withOpacity(0.5);
      _circleColor4 = Color.fromARGB(_random.nextInt(256), _random.nextInt(256),
              _random.nextInt(256), 150)
          .withOpacity(0.5);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      padding: EdgeInsets.zero,
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
                decoration: BoxDecoration(
                  color: _circleColor1,
                  shape: BoxShape.circle,
                ),
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
                decoration: BoxDecoration(
                  color: _circleColor2,
                  shape: BoxShape.circle,
                ),
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
                decoration: BoxDecoration(
                  color: _circleColor3,
                  shape: BoxShape.circle,
                ),
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
                decoration: BoxDecoration(
                  color: _circleColor4,
                  shape: BoxShape.circle,
                ),
                duration: const Duration(seconds: 1),
                curve: Curves.easeInOut,
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomRight,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: const Text(
              '[ Pokémon Menu ]',
              style: TextStyle(
                fontSize: 18,
            
                color: Color.fromARGB(255, 197, 33, 33),
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
