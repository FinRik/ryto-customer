import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/models/ui/package_size.dart';
import '../../../../styles/app_decorations.dart';

class PackageSizesSelector extends StatefulWidget {
  final Function(String) onChanged;

  const PackageSizesSelector({super.key, required this.onChanged});

  @override
  State<PackageSizesSelector> createState() => _PackageSizesSelectorState();
}

class _PackageSizesSelectorState extends State<PackageSizesSelector> {
  String? _selectedSize; // nullable = nothing selected initially

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 12,
      children: PackageDetails.packageSizes.map((e) {
        final isSelected = _selectedSize == e.title;

        return GestureDetector(
          onTap: () {
            setState(() => _selectedSize = e.title);
            widget.onChanged(e.id);
          },
          child: Container(
            decoration: AppDecoration.roundedOutlinedRadius8.copyWith(
              borderRadius: BorderRadius.circular(100),
              color: isSelected ? Colors.blue : null,
              border: isSelected
                  ? null
                  : Border.all(color: Colors.grey.shade300),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  e.icon,
                  colorFilter: ColorFilter.mode(
                    isSelected ? Colors.white : Colors.black,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  e.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : Colors.black,
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
