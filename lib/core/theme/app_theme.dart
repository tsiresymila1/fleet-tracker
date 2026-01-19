import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const primaryPink = Color.fromARGB(255, 56, 95, 157);
  static const darkBackground = Color(0xFF18181B); // Supabase-style grey
  static const darkSurface = Color(0xFF27272A);
  static const darkBorder = Color(0xFF3F3F46);

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),
    scaffoldBackgroundColor: darkBackground,
    colorScheme: ColorScheme.dark(
      primary: primaryPink,
      secondary: Colors.blueAccent,
      surface: darkSurface,
      outline: darkBorder,
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light, // For Android
        statusBarBrightness: Brightness.dark, // For iOS
      ),
    ),
    cardTheme: CardThemeData(
      color: darkSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    textTheme: GoogleFonts.outfitTextTheme(ThemeData.light().textTheme),
    scaffoldBackgroundColor: Colors.white,
    colorScheme: const ColorScheme.light(
      primary: primaryPink,
      secondary: Colors.blueAccent,
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark, // For Android
        statusBarBrightness: Brightness.light, // For iOS
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.grey[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}
