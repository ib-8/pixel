import 'package:flutter/material.dart';
import 'package:super_pixel/database_table.dart';
import 'package:super_pixel/di.dart';
import 'package:super_pixel/model/asset.dart';
import 'package:super_pixel/model/event.dart';
import 'package:super_pixel/model/expenses.dart';
import 'package:super_pixel/utils/asset_status.dart';

class AssetDetailController extends ValueNotifier<AssetDetailState> {
  AssetDetailController(this.assetId) : super(AssetDetailState()) {
    getDetail();
    getAllEvents();
    getAllExpenses();
  }

  final String assetId;

  static var instance = DependencyInjector.instance<AssetDetailController>();
  static AssetDetailController getInstance(assetId) {
    // return DependencyInjector.instance<AssetDetailController>();

    return DependencyInjector.instance
        .get<AssetDetailController>(instanceName: assetId);
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

    // print('all response is-------- $response');
  }

  getAllEvents() async {
    var response = await DatabaseTable.events.select().eq('assetId', assetId);
    value = value.copyWith(events: response.map((e) => Event.from(e)).toList());
    print('all response is $response');
  }

  getAllExpenses() async {
    var response = await DatabaseTable.expenses.select().eq('assetId', assetId);

    var expenses = response.map((e) => Expenses.from(e)).toList();

    value = value.copyWith(expenses: expenses);
    print('all expense is $response');
  }

  associate(
      {required String owner, required Asset newAsset, Asset? oldAsset}) async {
    var asset = newAsset
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
    DependencyInjector.instance
        .unregister<AssetDetailController>(instanceName: assetId);
  }
}

class AssetDetailState {
  AssetDetailState({
    this.asset,
    this.events = const [],
    this.expenses = const [],
  });

  final Asset? asset;
  final List<Event> events;
  final List<Expenses> expenses;

  AssetDetailState copyWith(
      {Asset? asset, List<Event>? events, List<Expenses>? expenses}) {
    return AssetDetailState(
      asset: asset ?? this.asset,
      events: events ?? this.events,
      expenses: expenses?? this.expenses,
    );
  }
}
