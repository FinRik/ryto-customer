import 'package:flutter/material.dart';
import 'package:ryto_customer/ui/widgets/currency_formatter_widget.dart';

import '../../../../../core/models/booking/booking_summary.dart';

class PriceBreakdownWidget extends StatelessWidget {
  final BookingSummary summary;
  final bool isTripBooking;
  final int? seats;
  const PriceBreakdownWidget({
    super.key,
    required this.summary,
    this.isTripBooking = false,
    this.seats,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _PriceRow(
          label: isTripBooking ? "${seats ?? 1} seat(s)" : "Base Delivery",
          value: summary.seatPrice!.formatted!,
        ),
        if (summary.packagePrice != "NGN 0" ||
            summary.packagePrice != "USD 0") ...[
          const SizedBox(height: 12),
          _PriceRow(
            label: "Package Price",
            value: summary.packagePrice!.formatted!,
            isAmount: true,
          ),
        ],
        if (summary.surgePercentageFormatted != null) ...[
          const SizedBox(height: 12),
          _PriceRow(label: "Surge %", value: summary.surgePercentageFormatted!, isAmount: false),
          const SizedBox(height: 12),
          _PriceRow(
            label: "Service Fee",
            value: summary.surgePrice!.formatted!,
            isAmount: true,
          ),
        ],
        const SizedBox(height: 12),
        const Divider(),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Total",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            CurrencyFormatterWidget(
              amount: summary.surgePercentageFormatted != null || summary.surgePercentageFormatted!.isNotEmpty
                  ? summary.finalPrice!.formatted!
                  : summary.totalPrice!.formatted!,
              builder: (ctx, value, rawAmount) => Text(
                value,
                style: const TextStyle(
                  fontFamily: "Roboto",
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff0B64F4),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isAmount;
  const _PriceRow({
    required this.label,
    required this.value,
    this.isAmount = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        if (isAmount)
          CurrencyFormatterWidget(
            amount: value,
            builder: (ctx, value, rawAmount) => Text(
              value,
              style: const TextStyle(
                fontFamily: "Roboto",
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        else
          Text(
            value,
            style: const TextStyle(
              fontFamily: "Roboto",
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
      ],
    );
  }
}
