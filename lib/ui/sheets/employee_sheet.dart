import 'package:flutter/material.dart';
import 'package:super_pixel/controller/employees_controller.dart';
import 'package:super_pixel/model/employee.dart';
import 'package:super_pixel/ui/routes/app_route.dart';
import 'package:super_pixel/ui/sheets/association_type_sheet.dart';
import 'package:super_pixel/ui/state_builder.dart';
import 'package:super_pixel/ui/widget/app_text.dart';

class EmployeeSelectionSheet extends StatefulWidget {
  const EmployeeSelectionSheet({super.key});

  @override
  State<EmployeeSelectionSheet> createState() => _EmployeeSelectionSheetState();
}

class _EmployeeSelectionSheetState extends State<EmployeeSelectionSheet> {
  String? type;
  String? employee;
  String? notes;
  String? oldAsset;

  TextEditingController _noteController = TextEditingController();

  onSelect(Employee employee) {
    AppRoute.pop(context, employee);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      maxChildSize: 0.8,
      minChildSize: 0.8,
      expand: false,
      builder: (context, contrioller) {
        return StateBuilder(
            controller: EmployeesController.getInstance(),
            builder: (context, data) {
              var allEmployees = data;
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Center(
                      child: AppText(
                        'Select Employee',
                        weight: FontWeight.bold,
                        size: 20,
                      ),
                    ),
                    ...List.generate(
                      allEmployees.length,
                      (index) {
                        var employee = allEmployees[index];

                        return FormTile(
                          lable: employee.name,
                          onTap: () => onSelect(employee),
                        );
                      },
                    )

                    // FormTile(
                    //   lable: AssociationType.temporary,
                    //   onTap: () => onSelect(AssociationType.temporary),
                    // ),
                    // FormTile(
                    //   lable: AssociationType.replacement,
                    //   onTap: () => onSelect(AssociationType.replacement),
                    // ),
                  ],
                ),
              );
            });
      },
    );
  }
}
