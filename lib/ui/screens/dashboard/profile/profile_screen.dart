import 'package:flutter/material.dart';

import '../../../widgets/custom_app_bar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          removeHorizPadding: true,
        ),
        body: Column(
          children: [
            Container(
              color: Color(0xffE3FB20),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30,
                  ),
                  SizedBox(height: 12),
                  Text("Jaiyeoluwa"),
                  SizedBox(height: 4,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Icon(Icons.star),
                    SizedBox(width: 4,),
                    Text("5.0 (100+)"),
                  ],)
                ],
              ),
            ),

            ///body
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
