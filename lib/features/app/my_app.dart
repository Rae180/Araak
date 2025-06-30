// features/app/my_app.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:start/config/routes/app_router.dart';
import 'package:start/features/Auth/View/Screens/Araak_Splash_Screen.dart';
import 'package:start/features/localization/cubit/lacalization_cubit.dart';
import 'package:start/features/localization/localize_app_impl.dart';
import 'package:start/features/theme/GradientWrraper.dart';
import 'package:start/main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:start/core/managers/theme_manager.dart';
import 'package:start/features/theme/bloc/theme_bloc.dart';

class MainApp extends StatelessWidget {
  final AppRouter appRouter;
  const MainApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) =>
                LacalizationCubit(LocalizeAppImpl())..getSavedLanguage()),
      ],
      child: BlocBuilder<LacalizationCubit, LacalizationState>(
        builder: (context, langState) {
          return BlocBuilder<ThemeBloc, ThemeState>(
            buildWhen: (previous, current) => current is ThemeLoaded,
            builder: (context, themeState) {
              final isDarkMode = themeState is ThemeLoaded
                  ? themeState.isDarkMode
                  : Theme.of(context).brightness == Brightness.dark;

              return MaterialApp(
                builder: (context, child) {
                  return EasyLoading.init()(
                    context,
                    GradientWrapper(child: child!, isDarkMode: isDarkMode),
                  );
                },
                home: const AraakSplashScreen(),
                title: 'APP',
                navigatorKey: navigatorKey,
                debugShowCheckedModeBanner: false,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                locale: langState.locale,
                theme: lightTheme,
                darkTheme: darkTheme,
                themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
                onGenerateRoute: appRouter.onGenerateRoute,
              );
            },
          );
        },
      ),
    );
  }
}
