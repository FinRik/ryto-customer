import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/res/images.dart';
import '../../../../core/models/ui/trip_item_model.dart';
import '../../../../core/routes/routes.dart';
import '../../../styles/app_decorations.dart';
import '../../../widgets/buttons/back_arrow_button.dart';
import '../../../widgets/buttons/sc_button.dart';
import '../../../widgets/texts/header_text.dart';
import 'widgets/trip_list_item.dart';
import 'widgets/trip_route_card.dart';

class AvailableTripsScreen extends StatelessWidget {
  const AvailableTripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffF9F9F9),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: BackArrowButton(),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 11),
              decoration: BoxDecoration(color: Color(0xff002252)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TripRouteCard(
                    origin: 'Lagos',
                    destination: 'Ibadan',
                    onEdit: () {},
                  ),
                  SizedBox(height: 10),
                  Text(
                    "February 12  > 2 Pasengers",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            TripItemModel.trips.isEmpty
                ? Column(
                    children: [
                      SizedBox(height: 65),
                      Container(
                        decoration: AppDecoration.roundedOutlinedRadius8
                            .copyWith(
                              color: Colors.white,
                              border: Border.all(color: Color(0xffE7E8E9)),
                            ),
                        margin: EdgeInsets.symmetric(horizontal: 24),
                        padding: EdgeInsets.symmetric(
                          horizontal: 27.5,
                          vertical: 24,
                        ),
                        child: Column(
                          children: [
                            Image.asset(AppImages.car, height: 100),
                            HeaderText(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              label: "No drivers available yet?",
                              titleStyle: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                              subText:
                                  "Turn on alerts and we’ll notify you by push, SMS, or email as soon as a driver becomes available for your selected route and time.",
                              subtitleStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                              centerSubtitle: true,
                            ),
                            ScButton(
                              btnText: "Notify me when available",
                              onClick: () {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 23.33),
                          Text("3 Trips Available"),
                          SizedBox(height: 23.33),
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: TripItemModel.trips.length,
                              itemBuilder: (context, index) {
                                return TripListItem(
                                  model: TripItemModel.trips[index],
                                  onTap: () {
                                    context.push(Paths.BOOKATRIP);
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
