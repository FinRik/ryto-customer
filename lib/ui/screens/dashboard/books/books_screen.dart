import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ryto_customer/app/res/res.dart';

import '../../../styles/app_decorations.dart';
import '../../../widgets/customs/custom_tile_widget.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/poplar_routes_section.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({super.key});

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// HEADER STACK
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 350,
                  width: double.infinity,
                  decoration: AppDecoration.dashboardDeco,
                ),
        
                /// OVERLAY CARD
                Positioned(
                  top: 40,
                  left: 24,
                  right: 24,
                  child: DashboardHeader(),
                ),
              ],
            ),
        
            const SizedBox(height: 240),
        
            /// Popular Routes
            PoplarRoutesSection(),
          ],
        ),
      ),
    );
  }
}
