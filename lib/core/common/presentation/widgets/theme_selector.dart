import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/core/common/cubits/theme/theme_cubit.dart';

/// One appearance control shared by member and administrator profiles.
class ThemeSelector extends StatelessWidget {
  const ThemeSelector({super.key});

  @override
  Widget build(BuildContext context) => BlocBuilder<ThemeCubit, ThemeMode>(
    builder: (context, mode) => ListTile(
      leading: const Icon(Icons.brightness_6_outlined),
      title: const Text('Apparence'),
      trailing: DropdownButton<ThemeMode>(
        value: mode,
        onChanged: (value) {
          if (value != null) context.read<ThemeCubit>().setMode(value);
        },
        items: const [
          DropdownMenuItem(value: ThemeMode.system, child: Text('Système')),
          DropdownMenuItem(value: ThemeMode.light, child: Text('Clair')),
          DropdownMenuItem(value: ThemeMode.dark, child: Text('Sombre')),
        ],
      ),
    ),
  );
}
