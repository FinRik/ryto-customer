import '../../app/app_setup_locator.dart';
import '../../ui/bottom_sheets/chat_bottom_sheet.dart';
import '../../ui/bottom_sheets/cities_bottom_sheet.dart';
import '../../ui/bottom_sheets/contact_support_bottom_sheet.dart';
import '../../ui/bottom_sheets/paystack_bottom_sheet.dart';
import '../../ui/bottom_sheets/region_selector_bottom_sheet.dart';
import '../../ui/bottom_sheets/states_bottom_sheet.dart';
import '../../ui/bottom_sheets/trip_review_bottom_sheet.dart';
import '../enums/bottom_sheet_type.dart';
import '../services/bottom_sheet_service.dart';

/// create a base function with a variant
/// parameter to pass an enum
Future<void> setupBottomSheetUi() async {
  final bottomSheetService = sl<BottomSheetService>();

  final Map<BottomSheetType, SheetBuilder> builders = {
    BottomSheetType.regionSelector: (request, completer) => RegionSelectorBottomSheet(request: request, completer: completer),
    BottomSheetType.fetchStates: (request, completer) => StatesBottomSheet(request: request, completer: completer),
    BottomSheetType.fetchCities: (request, completer) => CitiesBottomSheet(request: request, completer: completer),
    BottomSheetType.chat: (request, completer) => ChatBottomSheet(request: request, completer: completer),
    BottomSheetType.paystackPayment: (request, completer) => PaystackBottomSheet(request: request, completer: completer),
    BottomSheetType.tripReview: (request, completer) => TripReviewBottomSheet(request: request, completer: completer),
    BottomSheetType.contactSupport: (request, completer) => ContactSupportBottomSheet(request: request, completer: completer),
  };

  bottomSheetService.setCustomSheetBuilders(builders);
}