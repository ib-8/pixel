import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:super_pixel/ui/screens/asset_detail.dart';
import 'package:super_pixel/ui/screens/home.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://mxzawzpwccjquaiygqmy.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im14emF3enB3Y2NqcXVhaXlncW15Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDUzODYwMDgsImV4cCI6MjAyMDk2MjAwOH0.lByNBo8hYdt-q19SlkXbUqP5w4c-4irXnl8khXGyBNI',
  );
  usePathUrlStrategy();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 77, 56, 81),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      onGenerateRoute: (settings) {
        if (settings.name != '/') {
          var id = settings.name?.replaceAll('/', '');
          return MaterialPageRoute(
              builder: (context) => AssetDetail(assetId: id ?? ''));
        }
        return MaterialPageRoute(builder: (context) => const Home());
      },
    );
  }
}


////////////////////////////////////////////////
///
////// Asset Type -------------
// Laptop
// Charger
// HDMI Cable

/// Asset Model -------------
// Macbook Pro M2
// Macbook Pro M3
// Macbook Charger
// HDMI Cable

/// Asset Status -------------
// In Use
// In Stock
// In Service
// Missed
// Disposed

/// Event Type -------------
// Purchased
// Associated
// Dissociated
// Sent to service
// Received from service
// Missed
// Disposed

/// Expense Type -------------
// Purchase
// Service
// Accessory
// Warranty Increase
// Insurance
