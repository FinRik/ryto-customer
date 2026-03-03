import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/models/ui/package_size_model.dart';
import '../../../../styles/app_decorations.dart';

class PackageSizesSelector extends StatefulWidget {
  const PackageSizesSelector({super.key});

  @override
  State<PackageSizesSelector> createState() => _PackageSizesSelectorState();
}

class _PackageSizesSelectorState extends State<PackageSizesSelector> {
  // Store selected items (using title as identifier)
  final Set<String> _selectedSizes = {};

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.start,
      runAlignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.start,
      spacing: 8,
      runSpacing: 12,
      children: PackageDetails.packageSizes.map((e) {
        final isSelected = _selectedSizes.contains(e.title);

        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                _selectedSizes.remove(e.title);
              } else {
                _selectedSizes.add(e.title);
              }
              // Optional: print(_selectedSizes); // for debugging
            });
          },
          child: Container(
            decoration: AppDecoration.roundedOutlinedRadius8.copyWith(
              borderRadius: BorderRadius.circular(100),
              color: isSelected
                  ? Colors.blue
                  : null, // ← background when selected
              border: isSelected
                  ? null
                  : Border.all(
                      color: Colors.grey.shade300,
                    ), // optional: hide border when selected
            ),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  e.icon,
                  colorFilter: ColorFilter.mode(
                    isSelected ? Colors.white : Colors.black, // ← icon color
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  e.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? Colors.white
                        : Colors.black, // ← text color
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
