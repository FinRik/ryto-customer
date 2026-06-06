import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/app_setup_locator.dart';
import '../../../../core/setups/region_identity_setup.dart';
import '../../../blocs/profile/profile_bloc.dart';
import '../../../styles/app_decorations.dart';
import 'bloc/trip_setup_bloc.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/poplar_routes_section.dart';

class TripsSetupScreen extends StatefulWidget {
  const TripsSetupScreen({super.key});

  @override
  State<TripsSetupScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<TripsSetupScreen> {
  @override
  void initState() {
    super.initState();
    final bloc = context.read<TripSetupBloc>();
    final region = sl<RegionIdentity>();
    if (bloc.state.routesStatus != PopularRoutesStatus.success) {
      bloc.add(FetchRoutesRequested(region.currencyCode));
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileBloc>().add(const FetchUserProfile());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TripSetupBloc, TripSetupState>(
        builder: (context, state) => SingleChildScrollView(
          child: Column(
            children: [
              /// HEADER STACK
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 400,
                    decoration: AppDecoration.dashboardDeco,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 40, left: 24, right: 24),
                    child: DashboardHeader(),
                  ),
                ],
              ),

              const SizedBox(height: 27),

              /// Popular Routes Section
              PoplarRoutesSection(
                isLoading: state.routesStatus == PopularRoutesStatus.loading,
                routes: state.routes,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
