import 'package:flutter/material.dart';

class HeaderText extends StatelessWidget {
  final String label;
  final String? subText;
  final Widget? trailing;
  final TextStyle? titleStyle, subtitleStyle;
  final EdgeInsets? padding;
  final CrossAxisAlignment? crossAxisAlignment;
  final MainAxisAlignment? mainAxisAlignment;
  final bool centerSubtitle;

  const HeaderText({
    super.key,
    required this.label,
    this.trailing,
    this.subText,
    this.titleStyle,
    this.subtitleStyle,
    this.padding,
    this.crossAxisAlignment,
    this.mainAxisAlignment,
    this.centerSubtitle = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(vertical: 34),
      child: Column(
        crossAxisAlignment: crossAxisAlignment??CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // const SizedBox(height: 34),
          Text(
            label,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ).merge(titleStyle),
          ),
          const SizedBox(height: 4),
          Text(
            subText ??
                'Please ensure that the Information you fill is valid and real',
            textAlign: centerSubtitle ? TextAlign.center:TextAlign.start,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: Color(0xff696E7E)
            ).merge(subtitleStyle),
          ),
          // const SizedBox(height: 34),
        ],
      ),
    );
  }
}
