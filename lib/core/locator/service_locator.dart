import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:start/core/network/check_internet.dart';




final locator = GetIt.I;
Future<void>  setupLocator()async {
  locator.registerLazySingleton(
    () => InternetConnectionChecker(),
  );
  locator.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(
      internetConnectionChecker: locator(),
    ),
  );
}
