import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:super_pixel/controller/assets_controller.dart';
import 'package:super_pixel/model/asset.dart';
import 'package:super_pixel/ui/screens/assetDetails.dart';
import 'package:super_pixel/ui/state_builder.dart';
import 'package:super_pixel/ui/routes/app_route.dart';
import 'package:super_pixel/ui/screens/asset_detail.dart';
import 'package:super_pixel/ui/widget/app_sheet.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:super_pixel/ui/screens/asset_list.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
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
        title: const Text('IT Assets'),
      ),
      drawer: const SideBar(),
      body: StateBuilder(
        controller: AssetsController.getInstance(),
        builder: (context, assets) {
          Map<String, List<Asset>>? groupedData = groupDataByType(assets);
          // print('assets ${assets.length}');

          return Wrap(
            spacing: 16.0,
            runSpacing: 16.0,
            children: groupedData.entries.map((entry) {
              String type = entry.key;
              List<Asset> typeData = entry.value;

              Map<String, Map<String, dynamic>> statusCount =
                  countStatus(typeData);
              int itemCount = typeData.length;

              return Container(
                width: MediaQuery.of(context).size.width * 0.3,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue,
                    width: 2.0,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('$type ($itemCount)'),
                    ),
                    ...statusCount.entries.map((statusEntry) {
                      String status = statusEntry.key;
                      Map<String, dynamic> idMap = statusEntry.value;

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            // Handle tap, e.g., display asset details

                            if (idMap['count'] != 0) ;
                            {
                              List<int> ids = idMap['ids'] ?? [];
                              showAssetDetailsDialog(context, ids, assets);
                            }
                          },
                          child: Text('$status: ${idMap['count'] ?? 0}'),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        AppSheet.show(
            context: context,
            builder: (context) {
              return DraggableScrollableSheet(
                initialChildSize: 0.8,
                maxChildSize: 0.8,
                minChildSize: 0.8,
                expand: false,
                builder: (context, scrollController) {
                  return MobileScanner(
                    onDetect: (barcodes) {
                      HapticFeedback.heavyImpact();
                      // print('barcode is ${barcodes.barcodes.first.rawValue}');
                      if (barcodes.barcodes.first.rawValue != null) {
                        var segments =
                            barcodes.barcodes.first.rawValue!.split('/');
                        AppRoute.push(
                            context, AssetDetail(assetId: segments.last));
                      }
                    },
                  );
                },
              );
            });
      }),
    );
  }

  Map<String, List<Asset>> groupDataByType(List<Asset> dataList) {
    Map<String, List<Asset>> groupedData = {};

    for (Asset data in dataList) {
      if (!groupedData.containsKey(data.type)) {
        groupedData[data.type] = [];
      }
      groupedData[data.type]!.add(data);
    }

    return groupedData;
  }

  Map<String, Map<String, dynamic>> countStatus(List<Asset> dataList) {
    Map<String, Map<String, dynamic>> statusCount = {
      'In Use': {'ids': <int>[], 'count': 0},
      'In Stock': {'ids': <int>[], 'count': 0},
      'In Service': {'ids': <int>[], 'count': 0},
      'Missed': {'ids': <int>[], 'count': 0},
      'Disposed': {'ids': <int>[], 'count': 0},
    };

    for (Asset data in dataList) {
      switch (data.status) {
        case 'In Use':
          statusCount['In Use']!['ids']
              .add(int.tryParse(data.id) ?? 0); // Convert String to int
          statusCount['In Use']!['count'] += 1; // Add 1 to the count
          break;
        case 'Missed':
          statusCount['Missed']!['ids']
              .add(int.tryParse(data.id) ?? 0); // Convert String to int
          statusCount['Missed']!['count'] += 1; // Add 1 to the count
          break;
        case 'In Stock':
          statusCount['In Stock']!['ids']
              .add(int.tryParse(data.id) ?? 0); // Convert String to int
          statusCount['In Stock']!['count'] += 1; // Add 1 to the count
          break;
        case 'In Service':
          statusCount['In Service']!['ids']
              .add(int.tryParse(data.id) ?? 0); // Convert String to int
          statusCount['In Service']!['count'] += 1; // Add 1 to the count
          break;
        case 'Disposed':
          statusCount['Disposed']!['ids']
              .add(int.tryParse(data.id) ?? 0); // Convert String to int
          statusCount['Disposed']!['count'] += 1; // Add 1 to the count
          break;
      }
    }
    return statusCount;
  }

  void showAssetDetailsDialog(
      BuildContext context, List<int> ids, List<Asset> assets) {
    List<List<String>> rowsData = [];

    for (int id in ids) {
      Asset? asset = assets.firstWhere(
        (asset) => int.tryParse(asset.id) == id,
      );

      if (asset.id.isNotEmpty) {
        rowsData.add([
          'ID: ${asset.id}',
          'Owner: ${asset.owner}',
          'Type: ${asset.type}',
          'Asset Id: ${asset.assetId}',
          'Model: ${asset.model}',
          'Serial Number: ${asset.serialNumber}',
          'Status: ${asset.status}',
        ]);
      }
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AssetDetailsPage(rowsData: rowsData),
      ),
    );
  }
}
