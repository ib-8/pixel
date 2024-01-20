import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:super_pixel/controller/assets_controller.dart';
import 'package:super_pixel/model/asset.dart';
import 'package:super_pixel/ui/state_builder.dart';
import 'package:super_pixel/ui/routes/app_route.dart';
import 'package:super_pixel/ui/screens/asset_detail.dart';
import 'package:super_pixel/ui/widget/app_sheet.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:super_pixel/ui/widget/app_text.dart';

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
        title: const Text('Dashboard'),
      ),
      body: StateBuilder(
        controller: AssetsController.getInstance(),
        builder: (context, assets) {
          Map<String, List<Asset>>? groupedData = groupDataByType(assets);
          Map<String, Map<String, dynamic>> statusCount = countStatus(assets);
          Map<String, Map<String, dynamic>> warrantyCount =
              countWarrantyStatus(assets);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.center,
              spacing: 16.0,
              runSpacing: 16.0,
              children: [
                // Display status counts
                ...groupedData.entries.map((entry) {
                  String type = entry.key;
                  List<Asset> typeData = entry.value;

                  Map<String, Map<String, dynamic>> statusCount =
                      countStatus(typeData);
                  int itemCount = typeData.length;

                  return Card(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AppText(
                                '$type ($itemCount)',
                                weight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ...statusCount.entries.map((statusEntry) {
                            String status = statusEntry.key;
                            Map<String, dynamic> idMap = statusEntry.value;

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10),
                              child: GestureDetector(
                                onTap: () {
                                  // Handle tap, e.g., display asset details
                                  if (idMap['count'] != 0) {
                                    List<int> ids = idMap['ids'] ?? [];
                                    showAssetDetailsDialog(
                                        context, ids, assets);
                                  }
                                },
                                child: Text('$status: ${idMap['count'] ?? 0}'),
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  );
                }).toList(),

                // Display warranty status count in a separate card
                Card(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Warranty Status'),
                          ),
                          ...warrantyCount.entries.map((warrantyStatusEntry) {
                            String warrantyStatus = warrantyStatusEntry.key;
                            Map<String, dynamic> warrantyIdMap =
                                warrantyStatusEntry.value;

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  // Handle tap, e.g., display asset details
                                  if (warrantyIdMap['count'] != 0) {
                                    List<int> ids = warrantyIdMap['ids'] ?? [];
                                    showAssetDetailsDialog(
                                        context, ids, assets);
                                  }
                                },
                                child: Text(
                                    '$warrantyStatus: ${warrantyIdMap['count'] ?? 0}'),
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
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
          'Model: ${asset.model}',
          'Serial Number: ${asset.serialNumber}',
          'Status: ${asset.status}',
          'Warranty Date : ${asset.warrantyEndDate}',
          'Ownership: ${asset.ownerShip}',
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

  Map<String, Map<String, dynamic>> countWarrantyStatus(List<Asset> dataList) {
    Map<String, Map<String, dynamic>> statusCount = {
      'Expired': {'ids': <int>[], 'count': 0},
      'Expiring in 60 days': {'ids': <int>[], 'count': 0},
      'In Warranty': {'ids': <int>[], 'count': 0},
    };
    for (Asset data in dataList) {
      if (DateTime.parse(data.warrantyEndDate)
              .difference(DateTime.now())
              .inDays <=
          0) {
        statusCount['Expired']!['ids']
            .add(int.tryParse(data.id) ?? 0); // Convert String to int
        statusCount['Expired']!['count'] += 1; // Add 1 to the count
      } else if (DateTime.parse(data.warrantyEndDate)
                  .difference(DateTime.now())
                  .inDays <=
              60 &&
          DateTime.parse(data.warrantyEndDate)
                  .difference(DateTime.now())
                  .inDays >
              0) {
        statusCount['Expiring in 60 days']!['ids']
            .add(int.tryParse(data.id) ?? 0); // Convert String to int
        statusCount['Expiring in 60 days']!['count'] += 1; // Add 1 to the count
      } else {
        statusCount['In Warranty']!['ids']
            .add(int.tryParse(data.id) ?? 0); // Convert String to int
        statusCount['In Warranty']!['count'] += 1; // Add 1 to the count
      }
    }
    return statusCount;
  }
}
