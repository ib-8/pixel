import 'package:flutter/material.dart';
import 'package:super_pixel/database_table.dart';
import 'package:super_pixel/di.dart';
import 'package:super_pixel/model/asset.dart';
import '../model/employee.dart';

class EmployeeDetailController extends ValueNotifier<EmployeeState> {
  EmployeeDetailController(this.employeeName) : super(EmployeeState()) {
    getAssets();
  }

  final String employeeName;

  static var instance = DependencyInjector.instance<EmployeeDetailController>();
  static EmployeeDetailController getInstance() {
    return DependencyInjector.instance<EmployeeDetailController>();
  }

  static init(employeeId) {
    try {
      DependencyInjector.instance
          .registerLazySingleton<EmployeeDetailController>(
        () => EmployeeDetailController(employeeId),
        instanceName: employeeId,
      );
    } catch (e) {
      print('error is $e');
    }
  }

  getAssets() async {
    var assetDetailResponse =
        await DatabaseTable.assets.select().eq('owner', employeeName);

    var response = assetDetailResponse.map((e) => Asset.from(e)).toList();
    // print('all response is $response');
    value = value.copyWith(assets: response);
    print('value is  $value');
  }

  static close(employeeId) {
    DependencyInjector.instance
        .unregister<EmployeeDetailController>(instanceName: employeeId);
  }
}

class EmployeeState {
  EmployeeState({this.employee, this.assets = const []});

  Employee? employee;
  List<Asset> assets;

  EmployeeState copyWith({
    Employee? employee,
    List<Asset>? assets,
  }) {
    return EmployeeState(
      employee: employee ?? this.employee,
      assets: assets ?? this.assets,
    );
  }
}
