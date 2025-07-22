import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:start/core/api_service/network_api_service_http.dart';
import 'package:start/core/managers/languages_manager.dart';
import 'package:start/core/utils/services/shared_preferences.dart';
import 'package:start/features/Auth/View/Screens/LoginPage.dart';
import 'package:start/features/Orders/view/screens/Orders_Screen.dart';
import 'package:start/features/Settings/Bloc/bloc/settings_bloc.dart';
import 'package:start/features/Settings/view/Screens/ProfilePage.dart';
import 'package:start/features/Settings/view/Screens/UserAccountPage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:start/features/localization/cubit/lacalization_cubit.dart';
import 'package:start/features/theme/bloc/theme_bloc.dart';

class SettingScreen extends StatelessWidget {
  static const String routeName = '/Settings_screen';
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SettingsBloc(client: NetworkApiServiceHttp())
            ..add(LoadUserData()),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            l10n.settings,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: colorScheme.onBackground,
            ),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: BlocConsumer<SettingsBloc, SettingsState>(
          listener: (context, state) {
            if (state is SettingsError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
            // else if (state is AccountDeleted) {
            //   ScaffoldMessenger.of(context).showSnackBar(
            //     SnackBar(content: Text(l10n.accountdeleted)),
            //   );
            //   Navigator.of(context).pushNamedAndRemoveUntil(
            //     LoginPage.routeName,
            //     (Route<dynamic> route) => false,
            //   );
            // }
          },
          builder: (context, state) {
            String welcomeText = '${l10n.welcome} 👋';
            String? userName;
            String? userEmail;
            String? avatarUrl;

            if (state is SettingsSuccess) {
              welcomeText = '${l10n.welcome}, ${state.user.name}';
              userName = state.user.name;
              userEmail = state.user.email;
              avatarUrl = state.user.image;
            }

            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              children: [
                // Profile Header with Avatar
                _buildProfileHeader(context, userName, userEmail, avatarUrl),
                const SizedBox(height: 24),

                // Account Settings Section
                _buildSettingsSection(
                  context,
                  icon: Icons.account_circle,
                  title: l10n.accountsettings,
                  children: [
                    _buildSettingsItem(
                      context,
                      icon: Icons.visibility,
                      title: l10n.showacc,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ProfilePage()),
                      ),
                    ),
                    _buildSettingsItem(
                      context,
                      icon: Icons.edit,
                      title: l10n.editaccount,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: BlocProvider.of<SettingsBloc>(context),
                            child: const ModAccount(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // App Settings Section
                _buildSettingsSection(
                  context,
                  icon: Icons.settings,
                  title: l10n.appsettings,
                  children: [
                    _buildThemeSwitcher(context),
                    _buildLanguageSwitcher(context),
                  ],
                ),
                const SizedBox(height: 24),

                // Orders Section
                _buildSettingsSection(
                  context,
                  icon: Icons.shopping_cart,
                  title: l10n.orders,
                  children: [
                    _buildSettingsItem(
                      context,
                      icon: Icons.list_alt,
                      title: l10n.myorders,
                      onTap: () => Navigator.of(context)
                          .pushNamed(OrdersScreen.routeName),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Support Section
                _buildSettingsSection(
                  context,
                  icon: Icons.support_agent,
                  title: l10n.support,
                  children: [
                    _buildSettingsItem(
                      context,
                      icon: Icons.help_outline,
                      title: l10n.helpsupport,
                      onTap:() {},
                      // () => _launchSupportUrl(context),
                    ),
                    _buildSettingsItem(
                      context,
                      icon: Icons.email_outlined,
                      title: l10n.contactus,
                      onTap: () {},
                      //() => _launchEmailSupport(context),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Danger Zone Section
                _buildSettingsSection(
                  context,
                  icon: Icons.warning_amber_rounded,
                  title: l10n.dangerzone,
                  children: [
                    _buildSettingsItem(
                      context,
                      icon: Icons.delete_outline,
                      title: l10n.deleteacc,
                      isDestructive: true,
                      onTap: () {},
                      //() => _showDeleteAccountDialog(context),
                    ),
                    _buildSettingsItem(
                      context,
                      icon: Icons.logout,
                      title: l10n.logout,
                      isDestructive: true,
                      onTap: () => _showLogoutDialog(context),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, String? userName,
      String? userEmail, String? avatarUrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor:
                Theme.of(context).colorScheme.secondary.withOpacity(0.1),
            backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
            child: avatarUrl == null
                ? const Icon(Icons.person, size: 36, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName ?? AppLocalizations.of(context)!.guest,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (userEmail != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    userEmail,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(0.7),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24, bottom: 8),
          child: Row(
            children: [
              Icon(icon,
                  size: 20, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    bool isDestructive = false,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon,
          color: isDestructive
              ? Colors.red
              : Theme.of(context).colorScheme.secondary),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive
              ? Colors.red
              : Theme.of(context).colorScheme.onBackground,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildThemeSwitcher(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        final isDarkMode = themeState is ThemeLoaded
            ? themeState.isDarkMode
            : Theme.of(context).brightness == Brightness.dark;

        return ListTile(
          leading: Icon(
            isDarkMode ? Icons.dark_mode : Icons.light_mode,
            color: Theme.of(context).colorScheme.secondary,
          ),
          title: Text(
            AppLocalizations.of(context)!.changetheme,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: Switch(
            value: isDarkMode,
            onChanged: (value) {
              BlocProvider.of<ThemeBloc>(context).add(ToggleTheme());
            },
            activeColor: Theme.of(context).colorScheme.primary,
          ),
        );
      },
    );
  }

  Widget _buildLanguageSwitcher(BuildContext context) {
    return BlocBuilder<LacalizationCubit, LacalizationState>(
      builder: (context, state) {
        final currentLang = state.locale.languageCode;
        final isArabic = currentLang == LanguagesManager.Arabic;
        final langName = isArabic ? "العربية" : "English";

        return ListTile(
          leading: Icon(
            Icons.translate,
            color: Theme.of(context).colorScheme.secondary,
          ),
          title: Text(
            AppLocalizations.of(context)!.changeLanguage,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                langName,
                style: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .onBackground
                      .withOpacity(0.7),
                ),
              ),
              const SizedBox(width: 12),
              Switch(
                value: isArabic,
                onChanged: (value) {
                  final newLang = isArabic
                      ? LanguagesManager.English
                      : LanguagesManager.Arabic;
                  BlocProvider.of<LacalizationCubit>(context)
                      .changeLanguage(newLang);
                },
                activeColor: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        );
      },
    );
  }

  // void _showDeleteAccountDialog(BuildContext context) {
  //   final l10n = AppLocalizations.of(context)!;

  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: Text(l10n.confirmdelete),
  //       content: Text(l10n.alertdelete),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.of(context).pop(),
  //           child: Text(l10n.cancel),
  //         ),
  //         TextButton(
  //           onPressed: () {
  //             // Navigator.of(context).pop();
  //             // BlocProvider.of<SettingsBloc>(context).add(DeleteAccountEvent());
  //           },
  //           style: TextButton.styleFrom(foregroundColor: Colors.red),
  //           child: Text(l10n.yesdelete),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Future<void> _showLogoutDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;

    final shouldLogout = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(l10n.confirmation),
            content: Text(l10n.alertlogout),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(l10n.cancel),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: Text(l10n.yes),
              ),
            ],
          ),
        ) ??
        false;

    if (shouldLogout) {
      await PreferenceUtils.clearAll();
      Navigator.of(context).pushNamedAndRemoveUntil(
        LoginPage.routeName,
        (Route<dynamic> route) => false,
      );
    }
  }

  // Future<void> _launchSupportUrl(BuildContext context) async {
  //   final l10n = AppLocalizations.of(context)!;
  //   const url = 'https://your-support-site.com/help';

  //   try {
  //     if (await canLaunch(url)) {
  //       await launch(url);
  //     } else {
  //       throw 'Could not launch $url';
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('l10n.cantlaunchur')),
  //     );
  //   }
  // }

  // Future<void> _launchEmailSupport(BuildContext context) async {
  //   final l10n = AppLocalizations.of(context)!;
  //   final email = 'support@yourcompany.com';
  //   final subject = Uri.encodeComponent(
  //       '${'l10n.supportRequest'} - ${DateTime.now().toString()}');
  //   final body = Uri.encodeComponent('l10n.enterYourMessage');
  //   final uri = 'mailto:$email?subject=$subject&body=$body';

  //   try {
  //     if (await canLaunch(uri)) {
  //       await launch(uri);
  //     } else {
  //       throw 'Could not launch email client';
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('l10n.noemailclient')),
  //     );
  //   }
  // }
}
