// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class AppColors {
  // Light Theme Colors
  static const Color lightPrimary = Color(0xFF1565C0); // Deep Blue
  static const Color lightPrimaryVariant = Color(0xFF90CAF9); // Light Blue
  static const Color lightSecondary = Color(0xFF0288D1); // Blue
  static const Color lightSecondaryVariant = Color(0xFFB3E5FC);
  static const Color lightBackground = Color(0xFFF5F5F5);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightError = Color(0xFFD32F2F);
  static const Color lightOnPrimary = Color(0xFFFFFFFF);
  static const Color lightOnSecondary = Color(0xFFFFFFFF);
  static const Color lightOnBackground = Color(0xFF000000);
  static const Color lightOnSurface = Color(0xFF000000);
  static const Color lightOnError = Color(0xFFFFFFFF);

  // Common Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color lightGrey = Color(0xFFE0E0E0);
  static const Color darkGrey = Color(0xFF424242);
  static const Color success = Color(0xFF42A5F5); // Blue success tone
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF2196F3);
}

class AppTextStyles {
  static TextStyle headline1(BuildContext context) {
    return Theme.of(context).textTheme.displayLarge?.copyWith(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onBackground,
        ) ??
        const TextStyle();
  }

  static TextStyle headline2(BuildContext context) {
    return Theme.of(context).textTheme.displayMedium?.copyWith(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onBackground,
        ) ??
        const TextStyle();
  }

  static TextStyle bodyText1(BuildContext context) {
    return Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontSize: 16,
          color: Theme.of(context).colorScheme.onBackground,
        ) ??
        const TextStyle();
  }

  static TextStyle bodyText2(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontSize: 14,
          color: Theme.of(context).colorScheme.onBackground.withOpacity(0.8),
        ) ??
        const TextStyle();
  }

  static TextStyle button(BuildContext context) {
    return Theme.of(context).textTheme.labelLarge?.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onPrimary,
        ) ??
        const TextStyle();
  }

  static TextStyle caption(BuildContext context) {
    return Theme.of(context).textTheme.bodySmall?.copyWith(
          fontSize: 12,
          color: Theme.of(context).colorScheme.onBackground.withOpacity(0.6),
        ) ??
        const TextStyle();
  }
}

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    colorScheme: const ColorScheme.light(
      primary: AppColors.lightPrimary,
      secondary: AppColors.lightSecondary,
      surface: AppColors.lightSurface,
      background: AppColors.lightBackground,
      error: AppColors.lightError,
      onPrimary: AppColors.lightOnPrimary,
      onSecondary: AppColors.lightOnSecondary,
      onSurface: AppColors.lightOnSurface,
      onBackground: AppColors.lightOnBackground,
      onError: AppColors.lightOnError,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: AppColors.lightBackground,
    appBarTheme: const AppBarTheme(
      color: AppColors.lightPrimary,
      elevation: 4,
      iconTheme: IconThemeData(color: AppColors.lightOnPrimary),
      titleTextStyle: TextStyle(
        color: AppColors.lightOnPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.lightSurface,
      elevation: 2,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: AppColors.lightPrimary.withOpacity(0.2),
          width: 1,
        ),
      ),
    ),
    textTheme: TextTheme(

    ).apply(fontFamily: "inter"),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: AppColors.lightOnPrimary,
        backgroundColor: AppColors.lightPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.lightBackground,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.lightPrimary),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.lightPrimary),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.lightPrimary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.lightError),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.lightError, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      labelStyle: const TextStyle(color: AppColors.lightOnBackground),
      hintStyle: const TextStyle(color: AppColors.lightOnBackground),
    ),
  );
}

class HealthCard extends StatelessWidget {
  final Widget child;
  final Color? color;
  final double elevation;
  final EdgeInsetsGeometry? margin;

  const HealthCard({
    super.key,
    required this.child,
    this.color,
    this.elevation = 2,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color ?? Theme.of(context).cardTheme.color,
      elevation: elevation,
      margin: margin ?? Theme.of(context).cardTheme.margin,
      shape: Theme.of(context).cardTheme.shape,
      child: Padding(padding: const EdgeInsets.all(16), child: child),
    );
  }
}

class HealthTextField extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  const HealthTextField({
    super.key,
    this.labelText,
    this.hintText,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        suffixIcon: suffixIcon,
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isFullWidth;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isFullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(text, style: AppTextStyles.button(context)),
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isFullWidth;

  const SecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isFullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: OutlinedButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: AppTextStyles.button(
            context,
          ).copyWith(color: Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
}
