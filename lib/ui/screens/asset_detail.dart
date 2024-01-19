import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:super_pixel/controller/asset_detail_controller.dart';
import 'package:super_pixel/ui/state_builder.dart';
import 'package:super_pixel/ui/widget/app_text.dart';

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
  Widget build(BuildContext context) {
    return StateBuilder(
        controller: AssetDetailController(widget.assetId),
        builder: (context, data) {
          if (data.isEmpty) {
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

          var asset = data.first;
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
                    children: const [FlutterLogo(), AppText('data')],
                  ))
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(onPressed: () {}),
          );
        });
  }
}
