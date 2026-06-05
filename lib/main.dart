import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'core/api/fuel_api_client.dart';
import 'core/api/location_service.dart';
import 'core/repositories/fuel_repository.dart';
import 'features/list/list_screen.dart';
import 'features/charging/charging_screen.dart';
import 'features/about/about_screen.dart';
import 'features/prices/prices_screen.dart';
import 'features/about/terms_dialog.dart';
import 'shared/theme/app_theme.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Hive.initFlutter();
  await initializeDateFormatting('el_GR', null);
  runApp(const FuelSpotApp());
  FlutterNativeSplash.remove();
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
        home: const SplashScreen(),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2500), () async {
      if (mounted) {
        final accepted = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (_) => const TermsDialog(),
        );
        if (mounted && accepted == true) {
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => const HomeShell(),
              transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
              transitionDuration: const Duration(milliseconds: 400),
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D3F6B),
      body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Image.asset('assets/icon/splash.png', width: 140, height: 140),
        const SizedBox(height: 24),
        RichText(text: const TextSpan(
          style: TextStyle(fontSize: 38, fontWeight: FontWeight.w900, letterSpacing: 0.5),
          children: [
            TextSpan(text: 'Fuel', style: TextStyle(color: Colors.white)),
            TextSpan(text: 'Spot', style: TextStyle(color: Color(0xFFFFCC00))),
          ],
        )),
        const SizedBox(height: 8),
        Text('Πρατήρια & Φόρτιση — Πάντα Κοντά σου',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 14)),
        const SizedBox(height: 6),
        Text('By Kokkinopoulos Babis',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12, fontStyle: FontStyle.italic)),
        const SizedBox(height: 40),
        const SizedBox(width: 28, height: 28,
            child: CircularProgressIndicator(strokeWidth: 2.5, color: Color(0xFFFFCC00))),
      ])),
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
  static const _screens = [ListScreen(), ChargingScreen(), PricesScreen(), AboutScreen()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _tab, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        currentIndex: _tab,
        onTap: (i) => setState(() => _tab = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.local_gas_station), label: 'Πρατήρια'),
          BottomNavigationBarItem(icon: Icon(Icons.ev_station), label: 'Φόρτιση'),
          BottomNavigationBarItem(icon: Icon(Icons.euro), label: 'Τιμές'),
          BottomNavigationBarItem(icon: Icon(Icons.info_outline), label: 'Σχετικά'),
        ],
      ),
    );
  }
}
