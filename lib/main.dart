import 'package:flutter/material.dart';
import 'package:start/config/routes/app_router.dart';
import 'package:start/core/locator/service_locator.dart';
import 'package:start/core/utils/services/shared_preferences.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:start/features/app/my_app.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferenceUtils.init();
  await setupLocator();
  Stripe.publishableKey =
      'pk_test_51RZtDX2L3bpM3CqRNJbKhyqf4cV8j3oqY3FlzEOkY8cKM7MU0yNXaNr57o2B1HSZIprdE1zzd9tozxSyNmdXEph900OlqbWZGO';
  Stripe.instance.applySettings();
  runApp(MainApp(
    appRouter: AppRouter(),
  ));
}

// <?xml version="1.0" encoding="utf-8"?>
// <resources>
//     <!-- Theme applied to the Android Window while the process is starting when the OS's Dark Mode setting is off -->
//     <style name="LaunchTheme" parent="@android:style/Theme.Light.NoTitleBar">
//         <!-- Show a splash screen on the activity. Automatically removed when
//              the Flutter engine draws its first frame -->
//         <item name="android:windowBackground">@drawable/launch_background</item>
//     </style>
//     <!-- Theme applied to the Android Window as soon as the process has started.
//          This theme determines the color of the Android Window while your
//          Flutter UI initializes, as well as behind your Flutter UI while its
//          running.

//          This Theme is only used starting with V2 of Flutter's Android embedding. -->
//     <style name="NormalTheme" parent="@android:style/Theme.Light.NoTitleBar">
//         <item name="android:windowBackground">?android:colorBackground</item>
//     </style>
// </resources>




// <?xml version="1.0" encoding="utf-8"?>
// <resources>
//     <!-- Theme applied to the Android Window while the process is starting when the OS's Dark Mode setting is on -->
//     <style name="LaunchTheme" parent="@android:style/Theme.Black.NoTitleBar">
//         <!-- Show a splash screen on the activity. Automatically removed when
//              the Flutter engine draws its first frame -->
//         <item name="android:windowBackground">@drawable/launch_background</item>
//     </style>
//     <!-- Theme applied to the Android Window as soon as the process has started.
//          This theme determines the color of the Android Window while your
//          Flutter UI initializes, as well as behind your Flutter UI while its
//          running.

//          This Theme is only used starting with V2 of Flutter's Android embedding. -->
//     <style name="NormalTheme" parent="@android:style/Theme.Black.NoTitleBar">
//         <item name="android:windowBackground">?android:colorBackground</item>
//     </style>
// </resources>
