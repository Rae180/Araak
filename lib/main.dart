import 'package:flutter/material.dart';
import 'package:start/config/routes/app_router.dart';
import 'package:start/core/locator/service_locator.dart';
import 'package:start/core/utils/services/shared_preferences.dart';
import 'package:start/features/app/my_app.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferenceUtils.init();
  await setupLocator();
  runApp(MainApp(
    appRouter: AppRouter(),
  ));
}
