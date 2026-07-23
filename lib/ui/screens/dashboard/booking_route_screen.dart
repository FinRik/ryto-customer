import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/inputs/place_suggestion_widget.dart';
import '../../widgets/layouts/base_scaffold_widget.dart';
import '../../widgets/buttons/back_arrow_button.dart';
import '../../widgets/trip_route_map.dart';
import '../../widgets/buttons/button.dart';
import '../../../core/models/lat_lng.dart';
import '../../../core/routes/router.dart';
import 'trip_setup/widgets/route_indicator.dart';

class BookingRouteScreen extends StatefulWidget {
  const BookingRouteScreen({super.key, required this.args});

  final BookingRouteArgs args;

  @override
  State<BookingRouteScreen> createState() => _SetTripRouteScreenState();
}

class _SetTripRouteScreenState extends State<BookingRouteScreen> {
  final _originController = TextEditingController();
  final _destinationController = TextEditingController();
  LatLng? _pickup;
  LatLng? _dropOff;

  void _updateLocation({
    required bool isOrigin,
    required double lat,
    required double lng,
    required String address,
  }) {
    if (isOrigin == true) {
      _pickup = LatLng(lat: lat, lng: lng, address: address);
    } else {
      _dropOff = LatLng(lat: lat, lng: lng, address: address);
    }
  }

  void _swapLocations() {
    setState(() {
      // Swap text controllers.
      final tempText = _originController.text;
      _originController.text = _destinationController.text;
      _destinationController.text = tempText;

      // Swap cached LatLngs used by the map.
      final tempLatLng = _pickup;
      _pickup = _dropOff;
      _dropOff = tempLatLng;
    });
  }

  @override
  void dispose() {
    _originController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldWidget(
      removePadding: true,
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(12.0),
          child: BackArrowButton(),
        ),
        title: const Text(
          "Set Route",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B2559),
          ),
        ),
        centerTitle: true,
      ),
      child: GestureDetector(
        // Tapping outside the fields dismisses the keyboard.
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            TripRouteMap(
              olat: _pickup?.lat,
              olng: _pickup?.lng,
              dlat: _dropOff?.lat,
              dlng: _dropOff?.lng,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.only(bottom: 120),
                padding: const EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 40, right: 40),
                          child: Column(
                            children: [
                              _buildAutocompleteField(
                                controller: _originController,
                                label: "Pickup Location",
                                hint: "From",
                                isOrigin: true,
                              ),
                              const SizedBox(height: 16),
                              _buildAutocompleteField(
                                controller: _destinationController,
                                label: "Drop-Off Location",
                                hint: "Where to?",
                                isOrigin: false,
                              ),
                            ],
                          ),
                        ),
                        const Positioned(
                          left: 0,
                          top: 25,
                          bottom: 25,
                          child: RouteIndicator(),
                        ),
                        // Swap button on the right side of the fields.
                        Positioned(
                          right: 0,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: Material(
                              color: const Color(0xff137FEC).withOpacity(.10),
                              shape: const CircleBorder(),
                              child: InkWell(
                                customBorder: const CircleBorder(),
                                onTap: _swapLocations,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.swap_vert,
                                    size: 20,
                                    color: const Color(0xff137FEC),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Action Button
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Button(
                  text: "Continue",
                  showSuffixIcon: true,
                  onTap: () {
                    if (_pickup?.lat != null && _dropOff?.lat != null) {
                      context.push(
                        widget.args.path,
                        extra: BookingDetailsArgs(
                          ride: widget.args.ride,
                          dropOff: _dropOff!,
                          pickup: _pickup!,
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAutocompleteField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool isOrigin,
  }) {
    return PlacesSuggestionWidget(
      hint: hint,
      label: label,
      labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 10),
      controller: controller,
      prefixIcon: null,
      onPlaceSelected: (place) async {
        _updateLocation(
          isOrigin: isOrigin,
          lat: place.lat,
          lng: place.lng,
          address: place.address!,
        );
      },
    );
  }
}
