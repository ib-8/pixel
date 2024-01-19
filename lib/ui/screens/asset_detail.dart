import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:super_pixel/controller/asset_detail_controller.dart';
import 'package:super_pixel/ui/sheets/association_form.dart';
import 'package:super_pixel/ui/state_builder.dart';
import 'package:super_pixel/ui/widget/app_sheet.dart';
import 'package:super_pixel/ui/widget/app_text.dart';

class AssetDetailsPage extends StatelessWidget {
  final List<List<String>> rowsData;

  AssetDetailsPage({required this.rowsData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Asset Details>>'),
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

class AssetDetail extends StatefulWidget {
  const AssetDetail({required this.assetId, super.key});

  final String assetId;
  @override
  State<AssetDetail> createState() => _AssetDetailState();
}

class _AssetDetailState extends State<AssetDetail>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    AssetDetailController.init(widget.assetId);
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    AssetDetailController.close(widget.assetId);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StateBuilder(
      controller: AssetDetailController(widget.assetId),
      builder: (context, data) {
        if (data.asset == null) {
          return const Scaffold(
            body: Center(
              child: AppText(
                '404',
                weight: FontWeight.bold,
                size: 150,
                color: Color.fromARGB(255, 77, 56, 81),
              ),
            ),
          );
        }

        var asset = data.asset!;

        print('events length ${data.events.length}');
        return Scaffold(
          appBar: AppBar(),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(
                      asset.model,
                      size: 20,
                      weight: FontWeight.bold,
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
                Row(
                  children: [
                    const AppText(
                      'Owner: ',
                    ),
                    const SizedBox(width: 20),
                    AppText(
                      asset.owner,
                      weight: FontWeight.bold,
                    ),
                  ],
                ),
                SizedBox(
                  height: 80,
                  width: 80,
                  child: PrettyQrView.data(
                    data: 'https://superpixelapp.web.app/${widget.assetId}',
                    decoration: const PrettyQrDecoration(),
                  ),
                ),
                const SizedBox(height: 10),
                TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(
                      child: AppText('Events'),
                    ),
                    Tab(
                      child: AppText('Expenses'),
                    ),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: const [
                      FlutterLogo(),
                      AppText('data'),
                    ],
                  ),
                )
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(onPressed: () {
            AppSheet.show(
              context: context,
              builder: (context) {
                return AssociationForm(assetId: data.asset!.id);
              },
            );
          }),
        );
      },
    );
  }
}
