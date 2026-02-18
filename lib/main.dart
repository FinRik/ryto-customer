import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/core.dart';
import 'ui/layout/cubit/bottom_nav_layout_bloc.dart';
import 'ui/styles/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BottomNavLayoutCubit>(
          create: (_) => BottomNavLayoutCubit(),
          lazy: false,
        ),
      ],
      child: MaterialApp.router(
        title: 'Ryto Customer',
        debugShowCheckedModeBanner: false,
        routerDelegate: router.routerDelegate,
        scaffoldMessengerKey: scaffoldMessengerKey,
        routeInformationParser: router.routeInformationParser,
        routeInformationProvider: router.routeInformationProvider,

        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.light,

        builder: (context, child) => child!,
      ),
    );
  }
}
