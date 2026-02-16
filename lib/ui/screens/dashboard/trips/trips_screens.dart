import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../app/res/logos.dart';
import '../../../widgets/custom_app_bar.dart';

class TripsScreen extends StatefulWidget {
  const TripsScreen({super.key});

  @override
  State<TripsScreen> createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(removeHorizPadding: true),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "My Trips",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                  ),

                  Tooltip(
                    message: "widget.labelTip",
                    child: const Icon(
                      Icons.info_outline,
                      size: 24,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            TabBar(
              dividerColor: Colors.transparent,
              controller: tabController,
              // indicator: UnderlineTabIndicator(),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerHeight: 1,
              indicatorWeight: .5,
              tabs: [
                Tab(text: "Active"),
                Tab(text: "Upcoming"),
                Tab(text: "Past"),
              ],
            ),

            ///Body
            SizedBox(height: 26.36),
            Expanded(
              child: TabBarView(
                controller: tabController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Container(color: Colors.yellow),
                  Container(color: Colors.green),
                  Container(color: Colors.amber),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
