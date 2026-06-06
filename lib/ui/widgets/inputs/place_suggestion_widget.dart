import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../app/app_setup_locator.dart';
import '../../../core/models/lat_lng.dart';
import '../../../core/models/places_autocomplete.dart';
import '../../../core/repos/places_repo.dart';
import '../../../core/setups/region_identity_setup.dart';

// class PlacesSuggestionWidget extends StatefulWidget {
//   final String hint;
//   final String? label;
//   final Function(LatLng)? onPlaceSelected;
//   final TextEditingController? controller;
//   final TextStyle? labelStyle;
//   final String? prefixSvg;
//   final IconData? prefixIcon;
//   final double? borderRadius;
//
//   const PlacesSuggestionWidget({
//     super.key,
//     this.label,
//     this.hint = 'Type a place name...',
//     this.onPlaceSelected,
//     this.controller,
//     this.labelStyle,
//     this.prefixSvg,
//     this.prefixIcon = Icons.text_increase_rounded,
//     this.borderRadius,
//   });
//
//   @override
//   State<PlacesSuggestionWidget> createState() => _PlacesSuggestionWidgetState();
// }
//
// class _PlacesSuggestionWidgetState extends State<PlacesSuggestionWidget> {
//   final _placesRepo = sl<PlacesRepo>();
//   late final TextEditingController _controller;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = widget.controller ?? TextEditingController();
//   }
//
//   @override
//   void dispose() {
//     if (widget.controller == null) _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (widget.label != null)
//           Text(
//             widget.label!,
//             style: const TextStyle(
//               color: Color(0xff696E7E),
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//             ).merge(widget.labelStyle ?? const TextStyle()),
//           ),
//         SizedBox(height: 4.0),
//         TypeAheadField<Prediction>(
//           controller: _controller,
//           debounceDuration: const Duration(
//             milliseconds: 300,
//           ), // good UX + cost saving
//           hideOnEmpty: false,
//           hideOnLoading: false,
//           hideOnError: false,
//
//           // STATE HANDLING BUILDERS
//           loadingBuilder: (context) => const Padding(
//             padding: EdgeInsets.all(16.0),
//             child: Center(child: CircularProgressIndicator()),
//           ),
//           emptyBuilder: (context) => const Padding(
//             padding: EdgeInsets.all(16.0),
//             child: Text(
//               'No places found',
//               style: TextStyle(color: Colors.grey),
//             ),
//           ),
//
//           errorBuilder: (context, error) {
//             print("Suggestion error: ${error.toString()}");
//             return _SuggestionErrorWidget(message: _mapErrorToMessage(error));
//           },
//
//           suggestionsCallback: (pattern) async =>
//               await _placesRepo.getSuggestions(pattern),
//
//           itemBuilder: (context, suggestion) {
//             return ListTile(
//               leading: const Icon(Icons.location_on, color: Colors.blueGrey),
//               title: Text(
//                 suggestion.description,
//                 style: const TextStyle(fontWeight: FontWeight.w500),
//               ),
//               subtitle: Text(
//                 suggestion.structuredFormatting.secondaryText,
//                 style: const TextStyle(fontSize: 12, color: Colors.grey),
//               ),
//             );
//           },
//
//           onSelected: (suggestion) async {
//             final result = suggestion.structuredFormatting.mainText;
//             _controller.text = result;
//             final placeId = suggestion.placeId;
//             print("Getting coord data: $result");
//             final coord = await _placesRepo.getLatLngFromPlaceId(
//               placeId,
//               result,
//             );
//             print("Coord Data: ${coord?.toJson()}");
//             if (coord != null) {
//               widget.onPlaceSelected?.call(coord);
//             } else {
//               print("Could not find coordinates");
//             }
//           },
//
//           builder: (context, controller, focusNode) {
//             return TextField(
//               controller: controller,
//               focusNode: focusNode,
//               decoration: InputDecoration(
//                 hintText: widget.hint,
//                 prefixIcon: widget.prefixIcon != null
//                     ? Container(
//                         margin: const EdgeInsets.only(
//                           top: 4.0,
//                           bottom: 4.0,
//                           left: 4,
//                         ),
//                         child: widget.prefixSvg != null
//                             ? SvgPicture.asset(widget.prefixSvg!)
//                             : Icon(widget.prefixIcon),
//                       )
//                     : null,
//               ),
//             );
//           },
//         ),
//         SizedBox(height: 12),
//       ],
//     );
//   }
//   // Inside your _PlacesSuggestionWidgetState
//
//   String _mapErrorToMessage(Object error) {
//     final errString = error.toString().toLowerCase();
//
//     if (errString.contains('socketexception') ||
//         errString.contains('network')) {
//       return "Check your internet connection and try again.";
//     } else if (errString.contains('over_query_limit')) {
//       return "Service is temporarily busy. Please try again in a moment.";
//     } else if (errString.contains('denied') || errString.contains('invalid')) {
//       return "Location service configuration error.";
//     }
//
//     return "Something went wrong while searching. Please try again.";
//   }
// }
//
// class _SuggestionErrorWidget extends StatelessWidget {
//   final String message;
//   final IconData icon;
//
//   const _SuggestionErrorWidget({
//     super.key,
//     required this.message,
//     this.icon = Icons.error_outline_rounded,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, color: Colors.redAccent.shade100, size: 32),
//           const SizedBox(height: 8),
//           Text(
//             message,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               color: Colors.grey.shade700,
//               fontSize: 13,
//               fontWeight: FontWeight.w400,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class PlacesSuggestionWidget extends StatefulWidget {
  final String hint;
  final String? label;
  final Function(LatLng)? onPlaceSelected;
  final TextEditingController? controller;
  final TextStyle? labelStyle;
  final String? prefixSvg;
  final IconData? prefixIcon;
  final double? borderRadius;

  const PlacesSuggestionWidget({
    super.key,
    this.label,
    this.hint = 'Type a place name...',
    this.onPlaceSelected,
    this.controller,
    this.labelStyle,
    this.prefixSvg,
    this.prefixIcon = Icons.text_increase_rounded,
    this.borderRadius,
  });

  @override
  State<PlacesSuggestionWidget> createState() => _PlacesSuggestionWidgetState();
}

class _PlacesSuggestionWidgetState extends State<PlacesSuggestionWidget> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  Future<List<Prediction>?> fetchPlaces(String pattern) async {
    final region = sl<RegionIdentity>();
    final placesRepo = context.read<PlacesRepo>();
    final result = await placesRepo.getSuggestions(pattern, country: region.countryCode.toLowerCase());
    return result;
  }

  Future<LatLng?> fetchLatLng(String placeId, String result) async {
    final placesRepo = context.read<PlacesRepo>();
    final latLng = await placesRepo.getLatLngFromPlaceId(
      placeId,
      result,
    );
    return latLng;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Text(
            widget.label!,
            style: const TextStyle(
              color: Color(0xff696E7E),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ).merge(widget.labelStyle ?? const TextStyle()),
          ),
        SizedBox(height: 4.0),
        TypeAheadField<Prediction>(
          controller: _controller,
          debounceDuration: const Duration(
            milliseconds: 300,
          ), // good UX + cost saving
          hideOnEmpty: false,
          hideOnLoading: false,
          hideOnError: false,

          // STATE HANDLING BUILDERS
          loadingBuilder: (context) => const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          ),
          emptyBuilder: (context) => const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'No places found',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          errorBuilder: (context, error) {
            String? formattedError;
            if(error.toString().contains("REQUEST_DENIED")){
              formattedError = "Request Denied";
            } else {
              formattedError = "Failed to fetch location";
            }
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                formattedError,
                style: const TextStyle(color: Colors.red),
              ),
            );
          },

          suggestionsCallback: fetchPlaces,
          itemBuilder: (context, suggestion) {
            return ListTile(
              leading: const Icon(Icons.location_on, color: Colors.blueGrey),
              title: Text(
                suggestion.description,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                suggestion.structuredFormatting.secondaryText,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            );
          },

          onSelected: (suggestion) async {
            _controller.text = suggestion.description;
            final result = suggestion.structuredFormatting.mainText;
            final placeId = suggestion.placeId;
            print("Getting coord data: $result");
            final coord = await fetchLatLng(placeId, result);
            print("Coord Data: ${coord?.toJson()}");
            if (coord != null) {
              widget.onPlaceSelected?.call(coord);
            } else {
              print("Could not find coordinates");
            }
          },

          builder: (context, controller, focusNode) {
            return TextField(
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: widget.hint,
                prefixIcon: widget.prefixIcon != null
                    ? Container(
                  margin: const EdgeInsets.only(
                    top: 8.0,
                    bottom: 8.0,
                    left: 12,
                  ),
                  child: widget.prefixSvg != null
                      ? SvgPicture.asset(widget.prefixSvg!)
                      : Icon(widget.prefixIcon),
                )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    widget.borderRadius ?? 100,
                  ),
                  borderSide: BorderSide(width: 1, color: Color(0xffE5E5E6)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    widget.borderRadius ?? 100,
                  ),
                  borderSide: BorderSide(width: 1, color: Color(0xffE5E5E6)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    widget.borderRadius ?? 100,
                  ),
                  borderSide: BorderSide(width: 1, color: Color(0xffE5E5E6)),
                ),
                filled: false,
                fillColor: Colors.grey.shade100,
              ),
            );
          },
        ),
        SizedBox(height: 12),
      ],
    );
  }
}
