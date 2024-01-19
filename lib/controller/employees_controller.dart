import 'package:flutter/material.dart';
import 'package:super_pixel/di.dart';
import 'package:super_pixel/model/employee.dart';
import 'package:super_pixel/database_table.dart';

class EmployeesController extends ValueNotifier<List<Employee>> {
  EmployeesController() : super([]) {
    getAllEmployees();
  }

  static var instance = DependencyInjector.instance<EmployeesController>();
  static EmployeesController getInstance() {
    return DependencyInjector.instance<EmployeesController>();
  }

  static init() {
    try {
      DependencyInjector.instance.registerLazySingleton<EmployeesController>(
          () => EmployeesController());
    } catch (e) {
      print('error is $e');
    }
  }

  getAllEmployees() async {
    // Check AssetsController for reference
    // ToDO

    print('<<<<<<object>>>>>>');
    var response = await DatabaseTable.employees.select();
    print('response employee $response');
    value = response.map((e) => Employee.from(e)).toList();
    // print('all response is $response');
  }

  static close() {
    DependencyInjector.instance.unregister<EmployeesController>();
  }
}
