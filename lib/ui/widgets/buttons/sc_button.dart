import 'package:flutter/material.dart';

class ScButton extends StatelessWidget {
  const ScButton({super.key, this.onClick, this.btnText});

  final VoidCallback? onClick;
  final String? btnText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onClick,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0B5ED7),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: Text(btnText??"Get Started"),
      ),
    );
  }
}
