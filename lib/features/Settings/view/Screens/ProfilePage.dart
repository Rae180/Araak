import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:start/core/api_service/network_api_service_http.dart';
import 'package:start/features/Settings/Bloc/bloc/settings_bloc.dart';
import 'package:start/features/Settings/view/Screens/SettingsPage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfilePage extends StatelessWidget {
  static const String routeName = '/Profile_page';
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // إرسال حدث جلب البيانات مباشرة عند بناء الصفحة

    return BlocProvider(
      create: (context) =>
          SettingsBloc(client: NetworkApiServiceHttp())..add(LoadUserData()),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              AppLocalizations.of(context)!.profile,
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        body: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            if (state is SettingsLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            // عرض البيانات فقط إذا كانت محملة
            else if (state is SettingsSuccess) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      CircleAvatar(
                        radius: 80,
                        backgroundImage: state.user.image != null &&
                                state.user.image!.isNotEmpty
                            ? NetworkImage(state.user.image!)
                            : const AssetImage('assets/images/profile.jpeg')
                                as ImageProvider,
                      ),
                      const SizedBox(height: 60),
                      Text(
                        state.user.name!,
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.user.email!,
                        style: const TextStyle(
                            fontSize: 16, color: Colors.black54),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        state.user.phone!,
                        style: const TextStyle(
                            fontSize: 16, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is SettingsError) {
              return Center(
                child: Text(state.message),
              );
            }

            // إذا لم تكن البيانات محملة بعد، نعيد Container فارغ
            return Container();
          },
        ),
      ),
    );
  }
}
