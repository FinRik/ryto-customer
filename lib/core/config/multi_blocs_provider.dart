import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../ui/blocs/country/country_bloc.dart';
import '../../ui/blocs/profile/profile_bloc.dart';
import '../../ui/layout/cubit/bottom_nav_layout_bloc.dart';
import '../../ui/screens/account_setup/bloc/account_setup_bloc.dart';
import '../../ui/screens/auth/bloc/auth_bloc.dart';
import '../../ui/screens/chat/bloc/chat_bloc.dart';
import '../../ui/screens/dashboard/trip_setup/bloc/trip_setup_bloc.dart';
import '../../ui/screens/dashboard/package/bloc/package_bloc.dart';
import '../../ui/screens/dashboard/bookings/bloc/bookings_bloc.dart';
import '../repos/auth_repo.dart';
import '../repos/bookings_repo.dart';
import '../repos/chat_repo.dart';
import '../repos/coutry_repo.dart';
import '../repos/trips_repo.dart';
import '../repos/user_repo.dart';

class MultiBlocsProvider extends StatelessWidget {
  const MultiBlocsProvider({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          lazy: true,
          create: (cxt) => AuthBloc(cxt.read<AuthRepo>()),
        ),
        BlocProvider<CountryBloc>(
          lazy: true,
          create: (cxt) => CountryBloc(cxt.read<CountryRepo>()),
        ),
        BlocProvider<AccountSetupBloc>(
          lazy: true,
          create: (cxt) => AccountSetupBloc(cxt.read<UserRepo>()),
        ),
        BlocProvider<TripSetupBloc>(
          lazy: true,
          create: (cxt) => TripSetupBloc(cxt.read<TripsRepo>()),
        ),
        BlocProvider<PackageBloc>(
          lazy: true,
          create: (cxt) => PackageBloc(cxt.read<TripsRepo>()),
        ),
        BlocProvider<BookingsBloc>(
          lazy: true,
          create: (cxt) => BookingsBloc(cxt.read<BookingsRepo>()),
        ),
        BlocProvider<ProfileBloc>(
          lazy: true,
          create: (cxt) => ProfileBloc(cxt.read<UserRepo>()),
        ),
        BlocProvider<ChatBloc>(
          lazy: true,
          create: (cxt) => ChatBloc(cxt.read<ChatRepo>()),
        ),
        BlocProvider<BottomNavLayoutCubit>(
          create: (_) => BottomNavLayoutCubit(),
          lazy: false,
        ),
      ],
      child: child,
    );
  }
}
