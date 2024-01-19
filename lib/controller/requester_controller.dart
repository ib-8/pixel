import 'package:flutter/material.dart';
import 'package:super_pixel/database_table.dart';
import 'package:super_pixel/di.dart';
import 'package:super_pixel/model/requester.dart';

class RequesterController extends ValueNotifier<List<Requester>> {
  RequesterController() : super([]) {
    getRequesters();
  }

  static var instance = DependencyInjector.instance<RequesterController>();
  static RequesterController getInstance() {
    return DependencyInjector.instance<RequesterController>();
  }

  static init() {
    try {
      DependencyInjector.instance.registerLazySingleton<RequesterController>(() => RequesterController());
    } catch (e) {
      print('error is $e');
    }
  }

  getRequesters() async {
    var response = await DatabaseTable.requesters.select().eq('status','Open');
    print('response requester $response');
    value = response.map((e) => Requester.from(e)).toList();
  }

  static close() {
    DependencyInjector.instance.unregister<RequesterController>();
  }
}
