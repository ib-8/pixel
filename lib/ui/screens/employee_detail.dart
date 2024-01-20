import 'package:flutter/material.dart';
import 'package:super_pixel/controller/employees_detail_controller.dart';
import 'package:super_pixel/ui/routes/app_route.dart';
import 'package:super_pixel/ui/screens/asset_detail.dart';
import 'package:super_pixel/ui/screens/asset_list.dart';
import 'package:super_pixel/ui/state_builder.dart';
import 'package:super_pixel/ui/widget/app_text.dart';

class EmployeeDetail extends StatefulWidget {
  const EmployeeDetail({required this.employeeName, super.key});

  final String employeeName;

  @override
  State<EmployeeDetail> createState() => _EmployeeDetailState();
}

class _EmployeeDetailState extends State<EmployeeDetail>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    EmployeeDetailController.init(widget.employeeName);
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    EmployeeDetailController.close(widget.employeeName);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StateBuilder(
      controller: EmployeeDetailController(widget.employeeName),
      builder: (context, data) {
        if (data.assets == null) {
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
        var assets = data.assets;
        return Scaffold(
          appBar: AppBar(
            title: Text('Employee Assets'),
          ),
          body: ListView.builder(
            itemCount: assets.length,
            itemBuilder: (context, index) {
              var asset = assets[index];

              return GestureDetector(
                onTap: () {
                  AppRoute.push(context, AssetDetail(assetId: asset.id));
                },
                child: AssetCard(
                  asset: asset,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
