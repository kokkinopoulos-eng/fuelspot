import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'core/api/fuel_api_client.dart';
import 'core/api/location_service.dart';
import 'core/repositories/fuel_repository.dart';
import 'features/list/list_screen.dart';
import 'features/map/map_screen.dart';
import 'shared/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await initializeDateFormatting('el_GR', null);
  runApp(const FuelSpotApp());
}

class FuelSpotApp extends StatelessWidget {
  const FuelSpotApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocationService()),
        ChangeNotifierProvider(create: (_) => FuelRepository(FuelApiClient())),
      ],
      child: MaterialApp(
        title: 'FuelSpot',
        theme: AppTheme.light,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('el', 'GR'), Locale('en', 'US')],
        locale: const Locale('el', 'GR'),
        home: const HomeShell(),
      ),
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});
  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _tab = 0;
  static const _screens = [ListScreen(), MapScreen()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _tab, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tab,
        onTap: (i) => setState(() => _tab = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.format_list_bulleted), label: 'Λίστα'),
          BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: 'Χάρτης'),
        ],
      ),
    );
  }
}
