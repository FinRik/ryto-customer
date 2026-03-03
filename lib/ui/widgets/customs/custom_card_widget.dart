import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../styles/app_decorations.dart';

class CustomCardWidget extends StatelessWidget {
  const CustomCardWidget({
    super.key,
    required this.title,
    this.bgColor,
    this.border,
    required this.child,
    this.icon,
    this.iconColor,
    this.bottomMargin,
  });

  final String title;
  final Color? bgColor;
  final BoxBorder? border;
  final Widget child;
  final String? icon;
  final Color? iconColor;
  final double? bottomMargin;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecoration.roundedOutlinedRadius8.copyWith(
        color: bgColor,
        border: border,
      ),
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: bottomMargin ?? 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: icon != null
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
              if (icon != null) SvgPicture.asset(icon!, color: iconColor),
            ],
          ),
          SizedBox(height: 16),
          Container(child: child),
        ],
      ),
    );
  }
}
