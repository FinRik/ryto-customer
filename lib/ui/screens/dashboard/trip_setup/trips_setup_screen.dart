import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/app_setup_locator.dart';
import '../../../../core/setups/region_identity_setup.dart';
import '../../../blocs/available_routes/available_routes_bloc.dart';
import '../../../blocs/profile/profile_bloc.dart';
import '../../../styles/app_decorations.dart';
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

    final availableTripsBloc = context.read<AvailableTripsBloc>();
    final region = sl<RegionIdentity>();

    if (availableTripsBloc.state.routesStatus != PopularRoutesStatus.success) {
      availableTripsBloc.add(FetchPopularRoutes(region.currencyCode));
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileBloc>().add(const FetchUserProfile());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// HEADER STACK
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(height: 400, decoration: AppDecoration.dashboardDeco),
                const Padding(
                  padding: EdgeInsets.only(top: 40, left: 24, right: 24),
                  child: DashboardHeader(),
                ),
              ],
            ),

            const SizedBox(height: 27),

            BlocBuilder<AvailableTripsBloc, AvailableTripsState>(
              builder: (context, state) => PoplarRoutesSection(
                isLoading: state.routesStatus == PopularRoutesStatus.loading,
                routes: state.routes,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
