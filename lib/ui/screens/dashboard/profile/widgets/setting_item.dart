import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../app/res/icons.dart';
import '../../../../../colors.dart';
import '../../../../styles/app_spacing.dart';
import '../profile_screen.dart';

class SettingItem extends StatelessWidget {
  final String? icon;
  final String title;
  final VoidCallback onTap;
  final TrailingType trailingType;
  final bool isDestructive;

  const SettingItem({
    super.key,
    this.icon,
    required this.title,
    required this.onTap,
    this.trailingType = TrailingType.chevron,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDestructive
        ? AppColors.destructive
        : AppColors.textPrimary;

    return InkWell(
      borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.itemPadding),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        ),
        child: Row(
          children: [
            if (icon != null)
              Row(
                children: [SvgPicture.asset(icon!), const SizedBox(width: 12)],
              ),
            Expanded(
              child: Text(
                title,
                style: TextStyle(color: textColor, fontSize: 16),
              ),
            ),
            SvgPicture.asset(
              trailingType == TrailingType.chevron
                  ? AppIcons.arrowRight
                  : trailingType == TrailingType.destructive
                  ? AppIcons.logout
                  : AppIcons.arrowRightUp,
              color: textColor,
            ),
          ],
        ),
      ),
    );
  }
}
