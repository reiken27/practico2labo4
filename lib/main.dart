import 'package:flutter/material.dart';
import 'package:practico2labo4/helpers/preferences.dart';
import 'package:practico2labo4/provider/theme_provider.dart';
import 'package:practico2labo4/screens/custom_list_item.dart';
import 'package:practico2labo4/screens/custom_list_screen.dart';
import 'package:practico2labo4/screens/home_screen.dart';
import 'package:practico2labo4/screens/lista_movimientos_screen.dart';
import 'package:practico2labo4/screens/lista_pokemon.dart';
import 'package:practico2labo4/screens/lista_pokemonid.dart';
import 'package:practico2labo4/screens/profile_screen.dart';
import 'package:practico2labo4/themes/default_theme.dart';
import 'package:provider/provider.dart'; // Importa Provider


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences.initShared(); // Inicializa SharedPreferences

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(), // Proveedor de tema
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Preferences
          .initShared(), // Espera a que se inicialicen las preferencias
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child:
                  CircularProgressIndicator()); // Muestra un indicador de carga
        }

        if (snapshot.hasError) {
          return Center(
              child: Text('Error: ${snapshot.error}')); // Manejo de errores
        }

        // Una vez que las preferencias estén listas, muestra la aplicación
        final themeProvider = Provider.of<ThemeProvider>(context);

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: 'home',
          theme: themeProvider.isDarkMode
              ? DefaultTheme.darkTheme
              : DefaultTheme.lightTheme, // Cambia tema dinámicamente
          routes: {
            'home': (context) => const HomeScreen(),
            'custom_list': (context) => const CustomListScreen(),
            'profile': (context) => const ProfileScreen(),
            'custom_list_item': (context) => const CustomListItem(),
            'lista_movimientos': (context) => const ListaMovimientosScreen(),
            'lista_pokemon': (context) => const ListaPokemonScreen(),
            'lista_pokemonid': (context) => const ListaPokemonidScreen(),
          },
        );
      },
    );
  }
}
