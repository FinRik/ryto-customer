import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../colors.dart';
import '../../../../../core/models/ui/package_size.dart';
import '../../../../styles/app_decorations.dart';

class PackageContentSelector extends StatelessWidget {
  const PackageContentSelector({
    super.key,
    required this.allowed,       // Respect driver's capability setting
    required this.selectedSize,  // Controlled active selection string passed from parent
    required this.onSelected,    // Bubble up selected model instance directly
  });

  final bool allowed;
  final String? selectedSize;
  final ValueChanged<PackageSize?> onSelected;

  @override
  Widget build(BuildContext context) {
    // If the driver doesn't accept standalone cargo delivery at all,
    // fall back to a clean message notice to prevent impossible operations.
    if (!allowed) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.amber.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.amber.shade900),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                "This driver does not accept standalone parcel shipping for this ride configuration.",
                style: TextStyle(fontSize: 13, color: Colors.black87),
              ),
            ),
          ],
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 12,
      children: PackageDetails.packageContents.map((PackageSize item) {
        // Evaluate matches directly against the parent's string variable tracking choice
        final isSelected = selectedSize == item.name;

        return GestureDetector(
          onTap: () {
            onSelected(isSelected ? null : item);
          },
          child: Container(
            decoration: AppDecoration.roundedOutlinedRadius8.copyWith(
              borderRadius: BorderRadius.circular(100),
              color: isSelected ? AppColors.primary : null,
              border: isSelected
                  ? null
                  : Border.all(color: Colors.grey.shade300),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  item.icon,
                  width: 16,
                  height: 16,
                  colorFilter: ColorFilter.mode(
                    isSelected ? Colors.white : const Color(0xff666E7A),
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  item.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}