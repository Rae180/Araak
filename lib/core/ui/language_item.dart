import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';



import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:start/core/managers/languages_manager.dart';
import 'package:start/core/ui/profile_item.dart';
import 'package:start/features/localization/cubit/lacalization_cubit.dart';



class LanguageItem extends StatelessWidget {
  const LanguageItem({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfileItem(
      icon: FontAwesomeIcons.language,
      text: AppLocalizations.of(context)?.changeLanguage ?? "",
      onTap: () {
        showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            builder: (context) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 3,
                        width: 35,
                        color: Colors.grey,
                        alignment: Alignment.center,
                      ),
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ...LanguagesManager.appLanguages.map((element) {
                            return ListTile(
                              onTap: () {
                                BlocProvider.of<LacalizationCubit>(context)
                                    .changeLanguage(element);
                              },
                              leading: Icon(
                                FontAwesomeIcons.language,
                                color: Theme.of(context).primaryColor,
                              ),
                              title: Text(
                                LanguagesManager.getLanguageTextFromCode(
                                  element,
                                ),
                              ),
                            );
                          }).toList()
                        ]),
                  ],
                ));
      },
    );
  }
}
