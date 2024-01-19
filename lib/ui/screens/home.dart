import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:super_pixel/controller/assets_controller.dart';
import 'package:super_pixel/ui/routes/app_route.dart';
import 'package:super_pixel/ui/screens/asset_detail.dart';
import 'package:super_pixel/ui/state_builder.dart';
import 'package:super_pixel/ui/widget/app_sheet.dart';
import 'package:super_pixel/ui/widget/app_text.dart';
import 'package:super_pixel/ui/widget/asset_scanner.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
        title: Text('All Assets'),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AppSheet.show(
            context: context,
            builder: (context) {
              return DraggableScrollableSheet(
                initialChildSize: 0.8,
                maxChildSize: 0.8,
                minChildSize: 0.8,
                expand: false,
                builder: (context, scrollController) {
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
          );
        },
      ),
    );
  }
}
