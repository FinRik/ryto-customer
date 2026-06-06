import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../app/app_setup_locator.dart';
import '../../../core/setups/region_identity_setup.dart';
import '../../blocs/profile/profile_bloc.dart';
import '../../layout/cubit/bottom_nav_layout_bloc.dart';
import '../dp_image_widget.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, this.removeHorizPadding = false});
  final bool removeHorizPadding;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        // Show shimmer ONLY if we are loading AND have no cached data
        if (state.status == ProfileStatus.loading && state.user == null) {
          return _buildShimmer(context);
        }

        // Otherwise, show the actual UI
        final user = state.user;
        final initials =
            user?.fullname
                .split(' ')
                .map((e) => e[0])
                .take(2)
                .join()
                .toUpperCase() ??
            "??";

        return Padding(
          padding: EdgeInsets.symmetric(
            vertical: 8,
            horizontal: removeHorizPadding ? 24 : 0,
          ),
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildProfileAvatar(context, state, initials),
                _buildCurrencySelector(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildShimmer(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: removeHorizPadding ? 24 : 0,
      ),
      child: SafeArea(
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Circle Avatar Shimmer
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              // Currency Capsule Shimmer
              Container(
                width: 100,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(61),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileAvatar(
    BuildContext context,
    ProfileState state,
    String initials,
  ) {
    return GestureDetector(
      onTap: () => context.read<BottomNavLayoutCubit>().moveTo(3),
      child: DpImageWidget(
        imageUrl: state.user?.imageUrl,
        initials: initials.toUpperCase(),
        showEditIcon: false,
        height: 48,
      ),
    );
  }

  Widget _buildCurrencySelector() {
    final region = sl<RegionIdentity>();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(61),
        color: Colors.white,
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 8,
            backgroundColor: Colors.blue,
          ), // Placeholder
          const SizedBox(width: 4),
          Text(
            region.currencyCode,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 20);
}
