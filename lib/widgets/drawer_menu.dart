import 'package:flutter/material.dart';

class DrawerMenu extends StatelessWidget {
  final List<Map<String, String>> _menuItems = <Map<String, String>>[
    {'route': 'home', 'title': 'Home', 'subtitle': 'Home + counter app'},
    {'route': 'custom_list', 'title': 'Custom list', 'subtitle': ''},
    {'route': 'profile', 'title': 'Perfil usuario', 'subtitle': ''},
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
              tiles: _menuItems
                  .map((item) => ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 10),
                        dense: true,
                        minLeadingWidth: 25,
                        iconColor: Colors.blueGrey,
                        title: Text(item['title']!,
                            style: const TextStyle(fontFamily: 'FuzzyBubbles')),
                        subtitle: Text(item['subtitle'] ?? '',
                            style: const TextStyle(
                                fontFamily: 'RobotoMono', fontSize: 11)),
                        leading: const Icon(Icons.arrow_right),
                        /* trailing: const Icon(Icons.arrow_right), */
                        onTap: () {
                          Navigator.pop(context);
                          //Navigator.pushReplacementNamed(context, item['route']!);
                          Navigator.pushNamed(context, item['route']!);
                        },
                      ))
                  .toList())
        ],
      ),
    );
  }
}

class _DrawerHeaderAlternative extends StatelessWidget {
  const _DrawerHeaderAlternative({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      padding: EdgeInsets.zero,
      child: Stack(children: [
        Positioned(
          top: -90,
          child: Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10)),
            transform: Matrix4.rotationZ(0.2),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 140,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
                color: Colors.redAccent.withOpacity(0.4),
                borderRadius: BorderRadius.circular(10)),
            transform: Matrix4.rotationZ(0.9),
          ),
        ),
        Positioned(
          top: 30,
          right: 35,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.4),
                borderRadius: BorderRadius.circular(10)),
            transform: Matrix4.rotationZ(0.9),
          ),
        ),
        Positioned(
          top: 70,
          right: -10,
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.4),
                borderRadius: BorderRadius.circular(5)),
            transform: Matrix4.rotationZ(0.9),
          ),
        ),
        Container(
          alignment: Alignment.bottomRight,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: const Text(
            '[  Menu  ]',
            style: TextStyle(
                fontSize: 13, color: Colors.black54, fontFamily: 'RobotoMono'),
            textAlign: TextAlign.right,
          ),
        ),
      ]),
    );
  }
}
