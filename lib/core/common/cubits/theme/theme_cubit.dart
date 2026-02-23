import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Manages the app-level [ThemeMode].
///
/// Inject at the root of the widget tree (see [main.dart]) and control from
/// any widget with:
/// ```dart
/// context.read<ThemeCubit>().setMode(ThemeMode.dark);
/// // or
/// context.read<ThemeCubit>().toggle();
/// ```
class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system);

  /// Sets an explicit theme mode.
  void setMode(ThemeMode mode) => emit(mode);

  /// Cycles between light and dark.
  /// If currently set to system, switches to light first.
  void toggle() {
    emit(state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
  }

  bool get isDark => state == ThemeMode.dark;
  bool get isLight => state == ThemeMode.light;
  bool get isSystem => state == ThemeMode.system;
}
