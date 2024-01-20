import 'package:flutter/material.dart';
import 'package:super_pixel/database_table.dart';
import 'package:super_pixel/di.dart';
import 'package:super_pixel/model/asset.dart';
import 'package:super_pixel/model/event.dart';
import 'package:super_pixel/toast.dart';
import 'package:super_pixel/model/expenses.dart';
import 'package:super_pixel/utils/asset_status.dart';
import 'package:super_pixel/utils/event_type.dart';

class AssetDetailController extends ValueNotifier<AssetDetailState> {
  AssetDetailController(this.assetId) : super(AssetDetailState()) {
    getDetail();
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
    value = value.copyWith(isLoading: true);
    print('getting detail>>>>>>>>> for $assetId');
    var response =
        await DatabaseTable.assets.select().eq('id', assetId).maybeSingle();

    if (response != null) {
      print('response is ${response}');
      value = value.copyWith(asset: Asset.from(response));
    }

    await getAllEvents();

    await getAllExpenses();

    value = value.copyWith(isLoading: false);

    // print('all response is-------- $response');
  }

  getAllEvents() async {
    var response = await DatabaseTable.events
        .select()
        .eq('assetId', assetId)
        .order('eventTime', ascending: true);

    value = value.copyWith(events: response.map((e) => Event.from(e)).toList());
    print('all response is $response');
  }

  getAllExpenses() async {
    var response = await DatabaseTable.expenses
        .select()
        .eq('assetId', assetId)
        .order('date', ascending: true);

    var expenses = response.map((e) => Expenses.from(e)).toList();

    value = value.copyWith(expenses: expenses);
    print('all expense is $response');
  }

  Future associate(
      {required String owner, required Asset newAsset, Asset? oldAsset}) async {
    value = value.copyWith(isUpdating: true);
    var asset = newAsset
      ..status = AssetStatus.inUse
      ..owner = owner;

    var response =
        await DatabaseTable.assets.update(asset.toMap()).eq('id', asset.id);

    var associationEvent = Event(
      id: '',
      assetId: newAsset.id,
      type: EvenType.associated,
      employee: owner,
      eventTime: DateTime.now(),
    );

    await DatabaseTable.events.insert(associationEvent.toMap());

    if (oldAsset != null) {
      var oldAsset = value.asset!
        ..status = AssetStatus.inStock
        ..owner = '';

      var response = await DatabaseTable.assets
          .update(oldAsset.toMap())
          .eq('id', oldAsset.id);

      var dissociationEvent = Event(
        id: '',
        assetId: oldAsset.id,
        type: EvenType.dissociated,
        employee: owner,
        eventTime: DateTime.now(),
      );

      await DatabaseTable.events.insert(dissociationEvent.toMap());
      Toast.show('Associated Successfully');
    }
  }

  Future dissociate({required Asset newasset}) async {
    value = value.copyWith(isUpdating: true);

    var owner = newasset.owner;
    var _asset = newasset
      ..status = AssetStatus.inStock
      ..owner = '';

    var response =
        await DatabaseTable.assets.update(_asset.toMap()).eq('id', _asset.id);

    var event = Event(
      id: '',
      assetId: _asset.id,
      type: EvenType.dissociated,
      employee: owner,
      eventTime: DateTime.now(),
    );

    await DatabaseTable.events.insert(event.toMap());
    Toast.show('Dissociated Successfully');
    getDetail();
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
    this.isLoading = false,
    this.isUpdating = false,
  });

  final bool isLoading;
  final bool isUpdating;
  final Asset? asset;
  final List<Event> events;
  final List<Expenses> expenses;

  AssetDetailState copyWith({
    Asset? asset,
    List<Event>? events,
    List<Expenses>? expenses,
    bool? isLoading,
    bool? isUpdating,
  }) {
    return AssetDetailState(
      asset: asset ?? this.asset,
      events: events ?? this.events,
      expenses: expenses ?? this.expenses,
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
    );
  }
}
