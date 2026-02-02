import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oikos/core/presentation/widgets/my_drawer.dart';
import 'package:oikos/features/Admin/presentation/pages/community_management_page.dart';
import 'package:oikos/features/Admin/presentation/pages/global_vue_page.dart';
import 'package:oikos/core/theme/admin_theme.dart';
import 'package:flutter/material.dart';
import 'package:oikos/features/admin/presentation/bloc/carbon_stats_bloc.dart';
import 'package:oikos/features/admin/presentation/bloc/community_bloc.dart';
import 'package:oikos/injection_container.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) =>  sl<Co2PerformanceBloc>()),
            BlocProvider(create: (context) => sl<CommunityBloc>())
          ],
          child: Theme(
            data: AdminTheme.lightTheme,
            child: Builder(
              // Le Builder crée un nouveau contexte sous le Theme
              builder: (innerContext) {
                return Scaffold(
                  extendBodyBehindAppBar: true,
                  appBar: AppBar(
                    toolbarHeight: 70,
                    title: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/logos/v_viveris_noir.png',
                          height: 40,
                        ),
                        const SizedBox(width:8),
                        const Text(
                          'Oikos Admin',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  drawer: const MyDrawer(),
                  body: Container(
                    decoration: BoxDecoration(
                      gradient: Theme.of(
                        innerContext,
                      ).extension<MyColors>()?.mainGradient,
                    ),
                    child: SafeArea( 
                      child: child,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
      routes: [
        GoRoute(path: '/', builder: (context, state) => GlobalVuePage()),
        GoRoute(
          path: '/community',
          builder: (context, state) => CommunityManagementPage(),
        ),
      ],
    ),
  ],
);
