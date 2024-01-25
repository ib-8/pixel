import 'dart:io';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:super_pixel/controller/assets_controller.dart';
import 'package:super_pixel/controller/employees_controller.dart';
import 'package:super_pixel/controller/requester_controller.dart';
import 'package:super_pixel/ui/screens/asset_detail.dart';
import 'package:super_pixel/ui/screens/asset_list.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:super_pixel/ui/screens/web_home.dart';

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

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    AssetsController.init();
    EmployeesController.init();
    RequesterController.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: MaterialApp(
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
        // home: AssetDetail(assetId: '11', showForWeb: true),
        onGenerateRoute: (settings) {
          if (settings.name != '/') {
            var id = settings.name?.replaceAll('/', '');
            return MaterialPageRoute(
                builder: (context) => AssetDetail(assetId: id ?? ''));
          } else if (Platform.isAndroid || Platform.isIOS) {
            return MaterialPageRoute(builder: (context) => const AssetList());
          } else {
            return MaterialPageRoute(builder: (context) => const WebHome());
          }

          // return MaterialPageRoute(
          //     builder: (context) => AssetDetail(assetId: '11');
        },
      ),
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

/// Asset Expense Type -------------
// New Purchase
// Service
// Accessory
// Warranty Increase
// Insurance

// Requests Type
// New
// service
// Replacement
