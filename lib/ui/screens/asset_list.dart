import 'package:flutter/material.dart';
import 'package:super_pixel/controller/assets_controller.dart';
import 'package:super_pixel/ui/routes/app_route.dart';
import 'package:super_pixel/ui/screens/asset_detail.dart';
import 'package:super_pixel/ui/screens/dashboard.dart';
import 'package:super_pixel/ui/state_builder.dart';
import 'package:super_pixel/ui/widget/app_sheet.dart';
import 'package:super_pixel/ui/widget/app_text.dart';
import 'package:super_pixel/ui/widget/asset_scanner.dart';

class AssetList extends StatefulWidget {
  const AssetList({super.key});

  @override
  State<AssetList> createState() => _AssetListState();
}

class _AssetListState extends State<AssetList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Assets'),
      ),
      body: StateBuilder(
        controller: AssetsController.getInstance(),
        builder: (context, assets) {
          print('assets ${assets.length}');

          return ListView.builder(
            itemCount: assets.length,
            itemBuilder: (context, index) {
              var asset = assets[index];
              return GestureDetector(
                onTap: () {
                  AppRoute.push(context, AssetDetail(assetId: asset.id));
                },
                child: Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              asset.model,
                              weight: FontWeight.bold,
                            ),
                            AppText(asset.owner),
                          ],
                        ),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                            child: AppText(
                              asset.status,
                              weight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Dashboard',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: const Text('Assets'),
            onTap: () {
              // Add functionality for Item 1
              AppRoute.push(context, const AssetList());
              //  Navigator.pop(context); // Close the drawer after selecting an item
            },
          ),
          ListTile(
            title: const Text('IT'),
            onTap: () {
              // Add functionality for Item 2
              AppRoute.push(context, const Dashboard());
              //  Navigator.pop(context);
            },
          ),
          // Add more ListTiles as needed
        ],
      ),
    );
  }
}
