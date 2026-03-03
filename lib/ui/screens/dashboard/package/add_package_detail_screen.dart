import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/res/icons.dart';
import '../../../../app/res/svgs.dart';
import '../../../../core/models/ui/package_size_model.dart';
import '../../../../core/routes/routes.dart';
import '../../../widgets/buttons/back_arrow_button.dart';
import '../../../widgets/buttons/sc_button.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/customs/custom_tile_widget.dart';
import '../../../widgets/inputs/general_text_field.dart';
import '../../../widgets/scrollable/grid_view_widget.dart';
import '../../../widgets/texts/header_text.dart';
import '../../../widgets/customs/custom_card_widget.dart';
import 'widgets/handling_options_card.dart';
import 'widgets/package_size_list_item.dart';
import 'widgets/package_sizes_selector.dart';

class AddPackageDetailScreen extends StatefulWidget {
  const AddPackageDetailScreen({super.key});

  @override
  State<AddPackageDetailScreen> createState() => _AddPackageDetailScreenState();
}

class _AddPackageDetailScreenState extends State<AddPackageDetailScreen> {
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
                    CustomCardWidget(
                      title: "Package Size",
                      child: GridViewWidget(
                        list: PackageSizeModel.packageSizes,
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
                    CustomCardWidget(
                      title: "What’s Inside?",
                      child: PackageSizesSelector(),
                    ),
                    CustomCardWidget(
                      title: "Additional Details",
                      child: Column(
                        children: [
                          GeneralTextField(
                            prefixIcon: null,
                            label: "Estimated Weight (Kg)",
                            hint: "E.g 2.5",
                            controller: TextEditingController(),
                          ),
                        ],
                      ),
                    ),
                    CustomCardWidget(
                      title: "Handling Options",
                      child: HandlingOptionsCard(),
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
        child: BottomAppBar(
          // Optional: give it elevation / shadow if you want the "floating card" look
          elevation: 8,
          // Optional: change color if needed
          // color: Theme.of(context).colorScheme.surface,
          child: ScButton(
            onClick: () {
              context.push(Paths.CONFIRMPACKAGEDETAIL, extra: _selectedPackageSize);
            },
            btnText: "Get Estimate",
          ),
        ),
      ),
    );
  }
}
