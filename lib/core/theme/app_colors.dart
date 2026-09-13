import 'package:flutter/material.dart';

/// Yuro 的品牌色与语义色。
///
/// 颜色灵感来自夜间聆听：低亮度墨色承载内容，月光紫用于主操作，
/// 雾粉色只作为少量强调，避免长时间观看时产生视觉疲劳。
class AppColors {
  const AppColors._();

  static const moonViolet = Color(0xFF8B7CF6);
  static const blushPink = Color(0xFFF08FAE);
  static const midnightInk = Color(0xFF111016);
  static const softMist = Color(0xFFF8F7FC);
  static const deepSurface = Color(0xFF1A1821);
  static const lightSurface = Color(0xFFFFFFFF);

  static final ColorScheme lightColorScheme = ColorScheme.fromSeed(
    seedColor: moonViolet,
    brightness: Brightness.light,
  ).copyWith(
    primary: const Color(0xFF6658D3),
    onPrimary: Colors.white,
    primaryContainer: const Color(0xFFEAE6FF),
    onPrimaryContainer: const Color(0xFF211B58),
    secondary: const Color(0xFFB65378),
    onSecondary: Colors.white,
    secondaryContainer: const Color(0xFFFFD9E4),
    onSecondaryContainer: const Color(0xFF431126),
    tertiary: const Color(0xFF566F9C),
    surface: softMist,
    surfaceContainer: lightSurface,
    surfaceContainerLow: const Color(0xFFF2F0F8),
    surfaceContainerHigh: const Color(0xFFECEAF3),
    surfaceContainerHighest: const Color(0xFFE4E1EC),
    onSurface: const Color(0xFF1C1B20),
    onSurfaceVariant: const Color(0xFF66616F),
    outline: const Color(0xFF7B7585),
    outlineVariant: const Color(0xFFD0CCD8),
    error: const Color(0xFFBA1A1A),
    errorContainer: const Color(0xFFFFDAD6),
  );

  static final ColorScheme darkColorScheme = ColorScheme.fromSeed(
    seedColor: moonViolet,
    brightness: Brightness.dark,
  ).copyWith(
    primary: const Color(0xFFB9AEFF),
    onPrimary: const Color(0xFF30256F),
    primaryContainer: const Color(0xFF493E92),
    onPrimaryContainer: const Color(0xFFE7E1FF),
    secondary: const Color(0xFFFFABC4),
    onSecondary: const Color(0xFF5D1833),
    secondaryContainer: const Color(0xFF762D49),
    onSecondaryContainer: const Color(0xFFFFD9E4),
    tertiary: const Color(0xFFB7C8F4),
    surface: midnightInk,
    surfaceContainer: deepSurface,
    surfaceContainerLow: const Color(0xFF17151C),
    surfaceContainerHigh: const Color(0xFF24212D),
    surfaceContainerHighest: const Color(0xFF302C3A),
    onSurface: const Color(0xFFEAE6EF),
    onSurfaceVariant: const Color(0xFFC9C3D2),
    outline: const Color(0xFF938D9D),
    outlineVariant: const Color(0xFF484451),
    error: const Color(0xFFFFB4AB),
    errorContainer: const Color(0xFF93000A),
  );
}
