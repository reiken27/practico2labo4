import 'package:flutter/material.dart';
import 'package:practico2labo4/helpers/preferences.dart';
import 'package:practico2labo4/provider/theme_provider.dart';
import 'package:provider/provider.dart'; // Importa Provider

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences.initShared(); // Inicializa SharedPreferences
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(), // Crea el proveedor del tema
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeProvider.isDarkMode
          ? ThemeMode.dark
          : ThemeMode.light, // Cambia tema en tiempo real
      home: const ProfileScreen(),
    );
  }
}

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
  const BodyProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Column(
      children: [
        SwitchListTile.adaptive(
          title: const Text('Dark Mode'),
          value: themeProvider.isDarkMode, // Vincula con ThemeProvider
          onChanged: (bool value) {
            themeProvider.toggleTheme(value); // Cambia el estado del tema
          },
          activeTrackColor: Colors.yellowAccent,
          activeColor: Colors.white,
          subtitle: Text(
            themeProvider.isDarkMode
                ? 'Modo Oscuro Activado'
                : 'Modo Claro Activado',
            style: TextStyle(
              color: themeProvider.isDarkMode ? Colors.white : Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
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
  final double _avatarSize = 100;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return AnimatedContainer(
      width: double.infinity,
      height: widget.size.height * 0.40,
      color: themeProvider.isDarkMode
          ? Colors.black87
          : const Color(0xff2d3e4f), // Cambia color según el tema
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
