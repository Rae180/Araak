import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:start/config/routes/app_router.dart';
import 'package:start/core/api_service/network_api_service_http.dart';
import 'package:start/core/api_service/notification_service.dart';
import 'package:start/core/locator/service_locator.dart';
import 'package:start/core/utils/services/shared_preferences.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:start/features/Wallet/Bloc/Wallet_bloc/wallet_bloc.dart';
import 'package:start/features/app/my_app.dart';
import 'package:start/features/theme/bloc/theme_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:start/firebase_options.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  NotificationService.initilaizeNotification();
  FirebaseMessaging.onBackgroundMessage(
      NotificationService.firebaseMessagingBackgroundHandler);
  Bloc.observer = SimpleBlocObserver();
  await PreferenceUtils.init();
  await setupLocator();

  // Get saved theme or use default

  Stripe.publishableKey =
      'pk_test_51RZtDX2L3bpM3CqRNJbKhyqf4cV8j3oqY3FlzEOkY8cKM7MU0yNXaNr57o2B1HSZIprdE1zzd9tozxSyNmdXEph900OlqbWZGO';
  await Stripe.instance.applySettings();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeBloc(),
        ),
        BlocProvider(
          create: (context) => WalletBloc(client: NetworkApiServiceHttp()),
        ),
      ],
      child: MainApp(
        appRouter: AppRouter(),
      ),
    ),
  );
}
// lib/core/utils/bloc_observer.dart

class SimpleBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('${bloc.runtimeType} $change');
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    print('${bloc.runtimeType} $event');
  }
}
