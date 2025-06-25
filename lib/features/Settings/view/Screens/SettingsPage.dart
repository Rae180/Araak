import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:start/core/api_service/network_api_service_http.dart';
import 'package:start/core/managers/languages_manager.dart';
import 'package:start/core/utils/services/shared_preferences.dart';
import 'package:start/features/Auth/View/Screens/LoginPage.dart';
import 'package:start/features/Orders/Bloc/bloc/orders_bloc.dart';
import 'package:start/features/Orders/view/screens/Orders_Screen.dart';
import 'package:start/features/Settings/Bloc/bloc/settings_bloc.dart';
import 'package:start/features/Settings/view/Screens/ProfilePage.dart';
import 'package:start/features/Settings/view/Screens/UserAccountPage.dart';
import 'package:start/features/Settings/view/widgets/SettingsItem.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:start/features/localization/cubit/lacalization_cubit.dart';

class SettingScreen extends StatefulWidget {
  static const String routeName = '/Settings_screen';
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Widget buildSettingsItem({
      required IconData icon,
      required String title,
      bool isDestructive = false,
      VoidCallback? onTap,
    }) {
      final item = SettingsItem(
        icon: icon,
        title: title,
        isDestructive: isDestructive,
      );

      return GestureDetector(
        onTap: onTap,
        child: item,
      );
    }

    return BlocBuilder<LacalizationCubit, LacalizationState>(
        builder: (context, langState) {
      return BlocProvider(
        create: (context) =>
            SettingsBloc(client: NetworkApiServiceHttp())..add(LoadUserData()),
        child: Scaffold(
          backgroundColor: const Color(0xFFF4F0EB),
          appBar: AppBar(
            backgroundColor: const Color(0xFFF4F0EB),
            elevation: 0,
            centerTitle: true,
            title: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                AppLocalizations.of(context)!.settings,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onBackground,
                ),
              ),
            ),
          ),
          body: BlocConsumer<SettingsBloc, SettingsState>(
            listener: (context, state) {
              if (state is SettingsError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            builder: (context, state) {
              String welcomeText = '${AppLocalizations.of(context)!.welcome} 👋';

              if (state is SettingsSuccess) {
                welcomeText = '${AppLocalizations.of(context)!.welcome}, ${state.user.name}';
              }

              if (state is SettingsLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              return ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                children: [
                  Text(
                    welcomeText,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onBackground,
                    ),
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<LacalizationCubit, LacalizationState>(
                    builder: (context, state) {
                      return buildSettingsItem(
                        isDestructive: true,
                        onTap: () {
                          final currentLang =
                              BlocProvider.of<LacalizationCubit>(context)
                                  .state
                                  .locale
                                  .languageCode;
                          final newLang =
                              currentLang == LanguagesManager.English
                                  ? LanguagesManager.Arabic
                                  : LanguagesManager.English;

                          BlocProvider.of<LacalizationCubit>(context)
                              .changeLanguage(newLang);
                        },
                        icon: Icons.translate,
                        title: AppLocalizations.of(context)!.changeLanguage,
                      );
                    },
                  ),
                  buildSettingsItem(
                    icon: Icons.brightness_6,
                    title: AppLocalizations.of(context)!.changetheme,
                  ),
                  buildSettingsItem(
                    icon: Icons.shopping_cart,
                    title: AppLocalizations.of(context)!.myorders,
                    onTap: () {
                      Navigator.of(context).pushNamed(OrdersScreen.routeName);
                      // You can navigate to orders screen here if you create one
                    },
                  ),
                  buildSettingsItem(
                    icon: Icons.account_circle_outlined,
                    title: AppLocalizations.of(context)!.showacc,
                    onTap: () {
                      BlocProvider.of<SettingsBloc>(context)
                          .add(LoadUserData());
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ProfilePage()),
                      );
                    },
                  ),
                  buildSettingsItem(
                    icon: Icons.edit,
                    title: AppLocalizations.of(context)!.editaccount,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: BlocProvider.of<SettingsBloc>(context),
                            child: const ModAccount(),
                          ),
                        ),
                      );
                    },
                  ),
                  Divider(
                    thickness: 1,
                    color: colorScheme.onSurface.withOpacity(0.3),
                  ),
                  buildSettingsItem(
                    icon: Icons.delete_outline,
                    title: AppLocalizations.of(context)!.deleteacc,
                    isDestructive: true,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title:  Text(AppLocalizations.of(context)!.confirmdelete),
                          content:  Text(
                              AppLocalizations.of(context)!.alertdelete),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child:  Text(AppLocalizations.of(context)!.cancel),
                            ),
                            TextButton(
                              onPressed: () {
                                // Add delete account logic here
                                Navigator.of(context).pop();
                              },
                              style: TextButton.styleFrom(
                                  foregroundColor: Colors.red),
                              child:  Text(AppLocalizations.of(context)!.yesdelete),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  buildSettingsItem(
                      icon: Icons.logout,
                      title: AppLocalizations.of(context)!.logout,
                      onTap: () async {
                        final shouldLogout = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(AppLocalizations.of(context)!.confirmation),
                            content: Text(AppLocalizations.of(context)!.alertlogout),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: Text(AppLocalizations.of(context)!.cancel),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                style: TextButton.styleFrom(
                                    foregroundColor: Colors.red),
                                child: Text(AppLocalizations.of(context)!.yes),
                              ),
                            ],
                          ),
                        );

                        if (shouldLogout == true) {
                          // Clear all saved data
                          await PreferenceUtils.clearAll();

                          // Navigate to login screen and clear all routes
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            LoginPage
                                .routeName, // Replace with your login route
                            (Route<dynamic> route) => false,
                          );
                        }
                      }),
                ],
              );
            },
          ),
        ),
      );
    });
  }
}
