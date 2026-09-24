import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../ui/blocs/available_routes/available_routes_bloc.dart';
import '../../ui/blocs/country/country_bloc.dart';
import '../../ui/blocs/profile/profile_bloc.dart';
import '../../ui/blocs/checkout/checkout_bloc.dart';
import '../../ui/layout/cubit/bottom_nav_layout_bloc.dart';
import '../../ui/screens/account_setup/bloc/account_setup_bloc.dart';
import '../../ui/screens/auth/bloc/auth_bloc.dart';
import '../../ui/screens/chat/bloc/chat_bloc.dart';
import '../../ui/screens/dashboard/bookings/bloc/bookings_bloc.dart';
import '../../ui/blocs/trip_review/trip_review_bloc.dart';
import '../repos/auth_repo.dart';
import '../repos/bookings_repo.dart';
import '../repos/chat_repo.dart';
import '../repos/coutry_repo.dart';
import '../repos/payment_repo.dart';
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
        BlocProvider<AvailableTripsBloc>(
          lazy: true,
          create: (ctx) => AvailableTripsBloc(repo: ctx.read<TripsRepo>()),
        ),
        // BlocProvider<PackageBloc>(
        //   lazy: true,
        //   create: (cxt) => PackageBloc(
        //     repo: cxt.read<TripsRepo>(),
        //     paymentRepo: cxt.read<PaymentRepo>(),
        //   ),
        // ),
        BlocProvider<BookingsBloc>(
          lazy: true,
          create: (cxt) => BookingsBloc(
            repo: cxt.read<BookingsRepo>(),
            tripsRepo: cxt.read<TripsRepo>(),
          ),
        ),
        BlocProvider<ProfileBloc>(
          lazy: true,
          create: (cxt) => ProfileBloc(
            userRepo: cxt.read<UserRepo>(),
            authRepo: cxt.read<AuthRepo>(),
          ),
        ),
        BlocProvider<ChatBloc>(
          lazy: true,
          create: (cxt) => ChatBloc(cxt.read<ChatRepo>()),
        ),
        BlocProvider<CheckoutBloc>(
          lazy: true,
          create: (cxt) => CheckoutBloc(
            repo: cxt.read<TripsRepo>(),
            paymentRepo: cxt.read<PaymentRepo>(),
          ),
        ),
        BlocProvider<BottomNavLayoutCubit>(
          create: (_) => BottomNavLayoutCubit(),
          lazy: false,
        ),
        BlocProvider<TripReviewBloc>(
          lazy: true,
          create: (cxt) => TripReviewBloc(cxt.read<TripsRepo>()),
        ),
      ],
      child: child,
    );
  }
}
