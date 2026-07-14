import 'package:flutter/material.dart';

import '../enums/bottom_sheet_type.dart';
import '../routes/router.dart';

typedef SheetBuilder<T, R> =
    Widget Function(
      SheetRequest<T> request,
      void Function(SheetResponse<R?> response) completer,
    );

class BottomSheetService {
  Map<BottomSheetType, SheetBuilder>? _sheetBuilders;

  void setCustomSheetBuilders(Map<BottomSheetType, SheetBuilder> builders) {
    _sheetBuilders = {...?_sheetBuilders, ...builders};
  }

  Future<SheetResponse<R>?> showCustomBottomSheet<R, D>({
    D? data,
    String? title,
    String? desc,
    String? btnText,
    String? svgIcon,
    required BottomSheetType variant,
  }) async {
    final context = router.configuration.navigatorKey.currentContext;

    if (context == null) {
      debugPrint("Error: Navigator context is null. Sheet cannot be shown.");
      return null;
    }

    final builder = _sheetBuilders?[variant];
    if (builder == null) {
      throw Exception("No builder registered for BottomSheetType: $variant");
    }

    final result = await showModalBottomSheet<SheetResponse<R>>(
      context: context,
      useSafeArea: true,
      isDismissible: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      useRootNavigator: true,
      builder: (context) => builder(
        SheetRequest<D>(
          data: data,
          desc: desc,
          title: title,
          btnText: btnText,
          svgIcon: svgIcon,
        ),
        (response) => _completeSheet(context, response),
      ),
    );
    return result ?? SheetResponse<R>(confirmed: false);
  }

  /// Completes the dialog and passes the [response] to the caller
  void _completeSheet<T>(BuildContext context, SheetResponse<T> response) {
    Navigator.pop(context, response);
  }
}

class SheetResponse<T> {
  final bool confirmed;
  final T? data;

  SheetResponse({this.confirmed = false, this.data});
}

class SheetRequest<T> {
  final T? data;
  final String? title;
  final String? desc;
  final String? btnText;
  final String? svgIcon;

  SheetRequest({
    required this.data,
    this.title,
    this.desc,
    this.btnText,
    this.svgIcon,
  });
}
