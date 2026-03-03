import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/models/ui/package_size_model.dart';
import '../../../../core/models/ui/trip_item_model.dart';
import '../../../../core/routes/routes.dart';
import '../../../widgets/buttons/back_arrow_button.dart';
import '../../../widgets/buttons/sc_button.dart';
import '../booking_history/widgets/driver_score_card.dart';
import '../../../widgets/scrollable/grid_view_widget.dart';
import '../../../widgets/texts/header_text.dart';
import '../../../widgets/customs/custom_card_widget.dart';
import '../package/widgets/package_size_list_item.dart';

class BookATripScreen extends StatefulWidget {
  const BookATripScreen({super.key});

  @override
  State<BookATripScreen> createState() => _BookATripScreenState();
}

class _BookATripScreenState extends State<BookATripScreen> {
  bool isChecked = false;

  late PackageSizeModel _selectedPackageSize;

  updatePackageSize(PackageSizeModel value) => setState(() {
    _selectedPackageSize = value;
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF9F9F9),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 11, horizontal: 24),
                decoration: BoxDecoration(
                  border: BoxBorder.all(color: Color(0xffE7E8E9), width: 1),
                ),
                child: Row(
                  children: [
                    BackArrowButton(),
                    SizedBox(width: 17),
                    Column(
                      children: [
                        HeaderText(
                          padding: EdgeInsets.zero,
                          label: "Trip Details",
                          subText: "Lagos → Ibadan",
                          titleStyle: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Color(0xff222328),
                          ),
                          subtitleStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                            color: Color(0xff222328),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 18),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    DriverScoreCard(
                      model: TripItemModel.driverDetail,
                      showTruckCapacity: true,
                    ),
                    SizedBox(height: 29,),
                    CustomCardWidget(
                      title: "Select your luggage",
                      child: GridViewWidget(
                        list: PackageSizeModel.luggageSizes,
                        builder: (int index, listItem, bool isSelected) {
                          return PackageSizeListItem(
                            isItemSelected: isSelected,
                            listItem: listItem!,
                          );
                        },
                        onSelected: (selectedItem) {
                          updatePackageSize(selectedItem);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        child: Container(
          height: 130,
          color: Color(0xffE7E8E9),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          // Optional: give it elevation / shadow if you want the "floating card" look
          // elevation: 8,
          // Optional: change color if needed
          // color: Theme.of(context).colorScheme.surface,
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                    value: isChecked,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked = value ?? false;
                      });
                    },
                  ),
                  Expanded(
                    child: Text(
                      "By checking box  I agree and accept our terms of service",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "₦500,000",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ScButton(
                      onClick: () {
                        context.push(Paths.PAYFORTRIP);
                      },
                      btnText: "Continue",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
