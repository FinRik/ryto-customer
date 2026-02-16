import 'package:flutter/material.dart';

class HeaderText extends StatelessWidget {
  final String label;
  final String? subText;
  final Widget? trailing;

  const HeaderText({
    super.key,
    required this.label,
    this.trailing,
    this.subText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 34),
        Text(
          label,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subText ??
              'Please ensure that the Information you fill is valid and real',
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: Color(0xff696E7E)
          ),
        ),
        const SizedBox(height: 34),
      ],
    );
  }
}
