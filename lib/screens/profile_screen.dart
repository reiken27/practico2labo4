import 'package:flutter/material.dart';
import 'package:practico2labo4/helpers/preferences.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Pokemon Black'),
        elevation: 10,
        backgroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderProfile(size: size),
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: BodyProfile(),
            ),
          ],
        ),
      ),
    );
  }
}

class BodyProfile extends StatelessWidget {
  final bool darkMode = false;

  const BodyProfile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: SwitchListTile.adaptive(
            key: ValueKey<bool>(Preferences.darkmode),
            title: const Text('Dark Mode'),
            value: Preferences.darkmode,
            onChanged: (bool value) {
              Preferences.darkmode = value;
            },
            activeTrackColor:
                Colors.yellowAccent, // Color de pista cuando está activado
            activeColor:
                Colors.white, // Color del interruptor cuando está activado
            subtitle: Text(
              Preferences.darkmode
                  ? 'Modo Oscuro Activado'
                  : 'Modo Claro Activado',
              style: TextStyle(
                color: Preferences.darkmode ? Colors.white : Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}

class HeaderProfile extends StatefulWidget {
  const HeaderProfile({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  HeaderProfileState createState() => HeaderProfileState();
}

class HeaderProfileState extends State<HeaderProfile> {
  double _avatarSize = 100;
  Color _backgroundColor = const Color(0xff2d3e4f);

  @override
  void initState() {
    super.initState();
    _animateAvatar();
  }

  void _animateAvatar() {
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _avatarSize = 120;
        _backgroundColor =
            Preferences.darkmode ? Colors.black87 : const Color(0xff2d3e4f);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: double.infinity,
      height: widget.size.height * 0.40,
      color: _backgroundColor,
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          width: _avatarSize,
          height: _avatarSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 10,
                spreadRadius: 2,
                offset: const Offset(5, 5),
              ),
            ],
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/images/pokemonblack.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
