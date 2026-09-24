import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/services/bottom_sheet_service.dart';
import '../blocs/trip_review/trip_review_bloc.dart';
import '../widgets/buttons/button.dart';
import '../widgets/layouts/base_bottom_sheet.dart';

class TripReviewBottomSheet extends StatefulWidget {
  const TripReviewBottomSheet({
    super.key,
    required this.request,
    required this.completer,
  });

  final SheetRequest request;
  final Function(SheetResponse) completer;

  @override
  State<TripReviewBottomSheet> createState() => _TripReviewBottomSheetState();
}

class _TripReviewBottomSheetState extends State<TripReviewBottomSheet> {
  final _reviewController = TextEditingController();
  int _rating = 0;

  int get _driverId => widget.request.data['driverId'] as int;

  @override
  void initState() {
    super.initState();
    // Clear any leftover status from a previous review submission
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TripReviewBloc>().add(ResetTripReview());
    });
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  void _submitReview() {
    if (_rating == 0) return;

    context.read<TripReviewBloc>().add(
      SubmitTripReview(
        rating: _rating,
        driverId: _driverId,
        review: _reviewController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TripReviewBloc, TripReviewState>(
      listener: (context, state) {
        if (state.status == TripReviewStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Thanks for rating your trip!")),
          );
          widget.completer(SheetResponse(confirmed: true));
        } else if (state.status == TripReviewStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? "Failed to submit review"),
            ),
          );
        }
      },
      builder: (context, state) {
        final isBusy = state.status == TripReviewStatus.loading;

        return BaseBottomSheet(
          multiplier: .65,
          builder: (context, size) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 45,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E5F2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Rate your trip",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B2559),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "How was your experience with your driver?",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 20),

              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    final starValue = index + 1;
                    return GestureDetector(
                      onTap: isBusy
                          ? null
                          : () => setState(() => _rating = starValue),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(
                          starValue <= _rating ? Icons.star : Icons.star_border,
                          size: 40,
                          color: const Color(0xFFFFB853),
                        ),
                      ),
                    );
                  }),
                ),
              ),

              const SizedBox(height: 24),
              TextFormField(
                controller: _reviewController,
                enabled: !isBusy,
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: "Share more about your experience (optional)",
                  fillColor: const Color(0xFFF4F7FE),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF1B2559)),
                  ),
                ),
              ),

              const SizedBox(height: 24),
              Button(
                text: "Submit review",
                isBusy: isBusy,
                enabled: _rating > 0,
                onTap: (isBusy || _rating == 0) ? null : _submitReview,
              ),
            ],
          ),
        );
      },
    );
  }
}
