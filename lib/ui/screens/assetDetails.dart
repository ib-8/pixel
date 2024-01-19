import 'package:flutter/material.dart';

class AssetDetailsPage extends StatelessWidget {
  final List<List<String>> rowsData;

  AssetDetailsPage({required this.rowsData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Asset Details'),
      ),
      body: ListView.builder(
        itemCount: rowsData.length,
        itemBuilder: (context, index) {
          List<String> rowData = rowsData[index];

          return Card(
            margin: EdgeInsets.all(8.0),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: rowData.map((cellData) {
                  return Text(
                    cellData,
                    style: TextStyle(fontSize: 16.0),
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
