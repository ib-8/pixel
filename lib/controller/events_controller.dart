import 'package:flutter/material.dart';
import 'package:super_pixel/database_table.dart';
import 'package:super_pixel/di.dart';
import 'package:super_pixel/model/event.dart';

class EventsController extends ValueNotifier<List<Event>> {
  EventsController() : super([]) {
    getAllEvents();
  }

  static var instance = DependencyInjector.instance<EventsController>();
  static EventsController getInstance() {
    return DependencyInjector.instance<EventsController>();
  }

  static init() {
    try {
      DependencyInjector.instance
          .registerLazySingleton<EventsController>(() => EventsController());
    } catch (e) {
      print('error is $e');
    }
  }

  getAllEvents() async {
    var response = await DatabaseTable.assets.select();

    value = response.map((e) => Event.from(e)).toList();

    print('all response is $response');
  }

  static close() {
    DependencyInjector.instance.unregister<EventsController>();
  }
}
