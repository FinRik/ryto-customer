import 'package:flutter/material.dart';

import '../../../../../app/res/svgs.dart';
import '../../../../../core/models/lat_lng.dart';
import '../../../../widgets/currency_formatter_widget.dart';
import '../../../../widgets/customs/svg_widget.dart';
import '../../../../widgets/location_fetch_builder.dart';

class StatusIndicatorHeader extends StatelessWidget {
  final String statusText;

  const StatusIndicatorHeader({super.key, required this.statusText});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgWidget(assetName: AppSvgs.hourGlass),
        const SizedBox(height: 16),
        Text(
          statusText,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B2559),
          ),
        ),
      ],
    );
  }
}

class TripDetailCard extends StatelessWidget {
  final String fare;
  final LatLng pickup;
  final LatLng dropOff;
  final String originAddress;
  final String destinationAddress;
  final String date;
  final String passengers;
  final String serviceTier;

  const TripDetailCard({
    super.key,
    required this.fare,
    required this.pickup,
    required this.dropOff,
    required this.originAddress,
    required this.destinationAddress,
    required this.date,
    required this.passengers,
    required this.serviceTier,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 4,
              decoration: const BoxDecoration(
                color: Color(0xFF0061FF),
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(20),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CurrencyFormatterWidget(
                          amount: fare,
                          textColor: Color(0xFF0061FF),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE2FF54),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            serviceTier,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildRoutePoint(
                      Icons.radio_button_checked,
                      pickup,
                      originAddress,
                      const Color(0xFF0061FF),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 11),
                      child: Container(
                        width: 1,
                        height: 20,
                        color: const Color(0xFFE0E5F2),
                      ),
                    ),
                    _buildRoutePoint(
                      Icons.location_on,
                      dropOff,
                      destinationAddress,
                      const Color(0xFF0061FF),
                    ),
                    const Divider(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInfoIcon(Icons.calendar_today_outlined, date),
                        _buildInfoIcon(Icons.people_outline, passengers),
                      ],
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

  Widget _buildRoutePoint(
    IconData icon,
    LatLng coord,
    String address,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, size: 22, color: color),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LocationFetchBuilder(
              address: coord,
              builder: (context, latlng) => Text(
                latlng?.address ?? "",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B2559),
                ),
              ),
            ),
            Text(
              address,
              style: const TextStyle(fontSize: 12, color: Color(0xFF8F9BBA)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoIcon(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF8F9BBA)),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF1B2559)),
        ),
      ],
    );
  }
}
