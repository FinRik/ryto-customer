import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomTileWidget extends StatelessWidget {
  final IconData? leadingIcon;
  final String? svgIcon;
  final String title;
  final String subtitle;

  /// Optional trailing widget (Switch, custom icon, etc.)
  final Widget? trailing;

  /// If true, shows default arrow_forward when trailing is null
  final bool showArrow;

  const CustomTileWidget({
    super.key,
    this.leadingIcon,
    required this.title,
    required this.subtitle,
    this.svgIcon,
    this.trailing,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Color(0xffF9F9F9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          /// Leading Icon Container
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Color(0xffE6EFFD),
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: svgIcon != null
                  ? SvgPicture.asset(svgIcon!, height: 24,width: 24,)
                  : Icon(leadingIcon, color: Colors.blue, size: 24),
            ),
          ),

          const SizedBox(width: 8),

          /// Title + Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                // const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: Color(0xff696E7E)),
                ),
              ],
            ),
          ),

          /// Trailing Section
          trailing ??
              (showArrow
                  ? const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 20,
                      color: Colors.grey,
                    )
                  : const SizedBox()),
        ],
      ),
    );
  }
}
