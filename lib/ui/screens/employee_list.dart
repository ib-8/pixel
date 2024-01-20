import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:super_pixel/controller/employees_controller.dart';
import 'package:super_pixel/database_table.dart';
import 'package:super_pixel/model/asset.dart';
import 'package:super_pixel/ui/routes/app_route.dart';
import 'package:super_pixel/ui/screens/asset_detail.dart';
import 'package:super_pixel/ui/screens/asset_list.dart';
import 'package:super_pixel/ui/screens/employee_detail.dart';
import 'package:super_pixel/ui/state_builder.dart';
import 'package:super_pixel/ui/widget/app_sheet.dart';
import 'package:super_pixel/ui/widget/app_text.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:super_pixel/utils/asset_status.dart';

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

    await DatabaseTable.assets.insert(asset.toMap());
  }

  String? assetStatus;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Employee'),
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
        actions: [
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding:
                  EdgeInsets.only(top: 8.0, right: 40.0), // Adjust as needed
              child: IconButton(
                icon: Icon(Icons.person_add, color: Colors.white),
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
        controller: EmployeesController.getInstance(),
        builder: (context, employees) {
          print('employees ${employees.length}');

          return ListView.builder(
            itemCount: employees.length,
            itemBuilder: (context, index) {
              var employee = employees[index];

              return GestureDetector(
                onTap: () {
                  AppRoute.push(
                      context, EmployeeDetail(employeeName: employee.name));
                },
                child: Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              employee.name,
                              weight: FontWeight.bold,
                            ),
                            AppText(employee.employeeId),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
