import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/app_setup_locator.dart';
import '../../../../core/setups/region_identity_setup.dart';
import '../../../styles/app_decorations.dart';
import 'bloc/package_bloc.dart';
import 'widgets/packages_header_section.dart';
import 'widgets/packages_routes_section.dart';

class PackagesScreen extends StatefulWidget {
  const PackagesScreen({super.key});

  @override
  State<PackagesScreen> createState() => _PackagesScreenState();
}

class _PackagesScreenState extends State<PackagesScreen> {
  @override
  void initState() {
    super.initState();
    final bloc = context.read<PackageBloc>();
    final region = sl<RegionIdentity>();
    if (bloc.state.routesStatus != PopularRoutesStatus.success) {
      bloc.add(FetchRoutesRequested(region.currencyCode));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<PackageBloc, PackageState>(
        builder: (context, state) => SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.hardEdge,
                children: [
                  Positioned(
                    child: Container(
                      height: 400,
                      decoration: AppDecoration.dashboardDeco,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 40,
                      left: 24,
                      right: 24,
                    ),
                    child: PackagesHeaderSection(),
                  ),
                ],
              ),

              const SizedBox(height: 27),

              PackagesRoutesSection(
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
