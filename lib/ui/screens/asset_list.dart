import 'dart:io';

import 'package:flutter/material.dart';
import 'package:super_pixel/controller/assets_controller.dart';
import 'package:super_pixel/model/asset.dart';
import 'package:super_pixel/database_table.dart';
import 'package:super_pixel/model/asset.dart';
import 'package:super_pixel/model/expenses.dart';
import 'package:super_pixel/ui/routes/app_route.dart';
import 'package:super_pixel/ui/screens/asset_detail.dart';
import 'package:super_pixel/ui/screens/dashboard.dart';
import 'package:super_pixel/ui/state_builder.dart';
import 'package:super_pixel/ui/widget/app_sheet.dart';
import 'package:super_pixel/ui/widget/app_text.dart';
import 'package:super_pixel/ui/widget/asset_scanner.dart';

class YourForm extends StatefulWidget {
  @override
  _YourFormState createState() => _YourFormState();
}

class _YourFormState extends State<YourForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  DateTime? _selectedDate1;
  final TextEditingController expenseController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController serialNumberController = TextEditingController();
  final TextEditingController ownerShipController = TextEditingController();
  TextEditingController warrantyController = TextEditingController();
  DateTime? _selectedDate2;

  Future<void> _selectDate(BuildContext context,
      TextEditingController controller, DateTime? selectedDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        if (controller == dateController) {
          _selectedDate1 = pickedDate;
        } else if (controller == warrantyController) {
          _selectedDate2 = pickedDate;
        }

        controller.text = pickedDate.toLocal().toString().split(' ')[0];
      });
    }
  }

  Future<void> insertData() async {
    var asset = Asset(
      id: '',
      type: typeController.text,
      model: modelController.text,
      owner: nameController.text,
      serialNumber: serialNumberController.text,
      status: statusController.text,
      ownerShip: ownerShipController.text,
      warrantyEndDate: warrantyController.text,
    );
    var response =
        await DatabaseTable.assets.insert(asset.toMap()).select('id');
    var expense = Expenses(
      type: ownerShipController.text,
      assetId: response.first['id'].toString(),
      amount: expenseController.text,
      vendor: '',
      note: '',
      date: DateTime.tryParse(dateController.text),
    );
    await DatabaseTable.expenses.insert(expense.toMap());
  }

  String? assetStatus;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Asset'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'Owner Name'),
          ),
          TextField(
            controller: typeController,
            decoration: InputDecoration(labelText: 'Type'),
          ),
          TextField(
            controller: modelController,
            decoration: InputDecoration(labelText: 'Model'),
          ),
          TextField(
            controller: serialNumberController,
            decoration: InputDecoration(labelText: 'Serial Number'),
          ),
          TextField(
            controller: ownerShipController,
            decoration: InputDecoration(labelText: 'Ownership'),
          ),
          TextFormField(
            controller: dateController,
            readOnly: true,
            onTap: () => _selectDate(context, dateController, _selectedDate1),
            decoration: InputDecoration(
              labelText: 'Purchase Date',
              suffixIcon: IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: () =>
                    _selectDate(context, dateController, _selectedDate1),
              ),
            ),
          ),
          TextField(
            controller: expenseController,
            decoration: InputDecoration(labelText: 'Expense'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: statusController,
            decoration: InputDecoration(labelText: 'Status'),
          ),
          TextFormField(
            controller: warrantyController,
            readOnly: true,
            onTap: () =>
                _selectDate(context, warrantyController, _selectedDate2),
            decoration: InputDecoration(
              labelText: 'Warranty Date',
              suffixIcon: IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: () =>
                    _selectDate(context, warrantyController, _selectedDate2),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the form
          },
          child: Text('Close'),
        ),
        TextButton(
          onPressed: () async {
            await insertData();
            Navigator.of(context).pop(); // Close the form
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}

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
    var isMobile = Platform.isIOS || Platform.isAndroid;
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Assets'),
        actions: [
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding:
                  EdgeInsets.only(top: 8.0, right: 40.0), // Adjust as needed
              child: IconButton(
                icon: Icon(Icons.add, color: Colors.white),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return YourForm();
                    },
                  );
                },
              ),
            ),
          ),
        ],
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
                onTap: () async {
                  await AppRoute.push(context, AssetDetail(assetId: asset.id));
                  AssetsController.getInstance().getAllAssets();
                },
                child: AssetCard(asset: asset),
              );
            },
          );
        },
      ),
      floatingActionButton: isMobile
          ? FloatingActionButton(
              heroTag: '',
              child: const Icon(Icons.qr_code),
              onPressed: () {
                AppSheet.show(
                    context: context,
                    builder: (context) {
                      return AssetScanner(onTap: (asset) {
                        AppRoute.push(
                          context,
                          AssetDetail(assetId: asset.id),
                        );
                      });
                    });
              },
            )
          : null,
    );
  }
}

class AssetCard extends StatelessWidget {
  const AssetCard({
    super.key,
    required this.asset,
  });

  final Asset asset;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
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
            onTap: () async {
              // Add functionality for Item 1
              await AppRoute.push(context, const AssetList());

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
