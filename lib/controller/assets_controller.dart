import 'package:flutter/material.dart';
import 'package:super_pixel/database_table.dart';
import 'package:super_pixel/di.dart';
import 'package:super_pixel/model/asset.dart';

class AssetsController extends ValueNotifier<List<Asset>> {
  AssetsController() : super([]) {
    getAllAssets();
  }

  static var instance = DependencyInjector.instance<AssetsController>();
  static AssetsController getInstance() {
    return DependencyInjector.instance<AssetsController>();
  }

  static init() {
    try {
      DependencyInjector.instance
          .registerLazySingleton<AssetsController>(() => AssetsController());
    } catch (e) {
      print('error is $e');
    }
  }

  getAllAssets() async {
    var response = await DatabaseTable.assets.select();

    value = response.map((e) => Asset.from(e)).toList();

    // print('all response is $response');
  }

  static close() {
    DependencyInjector.instance.unregister<AssetsController>();
  }
}
