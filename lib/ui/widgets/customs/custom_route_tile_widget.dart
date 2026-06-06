import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/res/icons.dart';
import '../../../app/res/svgs.dart';
import 'custom_tile_widget.dart';

class CustomRouteTileWidget extends StatelessWidget {
  final String? svgIcon;
  final String title;
  final String subtitle;
  final Function()? onTap;
  final TextStyle? titleTextStyle;

  const CustomRouteTileWidget({
    super.key,
    required this.title,
    required this.subtitle,
    this.svgIcon, this.onTap,
    this.titleTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomTileWidget(
        title: title,
        titleTextStyle: titleTextStyle,
        subTitle: Row(
          children: [
            SvgPicture.asset(AppIcons.clockOutlined, width: 14, height: 14),
            SizedBox(width: 4),
            Text(
              subtitle,
              style: TextStyle(fontSize: 12, color: Color(0xff696E7E)),
            ),
          ],
        ),
        trailing: SvgPicture.asset(AppIcons.arrowCircleRight),
        svgIcon: svgIcon ?? AppSvgs.location,
      ),
    );
  }
}
