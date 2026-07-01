import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  static const Color primary = Color(0xFFFB8C00);
  static const Color primaryDark = Color(0xFF1A1D4E);
  static const Color primaryLight = Color(0xFFFFB74D);

  static const Color _lightBg = Color(0xFFEEFEFF);
  static const Color _lightSurface = Color(0xFFFFFFFF);
  static const Color _lightCard = Color(0xFFFFFFFF);
  static const Color _lightText = Color(0xFF1A1D4E);
  static const Color _lightSubtext = Color(0xFF8E8E93);
  static const Color _lightDivider = Color(0x1A9E9E9E);

  static const Color _darkBg = Color(0xFF0D1117);
  static const Color _darkSurface = Color(0xFF161B22);
  static const Color _darkCard = Color(0xFF1C2333);
  static const Color _darkCardBorder = Color(0xFF30363D);
  static const Color _darkText = Color(0xFFE6EDF3);
  static const Color _darkSubtext = Color(0xFF8B949E);
  static const Color _darkDivider = Color(0xFF21262D);

  static ThemeData get light => ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    fontFamily: 'Inter Tight',
    colorScheme: const ColorScheme.light(
      primary: primary,
      secondary: primaryDark,
      surface: _lightSurface,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: _lightText,
      outline: _lightDivider,
    ),
    scaffoldBackgroundColor: _lightBg,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      iconTheme: IconThemeData(color: _lightText),
      titleTextStyle: TextStyle(
        fontFamily: 'Inter Tight',
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: _lightText,
      ),
    ),
    cardTheme: CardThemeData(
      color: _lightCard,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    dividerTheme: const DividerThemeData(color: _lightDivider, thickness: 1),
    listTileTheme: const ListTileThemeData(
      textColor: _lightText,
      iconColor: _lightSubtext,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected) ? primary : Colors.white,
      ),
      trackColor: WidgetStateProperty.resolveWith(
        (s) =>
            s.contains(WidgetState.selected)
                ? primary.withOpacity(0.5)
                : Colors.grey.withOpacity(0.3),
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: _lightText, fontWeight: FontWeight.w800),
      displayMedium: TextStyle(color: _lightText, fontWeight: FontWeight.w700),
      titleLarge: TextStyle(color: _lightText, fontWeight: FontWeight.w700),
      titleMedium: TextStyle(color: _lightText, fontWeight: FontWeight.w600),
      titleSmall: TextStyle(color: _lightText, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(color: _lightText),
      bodyMedium: TextStyle(color: _lightText),
      bodySmall: TextStyle(color: _lightSubtext),
      labelSmall: TextStyle(color: _lightSubtext),
    ),
    iconTheme: const IconThemeData(color: _lightSubtext),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: primary, width: 1.5),
      ),
      labelStyle: const TextStyle(color: _lightSubtext),
      hintStyle: TextStyle(color: Colors.grey.shade400),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: const TextStyle(
          fontFamily: 'Inter Tight',
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    extensions: const [AppThemeExtension.light],
  );

  static ThemeData get dark => ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    fontFamily: 'Inter Tight',
    colorScheme: const ColorScheme.dark(
      primary: primary,
      secondary: primaryLight,
      surface: _darkSurface,
      onPrimary: Colors.white,
      onSecondary: _darkBg,
      onSurface: _darkText,
      outline: _darkCardBorder,
    ),
    scaffoldBackgroundColor: _darkBg,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      iconTheme: IconThemeData(color: _darkText),
      titleTextStyle: TextStyle(
        fontFamily: 'Inter Tight',
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: _darkText,
      ),
    ),
    cardTheme: CardThemeData(
      color: _darkCard,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: _darkCardBorder),
      ),
    ),
    dividerTheme: const DividerThemeData(color: _darkDivider, thickness: 1),
    listTileTheme: const ListTileThemeData(
      textColor: _darkText,
      iconColor: _darkSubtext,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected) ? Colors.white : _darkSubtext,
      ),
      trackColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected) ? primary : _darkCardBorder,
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: _darkText, fontWeight: FontWeight.w800),
      displayMedium: TextStyle(color: _darkText, fontWeight: FontWeight.w700),
      titleLarge: TextStyle(color: _darkText, fontWeight: FontWeight.w700),
      titleMedium: TextStyle(color: _darkText, fontWeight: FontWeight.w600),
      titleSmall: TextStyle(color: _darkText, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(color: _darkText),
      bodyMedium: TextStyle(color: _darkText),
      bodySmall: TextStyle(color: _darkSubtext),
      labelSmall: TextStyle(color: _darkSubtext),
    ),
    iconTheme: const IconThemeData(color: _darkSubtext),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _darkCard,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: _darkCardBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: _darkCardBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: primary, width: 1.5),
      ),
      labelStyle: const TextStyle(color: _darkSubtext),
      hintStyle: const TextStyle(color: _darkSubtext),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: const TextStyle(
          fontFamily: 'Inter Tight',
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    extensions: const [AppThemeExtension.dark],
  );
}

class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  final Color bgGradientTop;
  final Color bgGradientBottom;
  final Color cardColor;
  final Color cardBorder;
  final Color subtleText;
  final Color navBarBg;
  final Color navBarBorder;

  const AppThemeExtension({
    required this.bgGradientTop,
    required this.bgGradientBottom,
    required this.cardColor,
    required this.cardBorder,
    required this.subtleText,
    required this.navBarBg,
    required this.navBarBorder,
  });

  static const light = AppThemeExtension(
    bgGradientTop: Color(0xFFEEFEFF),
    bgGradientBottom: Color(0xFFD6F9F7),
    cardColor: Color(0xFFFFFFFF),
    cardBorder: Color(0x1AFFFFFF),
    subtleText: Color(0xFF8E8E93),
    navBarBg: Color(0xFFFFFFFF),
    navBarBorder: Color(0xFFE5E7EB),
  );

  static const dark = AppThemeExtension(
    bgGradientTop: Color(0xFF0D1117),
    bgGradientBottom: Color(0xFF0D1F23),
    cardColor: Color(0xFF1C2333),
    cardBorder: Color(0xFF30363D),
    subtleText: Color(0xFF8B949E),
    navBarBg: Color(0xFF161B22),
    navBarBorder: Color(0xFF21262D),
  );

  @override
  AppThemeExtension copyWith({
    Color? bgGradientTop,
    Color? bgGradientBottom,
    Color? cardColor,
    Color? cardBorder,
    Color? subtleText,
    Color? navBarBg,
    Color? navBarBorder,
  }) {
    return AppThemeExtension(
      bgGradientTop: bgGradientTop ?? this.bgGradientTop,
      bgGradientBottom: bgGradientBottom ?? this.bgGradientBottom,
      cardColor: cardColor ?? this.cardColor,
      cardBorder: cardBorder ?? this.cardBorder,
      subtleText: subtleText ?? this.subtleText,
      navBarBg: navBarBg ?? this.navBarBg,
      navBarBorder: navBarBorder ?? this.navBarBorder,
    );
  }

  @override
  AppThemeExtension lerp(AppThemeExtension? other, double t) {
    if (other is! AppThemeExtension) return this;
    return AppThemeExtension(
      bgGradientTop: Color.lerp(bgGradientTop, other.bgGradientTop, t)!,
      bgGradientBottom:
          Color.lerp(bgGradientBottom, other.bgGradientBottom, t)!,
      cardColor: Color.lerp(cardColor, other.cardColor, t)!,
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t)!,
      subtleText: Color.lerp(subtleText, other.subtleText, t)!,
      navBarBg: Color.lerp(navBarBg, other.navBarBg, t)!,
      navBarBorder: Color.lerp(navBarBorder, other.navBarBorder, t)!,
    );
  }
}

extension AppThemeExtensionX on BuildContext {
  AppThemeExtension get appTheme =>
      Theme.of(this).extension<AppThemeExtension>()!;

  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}
