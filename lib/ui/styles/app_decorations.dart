import 'package:flutter/material.dart';

class AppDecoration {
  AppDecoration._();

  static const Decoration dashboardDeco = BoxDecoration(
    color: Color(0xFF1565D8),
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(60),
      bottomRight: Radius.circular(60),
    ),
  );

  static BoxDecoration bookingOverlayDeco = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(24),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.08),
        blurRadius: 20,
        offset: const Offset(0, 10),
      ),
    ],
  );
}
