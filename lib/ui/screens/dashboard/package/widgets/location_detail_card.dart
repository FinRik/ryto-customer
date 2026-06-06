import 'package:flutter/material.dart';

import '../../../../../core/models/lat_lng.dart';
import '../../../../widgets/location_fetch_builder.dart';

class LocationDetailCard extends StatelessWidget {
  final String locationName;
  final String? openingHours;
  final LatLng coord;

  const LocationDetailCard({
    super.key,
    required this.locationName,
    this.openingHours,
    required this.coord,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xffE7E8E9), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            locationName,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: Color(0xff222328),
            ),
          ),
          const SizedBox(height: 4),
          LocationFetchBuilder(
            address: coord,
            builder: (context, LatLng? p2) {
              return Text(
                p2!.address!,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 13,
                  color: Color(0xff4B4E5A),
                ),
              );
            },
          ),
          if (openingHours != null) ...[
            const SizedBox(height: 6),
            Text(
              openingHours!,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: Color(0xff838794),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
