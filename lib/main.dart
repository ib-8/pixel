import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:super_pixel/controller/assets_controller.dart';
import 'package:super_pixel/controller/employees_controller.dart';
import 'package:super_pixel/ui/screens/asset_detail.dart';
import 'package:super_pixel/ui/screens/dashboard.dart';
import 'package:super_pixel/ui/screens/employee_list.dart';
import 'package:super_pixel/ui/screens/asset_list.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:super_pixel/ui/widget/app_text.dart';

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
    super.initState();
  }

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

/// Asset Expense Type -------------
// New Purchase
// Service
// Accessory
// Warranty Increase
// Insurance

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  NavigationRailLabelType labelType = NavigationRailLabelType.all;

  double groupAlignment = -1.0;

  onTabChange(index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  HomeCard(
                    lable: 'Home',
                    onTap: () => onTabChange(0),
                  ),
                  HomeCard(
                    lable: 'Assets',
                    onTap: () => onTabChange(1),
                  ),
                  HomeCard(
                    lable: 'Employees',
                    onTap: () => onTabChange(2),
                  ),
                  HomeCard(
                    lable: 'Requesters',
                    onTap: () => onTabChange(2),
                  ),
                  HomeCard(
                    lable: 'Expenses',
                    onTap: () => onTabChange(4),
                  ),
                ],
              ),
            ),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Builder(
              builder: (context) {
                switch (_selectedIndex) {
                  case 0:
                    return const Dashboard();
                  case 1:
                    return const AssetList();
                  case 2:
                    return const EmployeeList();
                  default:
                    return const Home();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class HomeCard extends StatelessWidget {
  const HomeCard({required this.lable, required this.onTap, super.key});

  final String lable;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 0,
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: AppText(lable),
          ),
        ),
      ),
    );
  }
}
