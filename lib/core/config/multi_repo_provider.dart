import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/app_setup_locator.dart';
import '../repos/arrival_time_repo.dart';
import '../repos/auth_repo.dart';
import '../repos/bookings_repo.dart';
import '../repos/chat_repo.dart';
import '../repos/coutry_repo.dart';
import '../repos/payment_repo.dart';
import '../repos/places_repo.dart';
import '../repos/regional_manager_repo.dart';
import '../repos/trips_repo.dart';
import '../repos/user_repo.dart';
import '../services/api_service.dart';
import '../services/arrival_time_service.dart';
import '../services/chat_service.dart';
import '../services/g_api_service.dart';
import '../services/paystack_payment_service.dart';
import '../services/regional_manager_service.dart';
import '../services/stripe_payment_service.dart';

class MultiRepoProvider extends StatelessWidget {
  const MultiRepoProvider({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepo>(
          create: (_) => AuthRepoImpl(service: sl<ApiService>()),
          lazy: false,
        ),
        RepositoryProvider<UserRepo>(
          create: (_) => UserRepoImpl(service: sl<ApiService>()),
          lazy: false,
        ),
        RepositoryProvider<CountryRepo>(
          create: (_) => CountryRepoImpl(service: sl<GApiService>()),
          lazy: false,
        ),
        RepositoryProvider<PlacesRepo>(
          create: (_) => PlacesRepoImpl(service: sl<GApiService>()),
          lazy: false,
        ),
        RepositoryProvider<BookingsRepo>(
          create: (_) => BookingsRepoImpl(service: sl<ApiService>()),
          lazy: false,
        ),
        RepositoryProvider<TripsRepo>(
          create: (_) => TripsRepoImpl(service: sl<ApiService>()),
          lazy: false,
        ),
        RepositoryProvider<RegionalManagerRepo>(
          create: (_) => RegionalManagerRepoImpl(sl<RegionalManagerService>()),
          lazy: true,
        ),
        RepositoryProvider<ChatRepo>(
          create: (_) => ChatRepoImpl(sl<ChatService>()),
          lazy: true,
        ),
        RepositoryProvider<ArrivalTimeRepo>(
          create: (_) => ArrivalTimeRepoImpl(sl<ArrivalTimeService>()),
          lazy: true,
        ),
        RepositoryProvider<PaymentRepo>(
          create: (_) => PaymentRepoImpl(
            payStackService: sl<PayStackPaymentService>(),
            stripeService: sl<StripePaymentService>(),
          ),
          lazy: true,
        ),
        // RepositoryProvider(
        //   create: (_) => AppLoaderController(),
        //   child: const AppLoader(),
        // ),
        // ChangeNotifierProvider(
        //   create: (context) => ThemeProvider(),
        // ),
        // ChangeNotifierProvider(
        //   create: (context) => MainScreenViewModel(),
        // ),
      ],
      child: child,
    );
  }
}
