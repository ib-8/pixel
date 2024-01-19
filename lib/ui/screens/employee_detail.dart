import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:super_pixel/controller/employees_detail_controller.dart';
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
              title: Text('Asset Detail'),
            ),
            body: Center(
              child:  DataTable(
            columns: [
              DataColumn(label: Text('serial number')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Type')),
              DataColumn(label: Text('Model'))
            ],
            rows:
            assets.map((e) => DataRow(cells:[
                     DataCell(Text(e.serialNumber)),
                DataCell(Text(e.status)),
                DataCell(Text(e.type)),
                 DataCell(Text(e.model))

            ] )).toList(),
          
          ),
          ),
          );
        }
        );
  }
}