import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:start/core/managers/font_manager.dart';
import '../managers/color_manager.dart';
// import '../managers/font_manager.dart';
// import '../managers/styles_manager.dart';
// import '../managers/values_manager.dart';
// ThemeData getApplicationThemeData() {
//   return ThemeData(
//     fontFamily: FontConstants.cairoFontFamily,

//     //main Colors
//     primaryColor: ColorManager.primary,
//     primaryColorLight: ColorManager.lightPrimary,
//     primaryColorDark: ColorManager.darkPrimary,
//     disabledColor: ColorManager.grey1,
//     splashColor: ColorManager.lightPrimary,

//     // cardview theme
//     cardTheme: CardTheme(
//         color: ColorManager.white,
//         shadowColor: ColorManager.grey,
//         elevation: 1),

//     // app bar theme
//  appBarTheme:  AppBarTheme(
//       centerTitle: false,
//       color: ColorManager.primary,
//       systemOverlayStyle:
//       SystemUiOverlayStyle(statusBarBrightness: Brightness.light,statusBarColor: ColorManager.primary, ),
//       elevation: 0.5,
//       actionsIconTheme:const IconThemeData(color: Colors.white),),

//     // button theme
//     buttonTheme: ButtonThemeData(
//         shape: const StadiumBorder(),
//         disabledColor: ColorManager.grey1,
//         buttonColor: ColorManager.primary,
//         splashColor: ColorManager.lightPrimary),

// //elevated Button
//     elevatedButtonTheme: ElevatedButtonThemeData(
//       style: ElevatedButton.styleFrom(
//         textStyle: getRegularStyle(
//           color: ColorManager.white,
//           fontSize: FontSize.s14,
//         ),
//         padding: const EdgeInsets.all(
//           AppPadding.p8,
//         ),
//         backgroundColor: ColorManager.primary,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(AppSize.s4),
//         ),
//       ),
//     ),

//     // text theme
//     // textTheme: TextTheme(

//     //   displayLarge:
//     //       getLightStyle(color: ColorManager.white, fontSize: FontSize.s22),
//     //   headline1: getSemiBoldStyle(
//     //       color: ColorManager.darkGrey, fontSize: FontSize.s16),
//     //   subtitle1:
//     //       getMediumStyle(color: ColorManager.lightGrey, fontSize: FontSize.s14),
//     //   caption: getRegularStyle(color: ColorManager.grey1),
//     //   bodyText1        : getRegularStyle(
//     //     color: ColorManager.grey,
//     //   ),
//     // ),

//     // input decoration theme (text form field)
//     inputDecorationTheme: InputDecorationTheme(
//       // content padding
//       contentPadding: const EdgeInsets.symmetric(
//         vertical: 10.0,
//         horizontal: 10.0,
//       ),

//       // hint style
//       hintStyle: getRegularStyle(
//         color: ColorManager.grey,
//         fontSize: FontSize.s16,
//       ),
//       labelStyle: getMediumStyle(
//         color: ColorManager.grey,
//         fontSize: FontSize.s16,
//       ),
//       errorStyle: getRegularStyle(
//         color: ColorManager.error,
//         fontSize: FontSize.s12,
//       ),

//       // enabled border style (grey)
//       enabledBorder: OutlineInputBorder(
//         borderSide: BorderSide(
//           color: ColorManager.grey.withOpacity(1),
//           //  width: AppSize.s1_5,
//         ),
//         borderRadius: const BorderRadius.all(
//           Radius.circular(
//             AppSize.s8,
//           ),
//         ),
//       ),

//       // focused border style(primary)
//       focusedBorder: OutlineInputBorder(
//         borderSide: BorderSide(
//           color: ColorManager.primary.withOpacity(1),
//           //  width: AppSize.s1_5,
//         ),
//         borderRadius: const BorderRadius.all(
//           Radius.circular(
//             AppSize.s8,
//           ),
//         ),
//       ),

//       // error border style
//       errorBorder: OutlineInputBorder(
//         borderSide: BorderSide(
//           color: ColorManager.error,
//           //  width: AppSize.s1_5,
//         ),
//         borderRadius: const BorderRadius.all(
//           Radius.circular(
//             AppSize.s8,
//           ),
//         ),
//       ),

//       // focused border style
//       focusedErrorBorder: OutlineInputBorder(
//         borderSide: BorderSide(
//           color: ColorManager.primary,
//           // width: AppSize.s1_5,
//         ),
//         borderRadius: const BorderRadius.all(
//           Radius.circular(
//             AppSize.s8,
//           ),
//         ),
//       ),
//     ),
//   );
// }

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.light,
  pageTransitionsTheme: const PageTransitionsTheme(builders: {
    TargetPlatform.android: ZoomPageTransitionsBuilder(),
    TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
  }),
  dividerTheme: const DividerThemeData(
      indent: 0.0, endIndent: 0.0, thickness: 1.0, space: 0.5),
  hintColor: Colors.grey[400],
  disabledColor: Colors.grey[300],
  textTheme: TextTheme(
    displayMedium: const TextStyle(color: Colors.black, fontSize: 40.0),
    displaySmall: const TextStyle(color: Colors.black, fontSize: 32.0),
    headlineMedium: TextStyle(
        color: Colors.grey[900], fontSize: 28.0, fontWeight: FontWeight.w900),
    headlineSmall: TextStyle(
        color: Colors.grey[800], fontSize: 20.0, fontWeight: FontWeight.w900),
    titleLarge: TextStyle(
        color: Colors.grey[800], fontSize: 18.0, fontWeight: FontWeight.w900),
    bodyMedium: TextStyle(
        color: Colors.grey[900], fontSize: 16.0, fontWeight: FontWeight.w700),
    bodyLarge: const TextStyle(
        color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.w700),
    bodySmall: TextStyle(
        color: Colors.grey[800], fontSize: 12.0, fontWeight: FontWeight.w600),
    labelSmall: TextStyle(
        color: Colors.grey[500],
        fontSize: 11.0,
        letterSpacing: 1.5,
        fontWeight: FontWeight.w800),
    labelLarge: const TextStyle(
        color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w700),
  ),
  colorScheme: ColorScheme.fromSwatch(
      brightness: Brightness.light, backgroundColor: const Color(0xfff9f9f9)),
  primaryTextTheme: const TextTheme(
    bodyLarge: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w800),
  ),
  canvasColor: Colors.white,
  highlightColor: Colors.grey[100]!.withOpacity(0.4),
  splashColor: Colors.transparent,
  primaryColor: const Color(0xffff3939),
  unselectedWidgetColor: Colors.white,
  scaffoldBackgroundColor: const Color.fromRGBO(247, 248, 251, 1),
  dividerColor: Colors.grey[300],
  fontFamily: FontConstants.cairoFontFamily,
  appBarTheme: AppBarTheme(
      centerTitle: true,
      color: const Color(0xffff3939),
      systemOverlayStyle:
          const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
      elevation: 0.0,
      actionsIconTheme: IconThemeData(color: Colors.grey[800])),
);

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  pageTransitionsTheme: const PageTransitionsTheme(builders: {
    TargetPlatform.android: ZoomPageTransitionsBuilder(),
    TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
  }),
  dividerTheme: const DividerThemeData(
      indent: 0.0, endIndent: 0.0, thickness: 1.0, space: 0.5),
  hintColor: Colors.grey[400],
  disabledColor: Colors.grey[300],
  textTheme: TextTheme(
    displayMedium: const TextStyle(color: Colors.black, fontSize: 40.0),
    displaySmall: const TextStyle(color: Colors.black, fontSize: 32.0),
    headlineMedium: TextStyle(
        color: Colors.grey[900], fontSize: 28.0, fontWeight: FontWeight.w900),
    headlineSmall: TextStyle(
        color: Colors.grey[800], fontSize: 20.0, fontWeight: FontWeight.w900),
    titleLarge: TextStyle(
        color: Colors.grey[800], fontSize: 18.0, fontWeight: FontWeight.w900),
    bodyMedium: TextStyle(
        color: Colors.grey[900], fontSize: 16.0, fontWeight: FontWeight.w700),
    bodyLarge: const TextStyle(
        color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.w700),
    bodySmall: TextStyle(
        color: Colors.grey[800], fontSize: 12.0, fontWeight: FontWeight.w600),
    labelSmall: TextStyle(
        color: Colors.grey[500],
        fontSize: 11.0,
        letterSpacing: 1.5,
        fontWeight: FontWeight.w800),
    labelLarge: const TextStyle(
        color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w700),
  ),
  colorScheme: ColorScheme.fromSwatch(
      brightness: Brightness.light, backgroundColor: const Color(0xfff9f9f9)),
  primaryTextTheme: const TextTheme(
    labelLarge: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w800),
  ),
  canvasColor: Colors.white,
  highlightColor: Colors.grey[100]!.withOpacity(0.4),
  splashColor: Colors.transparent,
  primaryColor: const Color(0xffff3939),
  unselectedWidgetColor: Colors.white,
  scaffoldBackgroundColor: const Color.fromRGBO(247, 248, 251, 1),
  dividerColor: Colors.grey[300],
  fontFamily: FontConstants.cairoFontFamily,
  appBarTheme: const AppBarTheme(
      centerTitle: true,
      color: Color(0xffff3939),
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
          statusBarColor: Color(0xffff3939)),
      elevation: 0.5,
      actionsIconTheme: IconThemeData(color: Colors.white)),
);
