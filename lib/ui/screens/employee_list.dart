import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:super_pixel/controller/employees_controller.dart';
import 'package:super_pixel/ui/routes/app_route.dart';
import 'package:super_pixel/ui/screens/asset_detail.dart';
import 'package:super_pixel/ui/screens/employee_detail.dart';
import 'package:super_pixel/ui/state_builder.dart';
import 'package:super_pixel/ui/widget/app_sheet.dart';
import 'package:super_pixel/ui/widget/app_text.dart';

class EmployeeList extends StatefulWidget {
  const EmployeeList({super.key});

  @override
  State<EmployeeList> createState() => _EmployeeListState();
}

class _EmployeeListState extends State<EmployeeList> {
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
        title: Text('Employees List'),
      ),
      body: StateBuilder(
        controller: EmployeesController.getInstance(),
        builder: (context, employees) {
          print('employees ${employees.length}');

          return ListView.builder(
            itemCount: employees.length,
            itemBuilder: (context, index) {
              var employee = employees[index];
              return GestureDetector(
                onTap: () {
                  AppRoute.push(context, EmployeeDetail(employeeName: employee.name));
                },
                child: Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10),
                    child: Column(
                      children: [
                        AppText(
                          employee.name,
                          weight: FontWeight.bold,
                        ),
                        AppText(employee.employeeId),
                      ],
                    ),
                  ),
                ),
              );
            },
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
                      print('barcode is ${barcodes.barcodes.first.rawValue}');
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
}
