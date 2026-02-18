import 'package:flutter/material.dart';

import '../../../../styles/app_spacing.dart';

class SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            // color: AppColors.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Column(
          children: children
              .map(
                (child) => Padding(
              padding:
              const EdgeInsets.only(bottom: AppSpacing.itemSpacing),
              child: child,
            ),
          )
              .toList(),
        ),
      ],
    );
  }
}
