import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:start/core/managers/font_manager.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  // ========== Core Colors ==========
  primaryColor: Colors.black,
  scaffoldBackgroundColor: const Color(0xFFF4F0EB),
  colorScheme: const ColorScheme.light(
    primary: Colors.black,
    secondary: Colors.black87,
    surface: Colors.white,
    background: Color(0xFFF4F0EB),
    error: Color(0xFFB00020),
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.black,
    onBackground: Colors.black,
    onError: Colors.white,
  ),
  
  // ========== Text Styles ==========
  textTheme: TextTheme(
    displayLarge: const TextStyle(color: Colors.black, fontSize: 40.0),
    displayMedium: const TextStyle(color: Colors.black, fontSize: 32.0),
    displaySmall: const TextStyle(color: Colors.black, fontSize: 28.0),
    headlineMedium: const TextStyle(
      color: Colors.black, 
      fontSize: 24.0, 
      fontWeight: FontWeight.bold
    ),
    headlineSmall: const TextStyle(
      color: Colors.black, 
      fontSize: 20.0, 
      fontWeight: FontWeight.bold
    ),
    titleLarge: const TextStyle(
      color: Colors.black, 
      fontSize: 18.0, 
      fontWeight: FontWeight.bold
    ),
    titleMedium: TextStyle(
      color: Colors.grey.shade800, 
      fontSize: 16.0, 
      fontWeight: FontWeight.w600
    ),
    bodyLarge: const TextStyle(
      color: Colors.black, 
      fontSize: 16.0, 
      fontWeight: FontWeight.w500
    ),
    bodyMedium: const TextStyle(
      color: Colors.black, 
      fontSize: 14.0, 
      fontWeight: FontWeight.w500
    ),
    bodySmall: TextStyle(
      color: Colors.grey.shade700, 
      fontSize: 12.0, 
      fontWeight: FontWeight.w500
    ),
    labelLarge: const TextStyle(
      color: Colors.black, 
      fontSize: 14.0, 
      fontWeight: FontWeight.bold
    ),
    labelMedium: const TextStyle(
      color: Colors.black, 
      fontSize: 12.0, 
      fontWeight: FontWeight.w600
    ),
    labelSmall: TextStyle(
      color: Colors.grey.shade600,
      fontSize: 10.0,
      letterSpacing: 1.5,
      fontWeight: FontWeight.w800,
    ),
  ),
  
  // ========== Input Fields ==========
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey.shade100,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.black, width: 1.5),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
    labelStyle: const TextStyle(color: Colors.black54),
    hintStyle: TextStyle(color: Colors.grey.shade600),
    prefixIconColor: Colors.black87,
    suffixIconColor: Colors.black87,
  ),
  
  // ========== Buttons ==========
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      textStyle: const TextStyle(
        fontSize: 16, 
        fontWeight: FontWeight.w600
      ),
      elevation: 2,
      shadowColor: Colors.grey.withOpacity(0.5),
    ),
  ),
  
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: Colors.black,
      side: const BorderSide(color: Colors.black, width: 1.5),
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12)),
      textStyle: const TextStyle(
        fontSize: 16, 
        fontWeight: FontWeight.w600
      ),
    ),
  ),
  
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.black,
      textStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        decoration: TextDecoration.underline,
      ),
    ),
  ),
  
  // ========== Icons ==========
  iconTheme: const IconThemeData(color: Colors.black),
  primaryIconTheme: const IconThemeData(color: Colors.black),
  
  // ========== Cards ==========
  cardTheme: CardTheme(
    color: Colors.white,
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16)),
    shadowColor: Colors.grey.withOpacity(0.3),
  ),
  
  // ========== App Bar ==========
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    elevation: 1,
    centerTitle: true,
    iconTheme: const IconThemeData(color: Colors.black),
    titleTextStyle: const TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.bold,
      fontFamily: FontConstants.cairoFontFamily,
    ),
    systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
    ),
  ),
  
  // ========== Other Properties ==========
  pageTransitionsTheme: const PageTransitionsTheme(builders: {
    TargetPlatform.android: ZoomPageTransitionsBuilder(),
    TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
  }),
  dividerTheme: DividerThemeData(
    color: Colors.grey.shade300,
    thickness: 1,
    space: 1,
  ),
  fontFamily: FontConstants.cairoFontFamily,
  useMaterial3: true,
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  // ========== Core Colors ==========
  primaryColor: Colors.deepPurple,
  scaffoldBackgroundColor: Colors.transparent,
  colorScheme: ColorScheme.dark(
    primary: Colors.deepPurple,
    secondary: Colors.purpleAccent,
    surface: const Color(0xFF1E1E2A),
    background: const Color(0xFF121212),
    error: const Color(0xFFCF6679),
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.white,
    onBackground: Colors.white70,
    onError: Colors.black,
  ),
  
  // ========== Text Styles ==========
  textTheme: TextTheme(
    displayLarge: const TextStyle(color: Colors.white, fontSize: 40.0),
    displayMedium: const TextStyle(color: Colors.white, fontSize: 32.0),
    displaySmall: const TextStyle(color: Colors.white, fontSize: 28.0),
    headlineMedium: TextStyle(
      color: Colors.grey.shade100,
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
    ),
    headlineSmall: TextStyle(
      color: Colors.grey.shade200,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),
    titleLarge: TextStyle(
      color: Colors.grey.shade200,
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
    ),
    titleMedium: TextStyle(
      color: Colors.grey.shade300,
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
    ),
    bodyLarge: const TextStyle(
      color: Colors.white,
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
    ),
    bodyMedium: const TextStyle(
      color: Colors.white,
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
    ),
    bodySmall: TextStyle(
      color: Colors.grey.shade400,
      fontSize: 12.0,
      fontWeight: FontWeight.w500,
    ),
    labelLarge: const TextStyle(
      color: Colors.white,
      fontSize: 14.0,
      fontWeight: FontWeight.bold,
    ),
    labelMedium: const TextStyle(
      color: Colors.white,
      fontSize: 12.0,
      fontWeight: FontWeight.w600,
    ),
    labelSmall: TextStyle(
      color: Colors.grey.shade500,
      fontSize: 10.0,
      letterSpacing: 1.5,
      fontWeight: FontWeight.w800,
    ),
  ),
  
  // ========== Input Fields ==========
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey.shade800.withOpacity(0.4),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: Colors.deepPurple.shade300,
        width: 1.5,
      ),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
    labelStyle: TextStyle(color: Colors.grey.shade400),
    hintStyle: TextStyle(color: Colors.grey.shade500),
    prefixIconColor: Colors.grey.shade400,
    suffixIconColor: Colors.grey.shade400,
  ),
  
  // ========== Buttons ==========
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.deepPurple,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      elevation: 4,
      shadowColor: Colors.deepPurple.withOpacity(0.3),
    ),
  ),
  
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: Colors.deepPurple.shade200,
      side: BorderSide(
        color: Colors.deepPurple.shade300,
        width: 1.5,
      ),
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
  
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.deepPurple.shade200,
      textStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        decoration: TextDecoration.underline,
      ),
    ),
  ),
  
  // ========== Icons ==========
  iconTheme: IconThemeData(color: Colors.grey.shade300),
  primaryIconTheme: IconThemeData(color: Colors.grey.shade300),
  
  // ========== Cards ==========
  cardTheme: CardTheme(
    color: const Color(0xFF1E1E2A),
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    shadowColor: Colors.deepPurple.withOpacity(0.2),
  ),
  
  // ========== App Bar ==========
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.deepPurple.shade800,
    foregroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
    iconTheme: const IconThemeData(color: Colors.white),
    titleTextStyle: const TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
      fontFamily: FontConstants.cairoFontFamily,
    ),
    systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
    ),
  ),
  
  // ========== Other Properties ==========
  pageTransitionsTheme: const PageTransitionsTheme(builders: {
    TargetPlatform.android: ZoomPageTransitionsBuilder(),
    TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
  }),
  dividerTheme: DividerThemeData(
    color: Colors.grey.shade700,
    thickness: 1,
    space: 1,
  ),
  fontFamily: FontConstants.cairoFontFamily,
  useMaterial3: true,
);