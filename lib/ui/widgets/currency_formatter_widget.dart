import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import '../../app/app_setup_locator.dart';
import '../../core/setups/region_identity_setup.dart';

typedef CurrencyBuilder = Widget Function(BuildContext context, String formattedAmount, double rawAmount);

class CurrencyFormatterWidget extends StatelessWidget {
  const CurrencyFormatterWidget({
    super.key,
    required this.amount,
    this.symbolStyle,
    this.style,
    this.textColor,
    this.builder,
  });

  final String amount;
  final TextStyle? symbolStyle, style;
  final Color? textColor;
  final CurrencyBuilder? builder;

  @override
  Widget build(BuildContext context) {
    final region = sl<RegionIdentity>();

    final cleanAmountString = amount.replaceAll(RegExp(r'[^0-9.]'), '');
    final value = double.tryParse(cleanAmountString) ?? 0.0;

    final formatter = NumberFormat.currency(
      locale: Localizations.localeOf(context).toString(),
      symbol: region.currencySymbol,
      decimalDigits: 2,
    );

    final formattedValue = formatter.format(value);

    if (builder != null) {
      return builder!(context, formattedValue, value);
    }

    final numberRegex = RegExp(r'[0-9]');
    final firstDigitIndex = formattedValue.indexOf(numberRegex);

    if (firstDigitIndex == -1) {
      return Text(formattedValue, style: style);
    }

    final symbolPart = formattedValue.substring(0, firstDigitIndex);
    final valuePart = formattedValue.substring(firstDigitIndex);

    return Text.rich(
      TextSpan(
        text: "$symbolPart ",
        style: TextStyle(
          fontFamily: "Roboto",
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: textColor,
        ).merge(symbolStyle),
        children: [
          TextSpan(
            text: valuePart,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: textColor,
            ).merge(style),
          ),
        ],
      ),
    );
  }
}