import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primary = Color(0xFF1D9E75);
  static const Color primaryLight = Color(0xFFE1F5EE);
  static const Color primaryDark = Color(0xFF0F6E56);

  static const Color surface = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF7F7F5);
  static const Color cardBorder = Color(0xFFE8E8E4);

  static const Color textPrimary = Color(0xFF1A1A18);
  static const Color textSecondary = Color(0xFF6B6B67);
  static const Color textTertiary = Color(0xFFABABA6);

  static const Color breathBlue = Color(0xFF185FA5);
  static const Color breathOrange = Color(0xFFD85A30);
  static const Color breathAmber = Color(0xFFBA7517);

  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: background,
        textTheme: GoogleFonts.notoSansTextTheme().copyWith(
          displayLarge: GoogleFonts.notoSans(
              fontSize: 32, fontWeight: FontWeight.w600, color: textPrimary),
          headlineMedium: GoogleFonts.notoSans(
              fontSize: 22, fontWeight: FontWeight.w500, color: textPrimary),
          titleLarge: GoogleFonts.notoSans(
              fontSize: 18, fontWeight: FontWeight.w500, color: textPrimary),
          titleMedium: GoogleFonts.notoSans(
              fontSize: 15, fontWeight: FontWeight.w500, color: textPrimary),
          bodyLarge: GoogleFonts.notoSans(
              fontSize: 15, fontWeight: FontWeight.w400, color: textSecondary, height: 1.6),
          bodyMedium: GoogleFonts.notoSans(
              fontSize: 13, fontWeight: FontWeight.w400, color: textSecondary, height: 1.5),
          labelSmall: GoogleFonts.notoSans(
              fontSize: 11, fontWeight: FontWeight.w500, color: textTertiary, letterSpacing: 0.5),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: background,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: GoogleFonts.notoSans(
              fontSize: 18, fontWeight: FontWeight.w500, color: textPrimary),
        ),
        cardTheme: const CardThemeData(
          color: surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            side: BorderSide(color: cardBorder, width: 0.5),
          ),
        ),
        sliderTheme: SliderThemeData(
          activeTrackColor: primary,
          inactiveTrackColor: primaryLight,
          thumbColor: primary,
          overlayColor: primary.withAlpha((0.12 * 255).toInt()),
          trackHeight: 4,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: surface,
          selectedItemColor: primary,
          unselectedItemColor: textTertiary,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
        ),
      );
}
