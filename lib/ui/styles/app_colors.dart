// lib/core/theme/app_colors.dart
import 'package:flutter/material.dart';

abstract class AppSeedColors {
  static const seedPrimary = Color(0xFF0060EB);
  static const seedSecondary = Color(0xFFE3FB20);
  static const seedTertiary = Color(0xFF2AC769);
}

abstract class AppFixedColors {
  // Semantic error/warning colors (usually fixed – not derived from seed)
  static const error = Color(0xFFE52836);
  static const errorContainer = Color(0xFFFFDAD6);
  static const onError = Color(0xFFFFFFFF);

  static const warning = Color(0xFFF6A609);
  static const success = Color(0xFF2AC769);

  // True black & white (used rarely)
  static const white = Colors.white;
  static const black = Colors.black;
}

abstract class AppNeutrals {
  // Light theme neutrals
  static const grey50 = Color(0xFFF9F9F9);
  static const grey100 = Color(0xFFE7E8E9);
  static const grey200 = Color(0xFFE4E7EC);
  static const grey300 = Color(0xFFCBD2D9);
  static const grey400 = Color(0xFFA8B2BD);
  static const grey500 = Color(0xFF88929E);
  static const grey600 = Color(0xFF66707A);
  static const grey700 = Color(0xFF4D5761);
  static const grey800 = Color(0xFF343D45);
  static const grey900 = Color(0xFF1F252A);
}