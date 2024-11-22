import 'package:flutter/material.dart';
import 'package:practico2labo4/helpers/preferences.dart';
import 'package:practico2labo4/screens/custom_list_item.dart';
import 'package:practico2labo4/screens/custom_list_screen.dart';
import 'package:practico2labo4/screens/home_screen.dart';
import 'package:practico2labo4/screens/lista_movimientos_screen.dart';
import 'package:practico2labo4/screens/profile_screen.dart';
import 'package:practico2labo4/themes/default_theme.dart'; // Importa el archivo de temas

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences.initShared();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'home',
      theme: Preferences.darkmode
          ? DefaultTheme.darkTheme
          : DefaultTheme.lightTheme,
      routes: {
        'home': (context) => const HomeScreen(),
        'custom_list': (context) => const CustomListScreen(),
        'profile': (context) => const ProfileScreen(),
        'custom_list_item': (context) => const CustomListItem(),
        'lista_movimientos': (context) => const ListaMovimientosScreen(),
      },
    );
  }
}
