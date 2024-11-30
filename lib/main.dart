import 'package:flutter/material.dart';
import 'package:practico2labo4/helpers/preferences.dart';
import 'package:practico2labo4/provider/theme_provider.dart';
import 'package:practico2labo4/screens/ability_list_screen.dart';
import 'package:practico2labo4/screens/home_screen.dart';
import 'package:practico2labo4/screens/lista_movimientos_screen.dart';
import 'package:practico2labo4/screens/lista_pokemon.dart';
import 'package:practico2labo4/screens/lista_pokemonid.dart';
import 'package:practico2labo4/screens/profile_screen.dart';
import 'package:practico2labo4/screens/lista_items.dart';
import 'package:practico2labo4/themes/default_theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences.initShared();
  await dotenv.load(fileName: ".env");
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Preferences.initShared(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final themeProvider = Provider.of<ThemeProvider>(context);

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: 'home',
          theme: themeProvider.isDarkMode
              ? DefaultTheme.darkTheme
              : DefaultTheme.lightTheme,
          routes: {
            'home': (context) => const HomeScreen(),
            'profile': (context) => const ProfileScreen(),
            'lista_movimientos': (context) => const ListaMovimientosScreen(),
            'ability_list': (context) => const AbilityListScreen(),
            'lista_pokemon': (context) => const ListaPokemonScreen(),
            'lista_pokemonid': (context) => const ListaPokemonidScreen(),
            'lista_items': (context) => const ListaItemsScreen(),
          },
        );
      },
    );
  }
}
