import 'package:get_it/get_it.dart';

class DependencyInjector {
  static final instance = GetIt.instance;

  static dispose() {
    instance.reset();
  }
}
