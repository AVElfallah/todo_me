import 'package:get_it/get_it.dart';
import 'package:todo_me/app/routers/router_manager.dart';
import 'package:todo_me/assets/assets_manager.dart';

class ServiceLocator {
ServiceLocator._();
static final ServiceLocator _instance = ServiceLocator._();
static ServiceLocator get I => _instance;
  
static final GetIt _getIt = GetIt.instance;
GetIt get getIt => _getIt;
// setup services
static void setup() {
  // setup managers
  _getIt.registerSingleton<RouterManager>(RouterManager());
  _getIt.registerSingleton<AssetsManager>( AssetsManager());

  // setup data sources

  // setup repositories

  // setup use cases


}

}