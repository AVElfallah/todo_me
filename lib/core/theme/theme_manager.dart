import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_me/core/theme/app_colors.dart';

class  ThemeManager {
  // لادارة شكل الثيم وفصله عن ملف  ال main.dart
  ThemeManager._();
  static ThemeManager? _instance;
  static ThemeManager get instance => _instance ??= ThemeManager._();

  ThemeData get lightTheme => ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.primaryColor,
    appBarTheme: AppBarTheme(),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.buttonColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.all(12),
        elevation: 10,
        
        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    ) ,
    inputDecorationTheme:  InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,

      hintStyle: GoogleFonts.poppins(
        color: AppColors.secondaryTextColor,
        fontSize: 16,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(16),
        
        ),
borderSide: BorderSide.none
      ),
    ),
  );
}