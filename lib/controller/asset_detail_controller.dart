import 'package:flutter/material.dart';
import 'package:super_pixel/database_table.dart';
import 'package:super_pixel/di.dart';
import 'package:super_pixel/model/asset.dart';

class AssetDetailController extends ValueNotifier<List<Asset>> {
  AssetDetailController(this.assetId) : super([]) {
    getDetail();
  }

  final String assetId;

  static var instance = DependencyInjector.instance<AssetDetailController>();
  static AssetDetailController getInstance() {
    return DependencyInjector.instance<AssetDetailController>();
  }

  static init(assetId) {
    try {
      DependencyInjector.instance.registerLazySingleton<AssetDetailController>(
        () => AssetDetailController(assetId),
        instanceName: assetId,
      );
    } catch (e) {
      print('error is $e');
    }
  }

  getDetail() async {
    print('getting detail>>>>>>>>> for $assetId');
    var response =
        await DatabaseTable.assets.select().eq('id', assetId).maybeSingle();

    if (response != null) {
      print('response is ${response}');
      value = [Asset.from(response)];
    }

    print('all response is-------- $response');
  }

  static close() {
    DependencyInjector.instance.unregister<AssetDetailController>();
  }
}
