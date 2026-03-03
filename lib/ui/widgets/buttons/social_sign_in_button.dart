import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialSignInButton extends StatelessWidget {
  final String text;
  final String? icon;
  final VoidCallback onTap;
  final TextStyle? btnTextStyle;
  final bool isCenterAligned;
  final Color? borderColor;

  const SocialSignInButton({
    super.key,
    required this.text,
    this.icon,
    required this.onTap,
    this.btnTextStyle,
    this.isCenterAligned = false,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 44),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: borderColor ?? Colors.grey.shade400, width: 1.2),
        ),
        child: Row(
          mainAxisAlignment: isCenterAligned
              ? MainAxisAlignment.center
              : MainAxisAlignment.spaceBetween,
          children: [
            if (icon != null) SvgPicture.asset(icon!),
            isCenterAligned ? SizedBox(width: 4) : SizedBox(),
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ).merge(btnTextStyle),
            ),
            SizedBox(),
          ],
        ),
      ),
    );
  }
}
