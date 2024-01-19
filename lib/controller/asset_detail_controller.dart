import 'package:flutter/material.dart';
import 'package:super_pixel/database_table.dart';
import 'package:super_pixel/di.dart';
import 'package:super_pixel/model/asset.dart';
import 'package:super_pixel/model/event.dart';
import 'package:super_pixel/utils/asset_status.dart';

class AssetDetailController extends ValueNotifier<AssetDetailState> {
  AssetDetailController(this.assetId) : super(AssetDetailState()) {
    getDetail();
    getAllEvents();
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
      value = value.copyWith(asset: Asset.from(response));
    }

    print('all response is-------- $response');
  }

  getAllEvents() async {
    var response = await DatabaseTable.assets.select().eq('assetId', assetId);

    value = value.copyWith(events: response.map((e) => Event.from(e)).toList());

    print('all response is $response');
  }

  associate({required String owner, Asset? oldAsset}) async {
    var asset = value.asset!
      ..status = AssetStatus.inUse
      ..owner = owner;

    var response = await DatabaseTable.assets.update(asset.toMap());

    if (oldAsset != null) {
      var oldAsset = value.asset!
        ..status = AssetStatus.inStock
        ..owner = '';

      var response = await DatabaseTable.assets.update(oldAsset.toMap());
    }
  }

  static close(assetId) {
    DependencyInjector.instance.unregister<AssetDetailController>(instanceName:assetId );
  }
}

class AssetDetailState {
  AssetDetailState({
    this.asset,
    this.events = const [],
  });

  final Asset? asset;
  final List<Event> events;

  AssetDetailState copyWith({
    Asset? asset,
    List<Event>? events,
  }) {
    return AssetDetailState(
      asset: asset ?? this.asset,
      events: events ?? this.events,
    );
  }
}
