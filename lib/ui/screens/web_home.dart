import 'dart:io';

import 'package:flutter/material.dart';
import 'package:super_pixel/ui/routes/app_route.dart';
import 'package:super_pixel/ui/screens/asset_detail.dart';
import 'package:super_pixel/ui/screens/asset_list.dart';
import 'package:super_pixel/ui/screens/dashboard.dart';
import 'package:super_pixel/ui/screens/employee_list.dart';
import 'package:super_pixel/ui/screens/requests_list.dart';
import 'package:super_pixel/ui/widget/app_sheet.dart';
import 'package:super_pixel/ui/widget/app_text.dart';
import 'package:super_pixel/ui/widget/asset_scanner.dart';

enum UserType {
  admin,
  employee,
  finance,
}

class WebHome extends StatelessWidget {
  const WebHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LoginCard(
              lable: 'Admin',
              onTap: () {
                AppRoute.push(context, const Home(userType: UserType.admin));
              },
            ),
            const SizedBox(width: 50),
            LoginCard(
              lable: 'Employee',
              onTap: () {
                AppRoute.push(context, const Home(userType: UserType.employee));
              },
            ),
            const SizedBox(width: 50),
            LoginCard(
              lable: 'Finance',
              onTap: () {
                AppRoute.push(context, const Home(userType: UserType.finance));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class LoginCard extends StatelessWidget {
  const LoginCard({required this.lable, this.onTap, super.key});

  final String lable;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.person,
                size: 100,
              ),
              AppText(lable),
            ],
          ),
        ),
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({required this.userType, super.key});

  final UserType userType;

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
    var isMobile = Platform.isAndroid || Platform.isIOS;
    return Scaffold(
      body: Row(
        children: <Widget>[
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  if (widget.userType == UserType.admin)
                    HomeCard(
                      lable: 'Home',
                      onTap: () => onTabChange(0),
                    ),
                  if (widget.userType == UserType.admin || widget.userType == UserType.employee)
                    HomeCard(
                      lable: 'Assets',
                      onTap: () => onTabChange(1),
                    ),
                  if (widget.userType == UserType.admin || widget.userType == UserType.employee)
                    HomeCard(
                      lable: 'Employees',
                      onTap: () => onTabChange(2),
                    ),
                  HomeCard(
                    lable: 'Requests',
                    onTap: () => onTabChange(3),
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
                  case 3:
                    return const RequestsList();
                  default:
                    return const Dashboard();
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: isMobile
          ? FloatingActionButton(
              heroTag: '',
              onPressed: () {
                AppSheet.show(
                  context: context,
                  builder: (context) {
                    return AssetScanner(
                      onTap: (asset) {
                        AppRoute.push(
                          context,
                          AssetDetail(assetId: asset.id),
                        );
                      },
                    );
                  },
                );
              },
            )
          : null,
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
