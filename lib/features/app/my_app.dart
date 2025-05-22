import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:start/config/routes/app_router.dart';
import 'package:start/core/managers/theme_manager.dart';
import 'package:start/features/Auth/View/Screens/Araak_Splash_Screen.dart';
import 'package:start/features/localization/cubit/lacalization_cubit.dart';
import 'package:start/features/localization/localize_app_impl.dart';
import 'package:start/main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainApp extends StatefulWidget {
  final AppRouter appRouter;
  const MainApp({super.key, required this.appRouter});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LacalizationCubit(
        LocalizeAppImpl(),
      )..getSavedLanguage(),
      child: BlocBuilder<LacalizationCubit, LacalizationState>(
        builder: (context, state) {
          return MaterialApp(
            home: AraakSplashScreen(),
            title: 'APP',
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: state.locale,
            darkTheme: darkTheme,
            theme: lightTheme,
            onGenerateRoute: widget.appRouter.onGenerateRoute,
          );
        },
      ),
    );
  }
}
